@Entry
@Component
struct TicketPage {
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
        Text('Events')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Scroll() {
        Column({ space: 16 }) {
          Text('Recommended Events')
            .fontSize(18)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .width('100%')

          Column() {
            Text('Summer Music Festival')
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
            Text('2026.08.15 National Stadium')
              .fontSize(12)
              .fontColor('#888')
              .margin({ top: 4 })
            Text('$380-1980')
              .fontSize(14)
              .fontColor('#ff4a4a')
              .margin({ top: 4 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(12)

          Column() {
            Text('JJ Lin World Tour')
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
            Text('2026.09.20 Hongkou Stadium')
              .fontSize(12)
              .fontColor('#888')
              .margin({ top: 4 })
            Text('$480-2280')
              .fontSize(14)
              .fontColor('#ff4a4a')
              .margin({ top: 4 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(12)

          Column() {
            Text('Classical Music Gala')
              .fontSize(16)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
            Text('2026.10.05 National Theatre')
              .fontSize(12)
              .fontColor('#888')
              .margin({ top: 4 })
            Text('$180-880')
              .fontSize(14)
              .fontColor('#ff4a4a')
              .margin({ top: 4 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(12)
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
export function TicketBuilder(): void {
  TicketPage();
}
