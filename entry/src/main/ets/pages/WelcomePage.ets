@Entry
@Component
struct WelcomePage {
  pageStack: NavPathStack = new NavPathStack();
  progress: number = 0;

  aboutToAppear() {
    const timer = setInterval(() => {
      if (this.progress >= 100) {
        clearInterval(timer);
        this.pageStack.pushPath({ name: "Index", param: "" });
      } else {
        this.progress += 5;
      }
    }, 100); // 模拟进度加载
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column({ space: 30 }) {
        // LOGO 区域
        Column() {
          Image($r('app.media.logo'))
            .width('100')
            .height('100')
            .objectFit(ImageFit.Contain)
        }
        .width(130)
        .height(130)
        .borderRadius(65)
        .backgroundColor('#ec271b') // 背景红圈
        .padding(15)
        .margin({ top: '50%' })

        // 文本区域
        Column({ space: 10 }) {
          Text('网易云音乐 · 发现好音樂')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)

          Row({ space: 10 }) {
            Divider()
              .strokeWidth(1)
              .color('#e87068')
              .width('15%')

            Text('网易云音乐支持 IPv6 网络')
              .fontSize(10)
              .fontColor('#e87068')
              .textAlign(TextAlign.Center)

            Divider()
              .strokeWidth(1)
              .color('#e87068')
              .width('15%')
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
        }
        .padding({ bottom: 10 })
        .width('80%')
        .alignItems(HorizontalAlign.Center)
        .position({ bottom: 20 })

        // 进度条
        Progress({ value: this.progress })
          .width('80%')
          .color(Color.White)
          .backgroundColor('#ffffff33')
          .height(4)
          .borderRadius(2)
          .padding({ bottom: '8%' })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .height('100%')
    }
    .backgroundColor('#dd271c')
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP],)
  }
}


