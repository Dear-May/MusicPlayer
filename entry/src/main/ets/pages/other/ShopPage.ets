@Entry
@Component
struct ShopPage {
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
        Text('Shop')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Scroll() {
        Column() {
          Column() {
            Text('Member Special Offer')
              .fontSize(20)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
            Text('Get VIP for unlimited music')
              .fontSize(14)
              .fontColor('#888')
              .margin({ top: 8 })
            Button() {
              Text('Subscribe')
                .fontSize(14)
                .fontColor(Color.White)
            }
            .backgroundColor('#ff4a4a')
            .borderRadius(16)
            .height(32)
            .padding({ left: 20, right: 20 })
            .margin({ top: 12 })
          }
          .width('100%')
          .height(140)
          .backgroundColor('#1d1d1f')
          .borderRadius(12)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          Text('Products')
            .fontSize(18)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .margin({ top: 20, bottom: 12 })

          Grid() {
            GridItem() {
              Column() {
                Text('VIP Monthly')
                  .fontSize(14)
                  .fontColor(Color.White)
                Text('$15')
                  .fontSize(16)
                  .fontColor('#ff4a4a')
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 8 })
              }
              .width('100%')
              .height(80)
              .backgroundColor('#1d1d1f')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
            }
            GridItem() {
              Column() {
                Text('VIP Quarterly')
                  .fontSize(14)
                  .fontColor(Color.White)
                Text('$40')
                  .fontSize(16)
                  .fontColor('#ff4a4a')
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 8 })
              }
              .width('100%')
              .height(80)
              .backgroundColor('#1d1d1f')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
            }
            GridItem() {
              Column() {
                Text('VIP Yearly')
                  .fontSize(14)
                  .fontColor(Color.White)
                Text('$128')
                  .fontSize(16)
                  .fontColor('#ff4a4a')
                  .fontWeight(FontWeight.Bold)
                  .margin({ top: 8 })
              }
              .width('100%')
              .height(80)
              .backgroundColor('#1d1d1f')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Center)
            }
          }
          .columnsTemplate('1fr 1fr 1fr')
          .columnsGap(8)
          .rowsGap(8)
          .width('100%')
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
export function ShopBuilder(): void {
  ShopPage();
}
