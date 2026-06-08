@Entry
@Component
struct SettingPage {
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
        Text('Settings')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Scroll() {
        Column({ space: 8 }) {
          Text('Playback')
            .fontSize(14)
            .fontColor('#888')
            .margin({ top: 12 })

          Text('Sound Quality')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Mobile Data Playback')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Cache While Playing')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Lyrics Display')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)

          Text('Other')
            .fontSize(14)
            .fontColor('#888')
            .margin({ top: 12 })

          Text('About')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Check Update')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Clear Cache')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
          Text('Privacy Policy')
            .fontSize(16)
            .fontColor(Color.White)
            .width('100%')
            .padding(14)
            .backgroundColor('#1d1d1f')
            .borderRadius(8)
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
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
export function SettingBuilder(): void {
  SettingPage();
}
