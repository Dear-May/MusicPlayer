@Entry
@Component
struct MorePage {
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
        Text('More')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Scroll() {
        Column({ space: 8 }) {
          Text('Night Mode')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Data Usage')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Equalizer')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Downloads')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Privacy')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Notifications')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Storage')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Feedback')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
        }
        .width('100%')
        .padding(16)
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
export function MoreBuilder(): void {
  MorePage();
}
