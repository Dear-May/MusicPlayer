@Entry
@Component
struct LoginPage {
  @State phone: string = ''
  @State agree: boolean = false

  build() {
    Column({ space: 20 }) {
      // 顶部立即体验
      Column() {
        Text('立即体验')
          .fontSize(16)
          .fontColor('#888')
          .padding({ top: 10, right: 20 })
          .onClick(() => {
            console.log('点击了立即体验')
          })
      }
      .alignItems(HorizontalAlign.End)
      .width('100%')

      Column() {
        // LOGO
        Column() {
          Image($r("app.media.foreground"))
            .width('60')
            .height('60')
            .objectFit(ImageFit.Contain)
        }
        .width(90)
        .height(90)
        .borderRadius(45)
        .backgroundColor('#ec271b')
        .padding(15)

        // 手机输入框
        Row({ space: 10 }) {
          Text('+86')
            .fontSize(20)
            .fontColor('#ccc')
            .fontWeight(FontWeight.Bold)
          TextInput({
            placeholder: '输入手机号',
            text: this.phone,
            // onChange: val => this.phone = val
          })
            .fontColor('#666')
            .fontSize(16)
            .width('70%')
        }
        .padding(10)
        .backgroundColor('#2a2a2a')
        .borderRadius(10)
        .margin({ top: '45%', left: 30, right: 30 })

        // 登录按钮
        Button('验证码登录')
          .fontSize(16)
          .fontColor('#fff')
          .backgroundColor('#fe3a3b')
          .borderRadius(22.5)
          .width('75%')
          .height(45)
          .margin({ top: 20 })
          .onClick(() => {
            console.log('点击登录，手机号:', this.phone)
          })

        // 勾选协议
        Row({ space: 5 }) {
          Checkbox({ group: 'agree' })
            .onChange(val => this.agree = val)
          Text('我已阅读并同意')
            .fontColor('#aaa')
            .fontSize(12)
          Text('《服务条款》、 《隐私政策》')
            .fontColor('#3388ff')
            .fontSize(12)
        }
        .margin({ top: 10 })
      }
      .margin({ top: '30%' })

      // 底部提示
      Column() {
        Row({ space: 5 }) {
          Text('登录遇到问题')
            .fontSize(14)
            .fontColor('#666')
          Text('|')
            .fontColor('#666')
          Text('其他登录方式 >')
            .fontSize(14)
            .fontColor('#666')
        }
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .position({ bottom: 10 })
    }
    .backgroundColor('#1A0B1E')
    .width('100%')
    .height('100%')
    .padding(5)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP],)
  }
}

@Builder
export function LoginBuilder(): void {
  LoginPage()
}