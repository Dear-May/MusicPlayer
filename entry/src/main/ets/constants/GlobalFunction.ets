export function changeSideBarShow(context: UIContext) {
  context.animateTo({
    duration: 1500,
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
