import { CommonConstants } from '../constants/CommonConstants';

@Preview
@Component
struct DrawerTab {
  @State active: number = 0;

  // 顶部登录区域
  @Builder
  TopBar() {
    Row() {
      Row() {
        Image($r('app.media.default_profile'))
          .width(25)
          .height(25)
          .margin({ left: 16 })
        Text('立刻登录>')
          .fontSize(16)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 17 })
          .onClick(() => {
            this.getUIContext()
              .getRouter()
              .replaceUrl({ url: 'pages/login/LoginPage', params: { source: 'IndexPage' } }, (err) => {
                if (err) {
                  console.error('页面跳转失败', err);
                } else {
                  console.info('页面跳转成功');
                }
              });
          })
      }
      .layoutWeight(1)

      Row() {
        Image($r('app.media.ScanCode'))
          .width(25)
          .height(25)
          .onClick(() => {
            console.log('点击了')
          })
      }
      .justifyContent(FlexAlign.End)

    }
    .width('100%')
    .padding({ bottom: 10 })
  }

  // VIP卡片区域
  @Builder
  VipCard() {
    Column({ space: 6 }) {
      Stack() {
        Image($r('app.media.VIPCardbg'))
          .width(272)
          .height(95)
          .objectFit(ImageFit.Cover)

        Column({ space: 8 }) { // 使用Column来垂直排列内容
          Row({ space: 8 }) {
            Column() {
              Text('开通黑胶VIP 🎉')
                .fontSize(16)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)

              Text('黑胶时光机 | 每周听歌报告 🎵')
                .fontSize(12)
                .fontColor(Color.Grey)
            }
            .padding({ bottom: 5 })
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)

            Button() {
              Text('会员中心')
                .fontSize(12)
                .fontColor(Color.White)
            }
            .offset({ y: -5 })
            .padding(5)
            .backgroundColor(Color.Transparent)
            .borderStyle(BorderStyle.Solid)
            .borderColor(Color.White)
            .borderWidth(1)
            .borderRadius(12)
          }
          .justifyContent(FlexAlign.Start)

          Divider()
            .height(1)
            .backgroundColor(Color.Grey)

          Column() {
            Text('黑胶VIP学生特惠，仅需 ￥5/月！')
              .fontSize(12)
              .fontColor(Color.Grey)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
        .padding(12)
      }
      .width('100%')
      .borderRadius(10)


      Row({ space: 6 }) {
        Row({ space: 6 }) {
          Text('免')
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor(Color.Red)
            .borderRadius(16) // 保持圆形
            .padding(4) // 增加上下内边距
            .width(26) // 设置固定宽度
            .height(26) // 设置固定高度
            .textAlign(TextAlign.Center) // 文字居中


          Text('免费听VIP歌曲')
            .fontSize(16)
            .fontColor(Color.White)
        }
        .layoutWeight(1)

        Button() {
          Text('领时长')
            .fontSize(12)
            .fontColor(Color.Red)
        }
        .padding(5)
        .backgroundColor(Color.Transparent)
        .borderStyle(BorderStyle.Solid)
        .borderColor(Color.Red)
        .borderWidth(1)
        .borderRadius(12)
      }
      .padding({
        left: 10,
        right: 10,
        top: 10,
        bottom: 10
      })
    }
    .padding({ top: 10, bottom: 10 })
    .alignItems(HorizontalAlign.Start)
    .backgroundColor('#29282c')
    .borderRadius(12)
  }

  // 菜单项构造器
  @Builder
  menuItem(icon: Resource, label: string, desc?: string) {
    Row() {
      Row() {
        Image(icon)
          .width(25)
          .height(25)
        Text(label)
          .fontSize(16)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 17 })
          .onClick(() => {
            this.getUIContext()
              .getRouter()
              .replaceUrl({ url: 'pages/login/LoginPage', params: { source: 'IndexPage' } }, (err) => {
                if (err) {
                  console.error('页面跳转失败', err);
                } else {
                  console.info('页面跳转成功');
                }
              });
          })
      }
      .layoutWeight(1)

      if (desc)
      Row() {
        Text(desc)
          .fontSize(12)
          .fontColor(Color.Gray)
      }
      .justifyContent(FlexAlign.End)

    }
    .width('100%')
    .padding({
      top: 8,
      bottom: 8,
      left: 16,
      right: 16
    })
  }

  // 底部按钮栏
  @Builder
  BottomBar() {
    Row({ space: 20 }) {
      Button() {
        Row() {
          Image($r('app.media.menu'))
            .width(20)
            .height(20)
          Text('设置')
            .fontSize(14)
            .fontColor(Color.White)
        }
      }
      .layoutWeight(1)
      .backgroundColor('#2c2b2f')
      .borderRadius(4)
      .padding(8)

      Button() {
        Row() {
          Image($r('app.media.menu'))
            .width(20)
            .height(20)
          Text('更多')
            .fontSize(14)
            .fontColor(Color.White)
        }
      }
      .layoutWeight(1)
      .backgroundColor('#2c2b2f')
      .borderRadius(4)
      .padding(8)
    }
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('13%')
    .padding({
      bottom: 16,
      top: 12
    })
    .shadow({
      radius: 10,
      color: Color.Black,
      offsetX: 0,
      offsetY: 4
    })
  }

  build() {
    Column() {
      this.TopBar()

      Scroll() {
        Column() {
          this.VipCard()

          Blank()
            .height(20)

          Column({ space: 3 }) {
            this.menuItem($r('app.media.menu'), '我的消息')
            this.menuItem($r('app.media.menu'), '我的云贝', '免费兑黑胶VIP')
            this.menuItem($r('app.media.menu'), '装扮中心', 'LABUBU装扮~')
            this.menuItem($r('app.media.menu'), '创作者中心')
            Divider()
              .height(1)
              .backgroundColor(Color.Grey)
              .padding({ left: 16, right: 16 })
            this.menuItem($r('app.media.menu'), '最近播放')
            this.menuItem($r('app.media.menu'), '定时关闭')
            Divider()
              .height(1)
              .backgroundColor(Color.Grey)
              .padding({ left: 16, right: 16 })
            this.menuItem($r('app.media.menu'), '商城')
            this.menuItem($r('app.media.menu'), '云村有票')
            this.menuItem($r('app.media.menu'), '云推歌')
            this.menuItem($r('app.media.menu'), '我的客服')
          }
          .padding({ top: 10 })
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .backgroundColor('#29282c')
          .borderRadius(6)
        }
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      this.BottomBar()
    }
    .width(272)
    .height(CommonConstants.FULL_HEIGHT)
    .padding({ top: '15%', right: '5%', left: '5%' })
    .backgroundColor('#0e0d11')
  }
}

export default DrawerTab;