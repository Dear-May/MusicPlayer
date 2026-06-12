import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import SongManager from '../utils/SongManager';
import UserStateManager from '../feature/user/UserStateManager';
import LoginApi from '../feature/login/LoginApi';
import HttpManager from '../common/network/HttpManager';
import { UserProfile } from '../common/models/ApiTypes';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
    // 初始化SongManager的context
    SongManager.context = this.context;
    // 恢复登录状态（Cookie和用户信息）
    UserStateManager.restoreLogin(this.context);
    // 异步校验session有效性
    EntryAbility.validateSession();
  }

  static async validateSession(): Promise<void> {
    const http: HttpManager = HttpManager.getInstance();
    if (!http.hasLogin()) {
      return;
    }
    try {
      const status = await LoginApi.getLoginStatus();
      if (status.code !== 200) {
        http.clearCookie();
        AppStorage.setOrCreate<boolean>('isLoggedIn', false);
        AppStorage.setOrCreate<UserProfile | null>('userInfo', null);
        console.info('EntryAbility: session expired, cleared login state');
      }
    } catch (_err) {
      console.warn('EntryAbility: session check failed, keeping cached state');
    }
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/login/WelcomePage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
    // 从后台恢复时刷新登录态
    EntryAbility.validateSession();
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
