import { router } from "@kit.ArkUI"

@Entry
@Component
struct TestPage {
  @State showPopup: boolean = false

  closePopup() {
    animateTo({
      duration: 300, // 动画持续时间(毫秒)
      curve: Curve.EaseOut, // 缓动曲线
      onFinish: () => {
        console.info('卡片动画完成') // 动画完成回调
      }
    }, () => {
      this.showPopup = !this.showPopup // 在动画函数中切换状态
    })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Button() {
        Text("点击弹出")
      }
      .onClick(() => {
        this.showPopup = true
      })

      if (this.showPopup) {
        Column() {
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
          .position({ x: 0, y: '80%' })
          .padding(30)
          .alignItems(HorizontalAlign.Center)
          .animation({
            duration: 300,
            curve: Curve.EaseOut
          })
        }
        .backgroundColor('#dd271c')
        .width('100%')
        .height('100%')
      }

    }
  }
}

@Builder
export function TestBuilder(): void {
  TestPage()
}