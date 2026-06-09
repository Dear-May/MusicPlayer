import { changeSideBarShow, tryCloseSideBar } from '../utils/GlobalFunction';
import { tabsData } from '../constants/Index'
import { TabClass } from '../models/Index';
import DrawerTab from './DrawerTab';
import Note from './note/Note';
import Recommend from './recommend/Recommend'
import AudioPlayerManager from '../feature/player/AudioPlayerManager';

@Entry
@Component
struct RecommendView {
  uiContext: UIContext | undefined = undefined;
  @State currentName: string = 'recommend';
  @State currentNameBool: boolean = this.currentName ? true : false;
  @State opacityNum: number = 1;
  @State isPlaying: boolean = false;
  @State rotateAngle: number = 0;
  @State songName: string = '未在播放';
  @State singerName: string = '';
  @State songImg: string = '';
  tabsController: TabsController = new TabsController();
  @StorageLink('showSideBar') show: boolean = false;
  private audioManager: AudioPlayerManager = AudioPlayerManager.getInstance();

  aboutToAppear(): void {
    this.audioManager.setOnStateChange((isPlaying: boolean, song: string, singer: string, img: string) => {
      this.isPlaying = isPlaying;
      if (song) {
        this.songName = song;
        this.singerName = singer;
        this.songImg = img;
      }
    });
  }

  @Builder
  MusicPlayerBar() {
    Row() {
      Stack() {
        // 外层图片 - 始终显示静态唱片图
        Image($r('app.media.record'))
          .width(45)
          .height(45)

        // 内层图片 - 优先使用API获取的专辑封面
        if (this.songImg) {
          Image(this.songImg)
            .width(25)
            .height(25)
            .borderRadius(12.5)
            .objectFit(ImageFit.Cover)
            .rotate({ angle: this.rotateAngle })
            .animation({
              duration: 5000,
              curve: Curve.Linear,
              iterations: -1,
              expectedFrameRateRange: {
                min: 20,
                max: 120,
                expected: 90,
              }
            })
        } else {
          Image($r('app.media.record_center'))
            .width(25)
            .height(25)
            .borderRadius(12.5)
            .rotate({ angle: this.rotateAngle })
            .animation({
              duration: 5000,
              curve: Curve.Linear,
              iterations: -1,
              expectedFrameRateRange: {
                min: 20,
                max: 120,
                expected: 90,
              }
            })
        }
      }
      .width(45)
      .height(45)

      Row({ space: 5 }) {
        Text(this.songName)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.white'))
        if (this.singerName) {
          Text('-')
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor('#666')
          Text(this.singerName)
            .fontSize(14)
            .fontColor('#666')
        }
      }

      Row({ space: 18 }) {
        Image($r(this.isPlaying ? 'app.media.ic_paused' : 'app.media.ic_play'))
          .width(25)
          .height(25)
          .onClick(() => {
            this.audioManager.togglePlay();
            this.rotateAngle = this.rotateAngle + 180;
          })

        Image($r('app.media.play_list'))
          .width(25)
          .height(25)
          .margin({ right: 15 })
          .onClick(() => {
            tryCloseSideBar(
              this.getUIContext(),
              this.show,
              () => {
                console.log('play list clicked');
              });
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

  @Builder
  OverlayNode() {
    Row() {
    }
    .visibility(this.show ? Visibility.Visible : Visibility.Hidden)
    .hitTestBehavior(HitTestMode.None)
    .width('100%')
    .height('100%')
    .backgroundColor('#80000000')
  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      DrawerTab();
      Column() {
        Stack({ alignContent: Alignment.Bottom }) {
          this.MusicPlayerBar();

          Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
            ForEach(tabsData, (item: TabClass) => {
              TabContent() {
                if (item.name === 'recommend') {
                  Recommend()
                } else if (item.name === 'roam') {
                  // Find()
                } else if (item.name === 'note') {
                  Note()
                } else if (item.name === 'mine') {
                  // Mine({ playState: $playState })
                } else {
                  // Like()
                }
              }
              .tabBar(this.getTabBar(item))
              .backgroundColor($r('sys.color.white'))
            })
          }
          .scrollable(false)
          .barHeight(100)
          .onChange(index => {
            this.currentName = tabsData[index].name
          })
          .onContentWillChange(() => {
            if (this.show) {
              changeSideBarShow(this.getUIContext());
              return false;
            }
            return true;
          });
        }
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
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
        tryCloseSideBar(this.getUIContext(), this.show, () => {
        })
      })
      .overlay(this.OverlayNode())
    }
    .showSideBar(this.show)
    .showControlButton(false)
    .onChange((value: boolean) => {
      this.show = value;
    })
    .sideBarWidth('80%')
    .minSideBarWidth('80%')
    .width('100%')
    .height('110%')
    .translate({ y: -40 })
  }
}

@Builder
export function IndexBuilder(): void {
  RecommendView();
}
