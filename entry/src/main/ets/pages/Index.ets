import { SONG_KEY, tabsData } from '../constants/Index'
import { TabClass } from '../models/Index';
import { PlayStateType } from '../models/PlayState'
import DrawerTab from './DrawerTab';
import Recommend from './recommend/Recommend';

@Entry
@Component
struct Index {
  uiContext: UIContext | undefined = undefined;
  @State currentName: string = 'recommend';
  @State currentNameBool: boolean = this.currentName ? true : false;
  @State opacityNum: number = 1;
  @State isPlaying: boolean = false;
  @State rotateAngle: number = 0;
  @State show: boolean = false;
  @StorageLink(SONG_KEY)
  playState: PlayStateType = new PlayStateType();

  changeSideBarShow() {
    this.getUIContext().animateTo({
      duration: 1500,
      curve: Curve.EaseOut,
      playMode: PlayMode.Normal,
    }, () => {
      this.show = false;
    })
  }

  @Builder
  MusicPlayerBar() {
    Row() {
      Stack() {
        // 外层图片
        Image($r('app.media.record'))
          .width(45)
          .height(45)

        // 内层图片
        Image($r('app.media.record_center'))
          .width(25)
          .height(25)
          .borderRadius(12.5)
          .rotate({ angle: this.rotateAngle })
          .animation({
            duration: 3500,
            curve: Curve.Linear,
            iterations: -1,
            expectedFrameRateRange: {
              min: 20,
              max: 120,
              expected: 90,
            }
          })
      }
      .width(45)
      .height(45)

      Row({ space: 5 }) {
        Text('正在播放的歌曲')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.white'))
        Text('-')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor('#666')
        Text('歌手名')
          .fontSize(14)
          .fontColor('#666')
      }

      Row({ space: 18 }) {
        Image($r(this.isPlaying ? 'app.media.ic_paused' : 'app.media.ic_play'))
          .width(25)
          .height(25)
          .onClick(() => {
            this.isPlaying = !this.isPlaying;
            this.rotateAngle = 360 - this.rotateAngle;
          })

        Image($r('app.media.play_list'))
          .width(25)
          .height(25)
          .margin({ right: 15 })
          .onClick(() => {
            console.log('点击了播放列表')
          })
      }
    }
    .width('95%')
    .height(45)
    .borderRadius(30)
    .align(Alignment.Top)
    .offset({ y: -75 }) // 向上偏移一半高度，实现半露效果
    .backgroundColor('#1d1d1f')
    .borderRadius(30)
    .zIndex(1)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // tabBar组件
  @Builder
  getTabBar(item: TabClass) {
    Column() {
      Row() {
        Image(item.name === this.currentName ? item.iconLight : item.icon)
          .width(item.name === this.currentName ? 25 : 30)
          .aspectRatio(1)
      }
      .width(25)
      .aspectRatio(1)
      .borderRadius(22)
      .margin({ top: 10 })
      .justifyContent(FlexAlign.Center)

      Text(item.title)
        .fontSize(10)
        .fontWeight(400)
        .margin({ top: 5 })
        .fontColor(item.name === this.currentName ? $r('app.color.primary_light') : $r('app.color.primary_dark'))
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      DrawerTab();
      Column() {
        Stack({ alignContent: Alignment.Bottom }) {
          this.MusicPlayerBar();

          Tabs({ barPosition: BarPosition.End }) {
            ForEach(tabsData, (item: TabClass) => {
              TabContent() {
                if (item.name === 'recommend') {
                  Recommend()
                } else if (item.name === 'find') {
                  // Find()
                } else if (item.name === 'moment') {
                  // Moment()
                } else if (item.name === 'mine' && !this.show) {
                  // Mine({ playState: $playState })
                } else {
                  // Like()
                }
              }
              .tabBar(this.getTabBar(item))
              .backgroundColor($r('sys.color.white'))
            })
          }
          .barHeight(100)
          .onChange(index => {
            this.currentName = tabsData[index].name
          })
        }
      }
      .width('100%')
      .height('110%')
      .backgroundColor('#0e0d11')
      .opacity(this.opacityNum)
      .padding({
        bottom: AppStorage.get<number>('bottomHeight')
      })
      .shadow({
        radius: 10,
        color: '#000000',
        offsetX: 0,
        offsetY: 4
      })
      .onClick(() => {
        this.changeSideBarShow();
      })
    }
    .showSideBar(this.show)
    .controlButton({
      left: 14,
      top: 47,
      height: 24,
      width: 24,
      icons: {
        shown: $r('app.media.menu'),
        hidden: $r('app.media.menu')
      }
    })
    .onChange((value: boolean) => {
      this.show = value;
    })
    .sideBarWidth('85%')
    .minSideBarWidth('85%')
    .width('100%')
    .height('110%')
    .translate({ y: -40 })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
  }
}

@Builder
export function IndexBuilder(): void {
  Index();
}
