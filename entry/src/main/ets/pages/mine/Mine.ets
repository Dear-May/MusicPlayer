import { changeSideBarShow, tryCloseSideBar } from '../../utils/GlobalFunction';
import { UserProfile } from '../../common/models/ApiTypes';
import MusicSection from '../../views/mine/MusicSection';
import PodcastSection from '../../views/mine/PodcastSection';
import NoteSection from '../../views/mine/NoteSection';

@Component
struct Mine {
  @StorageLink('isLoggedIn') isLoggedIn: boolean = false
  @StorageLink('userInfo') userInfo: UserProfile | null = null
  @StorageLink('showSideBar') show: boolean = false
  @State currentMainPage: number = 0

  private musicSubTabs: string[] = ['近期', '创建']
  private podcastSubTabs: string[] = ['全部', '播客', '有声书']

  getMainTab(): number {
    if (this.currentMainPage <= 1) return 0
    if (this.currentMainPage <= 4) return 1
    return 2
  }

  getSubTabIndex(): number {
    if (this.currentMainPage <= 1) return this.currentMainPage
    if (this.currentMainPage <= 4) return this.currentMainPage - 2
    return 0
  }

  @Builder
  TopBar() {
    Row() {
      Image($r('app.media.menu'))
        .width(24)
        .height(24)
        .onClick(() => {
          changeSideBarShow(this.getUIContext())
        })

      Blank()

      Row({ space: 16 }) {
        Image($r('app.media.ic_add'))
          .width(24)
          .height(24)
        Image($r('app.media.search'))
          .width(24)
          .height(24)
        Image($r('app.media.ic_more'))
          .width(24)
          .height(24)
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 40, bottom: 8 })
    .backgroundColor('#3A1515')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  @Builder
  UserSection() {
    Column({ space: 12 }) {
      Stack() {
        Circle()
          .width(90)
          .height(90)
          .fill('#E8D5D5')
          .stroke('#FFFFFF')
          .strokeWidth(2)

        Column() {
          Circle()
            .width(30)
            .height(30)
            .fill('#F0C8C8')
            .margin({ top: 15 })

          Path()
            .width(50)
            .height(25)
            .fill('#F0C8C8')
            .margin({ top: 2 })
        }
      }
      .width(90)
      .height(90)
      .margin({ top: 12 })

      if (this.isLoggedIn && this.userInfo) {
        Text(this.userInfo.nickname)
          .fontSize(18)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Medium)
          .margin({ top: 8 })
      } else {
        Text('立即登录 >')
          .fontSize(18)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Medium)
          .margin({ top: 8 })
      }
    }
    .width('100%')
    .padding({ left: 20, right: 20 })
  }

  @Builder
  QuickBtn(text: string, iconType: string) {
    Row({ space: 6 }) {
      Image($r('app.media.' + iconType))
        .width(18)
        .height(18)
        .fillColor('#CCCCCC')
      Text(text)
        .fontSize(13)
        .fontColor('#CCCCCC')
    }
    .height(36)
    .padding({ left: 14, right: 14 })
    .backgroundColor('#4A2525')
    .borderRadius(18)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  QuickActions() {
    Row({ space: 10 }) {
      this.QuickBtn('最近', 'clock')
      this.QuickBtn('本地', 'download')
      this.QuickBtn('VIP会员', 'vip')
      this.QuickBtn('装扮', 'dress')
      this.QuickBtn('更多', 'grid')
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 16 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  MainTabBar() {
    Row() {
      this.MainTabItem('音乐', 0)
      this.MainTabItem('播客', 1)
      this.MainTabItem('笔记', 2)
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 12, bottom: 8 })
    .justifyContent(FlexAlign.SpaceAround)
  }

  @Builder
  MainTabItem(text: string, index: number) {
    Column({ space: 4 }) {
      Text(text)
        .fontSize(18)
        .fontColor(this.getMainTab() === index ? '#FFFFFF' : '#666666')
        .fontWeight(this.getMainTab() === index ? FontWeight.Bold : FontWeight.Normal)
      if (this.getMainTab() === index) {
        Row()
          .width(20)
          .height(3)
          .backgroundColor('#C20C0C')
          .borderRadius(2)
      } else {
        Row()
          .width(20)
          .height(3)
          .backgroundColor('transparent')
      }
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      if (index === 0) {
        this.currentMainPage = 0
      } else if (index === 1) {
        this.currentMainPage = 2
      } else {
        this.currentMainPage = 5
      }
    })
  }

  @Builder
  MusicSubTabBar() {
    Row() {
      Row({ space: 4 }) {
        Image($r('app.media.lock'))
          .width(14)
          .height(14)
          .fillColor('#999999')
        Text('近期')
          .fontSize(15)
          .fontColor(this.getSubTabIndex() === 0 ? '#FFFFFF' : '#666666')
          .fontWeight(this.getSubTabIndex() === 0 ? FontWeight.Bold : FontWeight.Normal)
      }
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .onClick(() => {
        this.currentMainPage = 0
      })

      Row({ space: 2 }) {
        Text('创建')
          .fontSize(15)
          .fontColor(this.getSubTabIndex() === 1 ? '#FFFFFF' : '#666666')
          .fontWeight(this.getSubTabIndex() === 1 ? FontWeight.Bold : FontWeight.Normal)
        Text('1')
          .fontSize(10)
          .fontColor('#FFFFFF')
          .backgroundColor('#C20C0C')
          .borderRadius(8)
          .width(16)
          .height(16)
          .textAlign(TextAlign.Center)
      }
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .onClick(() => {
        this.currentMainPage = 1
      })

      Blank()

      Row({ space: 20 }) {
        Image($r('app.media.ic_musical_note'))
          .width(20)
          .height(20)
          .fillColor('#999999')
        Column({ space: 3 }) {
          Circle().width(3).height(3).fill('#999999')
          Circle().width(3).height(3).fill('#999999')
          Circle().width(3).height(3).fill('#999999')
        }
      }
      .padding({ right: 16 })
    }
    .width('100%')
    .backgroundColor('#0e0d11')
  }

  @Builder
  PodcastSubTabBar() {
    Row() {
      ForEach(this.podcastSubTabs, (tab: string, index: number) => {
        Text(tab)
          .fontSize(15)
          .fontColor(this.getSubTabIndex() === index ? '#FFFFFF' : '#666666')
          .fontWeight(this.getSubTabIndex() === index ? FontWeight.Bold : FontWeight.Normal)
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          .onClick(() => {
            this.currentMainPage = 2 + index
          })
      })
      Blank()
    }
    .width('100%')
    .backgroundColor('#0e0d11')
  }

  build() {
    Column() {
      this.TopBar()

      Column({ space: 0 }) {
        this.UserSection()
        this.QuickActions()
      }
      .width('100%')
      .backgroundColor('#3A1515')

      Column() {
        this.MainTabBar()

        if (this.getMainTab() === 0) {
          this.MusicSubTabBar()
        } else if (this.getMainTab() === 1) {
          this.PodcastSubTabBar()
        }

        Swiper() {
          MusicSection({ subTabIndex: 0 })
          MusicSection({ subTabIndex: 1 })
          PodcastSection({ subTabIndex: 0 })
          PodcastSection({ subTabIndex: 1 })
          PodcastSection({ subTabIndex: 2 })
          NoteSection()
        }
        .index(this.currentMainPage)
        .loop(false)
        .indicator(false)
        .duration(300)
        .curve(Curve.EaseInOut)
        .onChange((index: number) => {
          this.currentMainPage = index
        })
        .layoutWeight(1)
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#0e0d11')
      .borderRadius({ topLeft: 6, topRight: 6 })
    }
    .width('100%')
    .height('100%')
  }
}

export default Mine
