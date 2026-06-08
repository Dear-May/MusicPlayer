@Entry
@Component
struct MessagePage {
  build() {
    Column() {
      Row() {
        Image($r('app.media.menu'))
          .width(24)
          .height(24)
          .rotate({ angle: 90 })
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
        Text('Messages')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Scroll() {
        Column({ space: 1 }) {
          Text('Member到期通知')
            .fontSize(14)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
          Text('Recommendation update')
            .fontSize(14)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
          Text('Activity reminder')
            .fontSize(14)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
          Text('Comment reply')
            .fontSize(14)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
          Text('System notice')
            .fontSize(14)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
        }
        .width('100%')
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

@Builder
export function MessageBuilder(): void {
  MessagePage();
}
