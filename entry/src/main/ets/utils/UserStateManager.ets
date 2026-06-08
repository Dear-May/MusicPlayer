/**
 * 全局用户登录状态管理器
 * 使用AppStorage存储登录态信息，以便各组件共享
 */
import HttpManager from './api/HttpManager';
import { UserProfile } from './api/ApiTypes';
import { preferences } from '@kit.ArkData';

/** 持久化存储的key */
const STORE_NAME = 'user_state';
const STORAGE_COOKIE_KEY = 'netease_cookie';
const STORAGE_USER_KEY = 'netease_user_info';

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

  /** 初始化登录状态：从持久化存储恢复Cookie */
  static restoreLogin(ctx: Context): void {
    try {
      const store = getStore(ctx);
      if (!store) {
        return;
      }
      // 恢复Cookie
      const savedCookie = store.getSync(STORAGE_COOKIE_KEY, '') as string;
      if (savedCookie) {
        UserStateManager.httpManager.setCookie(savedCookie);
        console.info('UserStateManager: cookie restored');
      }

      // 恢复用户信息
      const savedUser = store.getSync(STORAGE_USER_KEY, '') as string;
      if (savedUser) {
        const userInfo = JSON.parse(savedUser) as UserProfile;
        AppStorage.setOrCreate<UserProfile | null>('userInfo', userInfo);
        AppStorage.setOrCreate<boolean>('isLoggedIn', true);
        console.info('UserStateManager: user info restored');
      }
    } catch (err) {
      console.error('UserStateManager restoreLogin error:', JSON.stringify(err));
    }
  }

  /** 登录成功后保存登录态 */
  static async onLoginSuccess(ctx: Context, profile: UserProfile): Promise<void> {
    // 保存到内存共享
    AppStorage.setOrCreate<UserProfile | null>('userInfo', profile);
    AppStorage.setOrCreate<boolean>('isLoggedIn', true);

    // 持久化Cookie和用户信息
    try {
      const store = getStore(ctx);
      if (!store) {
        return;
      }
      const cookie = UserStateManager.httpManager.getCookie();
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

  /** 退出登录 */
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

  /** 检查当前是否已登录 */
  static isLoggedIn(): boolean {
    return UserStateManager.httpManager.hasLogin() || (AppStorage.get<boolean>('isLoggedIn') ?? false);
  }
}
