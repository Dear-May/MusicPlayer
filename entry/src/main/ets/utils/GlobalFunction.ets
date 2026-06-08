/**
 * 全局工具函数
 */

export function changeSideBarShow(context: UIContext) {
  context.animateTo({
    duration: 300,
    curve: Curve.EaseOut,
    playMode: PlayMode.Normal,
  }, () => {
    const current = AppStorage.get<boolean>('showSideBar') ?? false;
    AppStorage.setOrCreate('showSideBar', !current);
  });
}

export function tryCloseSideBar(context: UIContext, show: boolean, onNotShow?: () => void) {
  if (show) {
    changeSideBarShow(context);
  } else {
    onNotShow?.();
  }
}

/**
 * 统一页面跳转方法
 */
export function navigateToPage(context: UIContext, url: string, params?: Object) {
  context.getRouter().pushUrl({ url: url, params: params }, (err) => {
    if (err) {
      console.error('页面跳转失败', err);
    } else {
      console.info('页面跳转成功');
    }
  });
}

/**
 * 统一页面替换方法
 */
export function replacePage(context: UIContext, url: string, params?: Object) {
  context.getRouter().replaceUrl({ url: url, params: params }, (err) => {
    if (err) {
      console.error('页面跳转失败', err);
    } else {
      console.info('页面跳转成功');
    }
  });
}

/**
 * 统一的顶部搜索栏跳转
 */
export function navigateToSearch(context: UIContext, showSideBar: boolean) {
  tryCloseSideBar(context, showSideBar, () => {
    navigateToPage(context, 'pages/SearchPage');
  });
}
