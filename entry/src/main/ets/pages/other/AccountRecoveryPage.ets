@Entry
@Component
struct AccountRecoveryPage {
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
        Text('Account Recovery')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      Column({ space: 20 }) {
        Text('Recover your account via phone or email')
          .fontSize(14)
          .fontColor('#888')
          .textAlign(TextAlign.Center)

        Column({ space: 12 }) {
          Row() {
            Column() {
              Text('Phone')
                .fontSize(14)
                .fontColor(Color.White)
            }
            .width(60)
            .height(60)
            .backgroundColor('#29282c')
            .borderRadius(30)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)

            Column({ space: 4 }) {
              Text('Phone Recovery')
                .fontSize(16)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Medium)
              Text('Reset via phone number')
                .fontSize(12)
                .fontColor('#666')
            }
            .margin({ left: 16 })
            .layoutWeight(1)

            Image($r('app.media.ic_more'))
              .width(20)
              .height(20)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(12)

          Row() {
            Column() {
              Text('Email')
                .fontSize(14)
                .fontColor(Color.White)
            }
            .width(60)
            .height(60)
            .backgroundColor('#29282c')
            .borderRadius(30)
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Center)

            Column({ space: 4 }) {
              Text('Email Recovery')
                .fontSize(16)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Medium)
              Text('Reset via email address')
                .fontSize(12)
                .fontColor('#666')
            }
            .margin({ left: 16 })
            .layoutWeight(1)

            Image($r('app.media.ic_more'))
              .width(20)
              .height(20)
          }
          .width('100%')
          .padding(16)
          .backgroundColor('#1d1d1f')
          .borderRadius(12)
        }
        .width('100%')
        .padding(16)
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

@Builder
export function AccountRecoveryBuilder(): void {
  AccountRecoveryPage();
}
