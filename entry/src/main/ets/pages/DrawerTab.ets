import { CommonConstants } from '../common/constants/CommonConstants';
import { UserProfile } from '../common/models/ApiTypes';
import UserStateManager from '../feature/user/UserStateManager';
import LoginApi from '../feature/login/LoginApi';

@Preview
@Component
struct DrawerTab {
  @State active: number = 0;
  @StorageLink('isLoggedIn') isLoggedIn: boolean = false;
  @StorageLink('userInfo') userInfo: UserProfile | null = null;

  private RouterPage(url: string) {
    this.getUIContext()
      .getRouter()
      .pushUrl({ url: url, params: { source: 'IndexPage' } }, (err) => {
        if (err) {
          console.error('页面跳转失败', err);
        } else {
          console.info('页面跳转成功');
        }
      });
  }

  // 顶部登录区域
  @Builder
  TopBar() {
    Row() {
      Row() {
        if (this.isLoggedIn && this.userInfo) {
          // 已登录：显示用户头像和昵称
          Image(this.userInfo.avatarUrl)
            .width(35)
            .height(35)
            .borderRadius(17.5)
            .margin({ left: 16 })
            .objectFit(ImageFit.Cover)
          Text(this.userInfo.nickname)
            .fontSize(16)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Medium)
            .margin({ left: 12 })
        } else {
          // 未登录：显示默认头像+登录入口
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
              this.RouterPage('pages/login/LoginPage');
            })
        }
      }
      .layoutWeight(1)
      .onClick(() => {
        if (!this.isLoggedIn) {
          this.RouterPage('pages/login/LoginPage');
        }
      })

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
  menuItem(icon: Resource, label: string, url: string, desc?: string) {
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
    .onClick(() => {
      this.RouterPage('pages/other/' + url)
    })
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
          Image($r('app.media.ic_setting'))
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
      .onClick(() => {
        this.RouterPage('pages/other/SettingPage')
      })

      Button() {
        Row() {
          Image($r('app.media.ic_more'))
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
      .onClick(() => {
        this.RouterPage('pages/other/MorePage')
      })
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
            this.menuItem($r('app.media.ic_message_normal'), '我的消息', 'MessagePage')
            this.menuItem($r('app.media.ic_cowry_normal'), '我的云贝', 'YunbeiPage', '免费兑黑胶VIP')
            this.menuItem($r('app.media.ic_cloth_normal'), '装扮中心', 'ClothingPage', 'LABUBU装扮~')
            this.menuItem($r('app.media.ic_create_normal'), '创作者中心', 'CreatePage')
            Divider()
              .height(1)
              .backgroundColor(Color.Grey)
              .padding({ left: 16, right: 16 })
            this.menuItem($r('app.media.ic_recently_normal'), '最近播放', 'RecentlyPlayPage')
            this.menuItem($r('app.media.ic_time_normal'), '定时关闭', 'TimedShutdownPage')
            Divider()
              .height(1)
              .backgroundColor(Color.Grey)
              .padding({ left: 16, right: 16 })
            this.menuItem($r('app.media.ic_shop_normal'), '商城', 'ShopPage')
            this.menuItem($r('app.media.ic_ticket_normal'), '云村有票', 'TicketPage')
            this.menuItem($r('app.media.ic_PushingSongs_normal'), '云推歌', 'RecommendSongPage')
            this.menuItem($r('app.media.ic_server_normal'), '我的客服', 'CustomerServicePage')
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