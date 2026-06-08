@Entry
@Component
struct TimedShutdownPage {
  @State selectedIndex: number = -1;

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
        Text('Sleep Timer')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Column({ space: 8 }) {
        Text('Off')
          .fontSize(16)
          .fontColor(Color.White)
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(8)
          .onClick(() => {
            this.selectedIndex = 0;
          })
        Text('10 min')
          .fontSize(16)
          .fontColor(Color.White)
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(8)
          .onClick(() => {
            this.selectedIndex = 1;
          })
        Text('15 min')
          .fontSize(16)
          .fontColor(Color.White)
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(8)
          .onClick(() => {
            this.selectedIndex = 2;
          })
        Text('30 min')
          .fontSize(16)
          .fontColor(Color.White)
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(8)
          .onClick(() => {
            this.selectedIndex = 3;
          })
        Text('60 min')
          .fontSize(16)
          .fontColor(Color.White)
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(8)
          .onClick(() => {
            this.selectedIndex = 4;
          })
      }
      .width('100%')
      .padding(16)
      .layoutWeight(1)

      if (this.selectedIndex > 0) {
        Button() {
          Text('Confirm')
            .fontSize(16)
            .fontColor(Color.White)
        }
        .width('90%')
        .height(48)
        .backgroundColor('#ff4a4a')
        .borderRadius(24)
        .margin({ bottom: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

@Builder
export function TimedShutdownBuilder(): void {
  TimedShutdownPage();
}
