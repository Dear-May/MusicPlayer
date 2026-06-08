@Entry
@Component
struct ClothingPage {
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
        Text('Themes')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Scroll() {
        Column() {
          Text('Current Theme')
            .fontSize(16)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .margin({ bottom: 12 })

          Column() {
            Text('Default')
              .fontSize(18)
              .fontColor(Color.White)
          }
          .width(100)
          .height(80)
          .backgroundColor('#29282c')
          .borderRadius(12)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          Text('All Themes')
            .fontSize(16)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .margin({ top: 20, bottom: 12 })

          Column({ space: 8 }) {
            Text('Classic Dark')
              .fontSize(16)
              .fontColor(Color.White)
              .width('100%')
              .padding(14)
              .backgroundColor('#1d1d1f')
              .borderRadius(8)
            Text('Starry Night')
              .fontSize(16)
              .fontColor(Color.White)
              .width('100%')
              .padding(14)
              .backgroundColor('#1d1d1f')
              .borderRadius(8)
            Text('Minimal White')
              .fontSize(16)
              .fontColor(Color.White)
              .width('100%')
              .padding(14)
              .backgroundColor('#1d1d1f')
              .borderRadius(8)
          }
          .width('100%')
        }
        .width('100%')
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor('#0e0d11')
  }
}

@Builder
export function ClothingBuilder(): void {
  ClothingPage();
}
