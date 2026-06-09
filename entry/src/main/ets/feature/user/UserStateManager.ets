/**
 * Global login state manager
 * @layer feature/user
 * Uses AppStorage for cross-component login state sharing
 */
import HttpManager from '../../common/network/HttpManager';
import { UserProfile } from '../../common/models/ApiTypes';
import { preferences } from '@kit.ArkData';

const STORE_NAME: string = 'user_state';
const STORAGE_COOKIE_KEY: string = 'netease_cookie';
const STORAGE_USER_KEY: string = 'netease_user_info';

let userStore: preferences.Preferences | null = null;

function getStore(ctx: Context): preferences.Preferences | null {
  if (userStore) {
    return userStore;
  }
  try {
    userStore = preferences.getPreferencesSync(ctx, { name: STORE_NAME });
    return userStore;
  } catch (err) {
    console.error('UserStateManager getStore error:', JSON.stringify(err));
    return null;
  }
}

export default class UserStateManager {
  private static httpManager: HttpManager = HttpManager.getInstance();

  static restoreLogin(ctx: Context): void {
    try {
      const store = getStore(ctx);
      if (!store) {
        return;
      }
      const savedCookie: string = store.getSync(STORAGE_COOKIE_KEY, '') as string;
      if (savedCookie) {
        UserStateManager.httpManager.setCookie(savedCookie);
        console.info('UserStateManager: cookie restored');
      }
      const savedUser: string = store.getSync(STORAGE_USER_KEY, '') as string;
      if (savedUser) {
        const userInfo: UserProfile = JSON.parse(savedUser) as UserProfile;
        AppStorage.setOrCreate<UserProfile | null>('userInfo', userInfo);
        AppStorage.setOrCreate<boolean>('isLoggedIn', true);
        console.info('UserStateManager: user info restored');
      }
    } catch (err) {
      console.error('UserStateManager restoreLogin error:', JSON.stringify(err));
    }
  }

  static async onLoginSuccess(ctx: Context, profile: UserProfile): Promise<void> {
    AppStorage.setOrCreate<UserProfile | null>('userInfo', profile);
    AppStorage.setOrCreate<boolean>('isLoggedIn', true);
    try {
      const store = getStore(ctx);
      if (!store) {
        return;
      }
      const cookie: string = UserStateManager.httpManager.getCookie();
      if (cookie) {
        store.putSync(STORAGE_COOKIE_KEY, cookie);
      }
      if (profile) {
        store.putSync(STORAGE_USER_KEY, JSON.stringify(profile));
      }
      await store.flush();
    } catch (err) {
      console.error('UserStateManager saveLogin error:', JSON.stringify(err));
    }
  }

  static async onLogout(ctx: Context): Promise<void> {
    AppStorage.setOrCreate<UserProfile | null>('userInfo', null);
    AppStorage.setOrCreate<boolean>('isLoggedIn', false);
    UserStateManager.httpManager.clearCookie();
    try {
      const store = getStore(ctx);
      if (!store) {
        return;
      }
      store.putSync(STORAGE_COOKIE_KEY, '');
      store.putSync(STORAGE_USER_KEY, '');
      await store.flush();
    } catch (err) {
      console.error('UserStateManager clearStorage error:', JSON.stringify(err));
    }
  }

  static isLoggedIn(): boolean {
    return UserStateManager.httpManager.hasLogin() || (AppStorage.get<boolean>('isLoggedIn') ?? false);
  }
}
