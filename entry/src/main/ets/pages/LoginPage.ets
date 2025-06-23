import { router } from "@kit.ArkUI"

@Entry
@Component
struct LoginPage {
  @State phone: string = ''
  @State agree: boolean = false
  @State showExperiencePopup: boolean = false
  @State showProblemPopup: boolean = false

  closePopup() {
    animateTo({
      duration: 300, // 动画持续时间(毫秒)
      curve: Curve.EaseOut, // 缓动曲线
      onFinish: () => {
        console.info('卡片动画完成') // 动画完成回调
      }
    }, () => {
      this.showExperiencePopup = !this.showExperiencePopup // 在动画函数中切换状态
    })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column({ space: 20 }) {
        // 顶部立即体验
        Column() {
          Text('立即体验')
            .fontSize(16)
            .fontColor('#888')
            .padding({ top: 10, right: 20 })
            .onClick(() => this.closePopup())
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
              .onClick(() => {
                console.log('点击了《服务条款》、 《隐私政策》')
              })
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

      if (this.showExperiencePopup) {
        Column() {
          // 点击空白区域关闭弹窗
          Blank()
            .width('100%')
            .height('100%')
            .onClick(() => this.closePopup())

          // 弹出内容
          Column() {
            Text('服务协议和隐私政策等指引')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('sys.color.white'))
              .margin({ bottom: 8 })

            Column() {
              Text('进入下一步前，请阅读并同意网易云音乐的')
                .fontSize(14)
                .fontColor('#AAAAAA')
                .textAlign(TextAlign.Start)
                .lineHeight(22)
                .margin({ bottom: 5 })
              Text('《服务条款》、 《隐私政策》')
                .fontSize(14)
                .fontColor('#3388ff')
                .textAlign(TextAlign.Start)
                .lineHeight(22)
                .onClick(() => {
                  console.log('点击了《服务条款》、 《隐私政策》')
                })
            }
            .alignItems(HorizontalAlign.Start)
            .width('100%')
            .margin({ bottom: 20 })

            Row({ space: 16 }) {
              Button('不同意')
                .backgroundColor('#1E1E1E')
                .borderColor('#FF3B30')
                .borderWidth(1)
                .fontColor('#FF3B30')
                .borderRadius(24)
                .width('45%')
                .onClick(() => this.closePopup())

              Button('同意并继续')
                .backgroundColor('#FF3B30')
                .fontColor($r('sys.color.comp_background_list_card'))
                .borderRadius(24)
                .width('45%')
                .onClick(() => {
                  router.pushUrl({ url: 'pages/Index' }, (err) => {
                    if (err) {
                      console.error('页面跳转失败', err);
                    } else {
                      console.info('页面跳转成功');
                    }
                  });
                })
            }
          }
          .width('100%')
          .backgroundColor('#1c1c1e')
          .borderRadius({ topLeft: 20, topRight: 20 })
          .position({ x: 0, y: '78%' })
          .padding(30)
          .alignItems(HorizontalAlign.Center)
          .animation({
            duration: 300,
            curve: Curve.EaseOut
          })
        }
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .width('100%')
        .height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP],)
      }
    }
  }
}

@Builder
export function LoginBuilder(): void {
  LoginPage()
}