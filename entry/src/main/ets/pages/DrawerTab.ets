@Preview
@Component
struct DrawerTab {
  @State navList: Array<number> = [0, 1, 2, 3, 4, 5];
  @State active: number = 0;
  @State show: boolean = false;

  build() {
    Column() {
      ForEach(this.navList, (item: number, index: number) => {
        Column() {
          Row() {
            Image($r('app.media.menu'))
              .width(24)
              .height(24)
            Text('test')
              .fontSize(16)
              .fontColor(Color.Black)
              .fontWeight(FontWeight.Medium)
              .margin({ left: 17 })
          }
          .height(48)
          .width('100%')

          if (this.navList.length - 1 !== index) {
            Row()
              .height(0.5)
              .backgroundColor('#0D000000')
              .width('90%')
          }
        }
        .onClick(() => {
          this.active = item;
        })
        .margin({
          top: 4,
          left: 4,
          right: 4,
          bottom: 4
        })
        .justifyContent(FlexAlign.Center)
        .width(264)
        .height(48)
        .padding({ left: 13 })
        .borderRadius(16)
        .backgroundColor(this.active === item ? '#1A0A59F7' : '')
      }, (item: number, index: number) => JSON.stringify(item) + index)

      Row() {
        Image($r('app.media.menu'))
          .width(40)
          .height(40)
        Text('2222').margin({ left: 8 })
      }
      .width('100%')
      .margin({ top: 284 })

    }
    .height('100%')
    .padding({ top: 104 })
    .backgroundColor('#E9EAEC')
    .width(272)
    .height(344)
    .backgroundColor(Color.White)
    .borderRadius({ topRight: 16, bottomRight: 16 })
  }
}

export default DrawerTab