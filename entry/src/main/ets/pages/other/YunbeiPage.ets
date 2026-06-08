@Entry
@Component
struct YunbeiPage {
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
        Text('Cloud Coins')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Column() {
        Text('Your Balance')
          .fontSize(14)
          .fontColor('#888')
        Text('1,280')
          .fontSize(48)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ top: 8 })
      }
      .width('100%')
      .padding(24)
      .backgroundColor('#1d1d1f')
      .borderRadius(12)

      Text('Earn Coins')
        .fontSize(18)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .margin({ top: 20 })

      Text('Daily check-in +10')
        .fontSize(15)
        .fontColor(Color.White)
        .width('100%')
        .padding(14)
        .backgroundColor('#1d1d1f')
        .borderRadius(8)
        .margin({ top: 8 })
      Text('Share songs +5')
        .fontSize(15)
        .fontColor(Color.White)
        .width('100%')
        .padding(14)
        .backgroundColor('#1d1d1f')
        .borderRadius(8)
        .margin({ top: 8 })
      Text('Write comments +3')
        .fontSize(15)
        .fontColor(Color.White)
        .width('100%')
        .padding(14)
        .backgroundColor('#1d1d1f')
        .borderRadius(8)
        .margin({ top: 8 })
      Text('Create playlist +20')
        .fontSize(15)
        .fontColor(Color.White)
        .width('100%')
        .padding(14)
        .backgroundColor('#1d1d1f')
        .borderRadius(8)
        .margin({ top: 8 })
    }
    .width('100%')
    .height('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor('#0e0d11')
  }
}

@Builder
export function YunbeiBuilder(): void {
  YunbeiPage();
}
