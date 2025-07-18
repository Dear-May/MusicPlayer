import { SONG_KEY, tabsData } from '../constants/Index'
import { TabClass } from '../models/Index';
import { PlayStateType } from '../models/PlayState'
import Recommend from './recommend/Recommend';

@Entry
@Component
struct Index {
  @State currentName: string = 'recommend';
  @State currentNameBool: boolean = this.currentName ? true : false;
  @State opacityNum: number = 1;
  @StorageLink(SONG_KEY)
  playState: PlayStateType = new PlayStateType();

  @Builder
  MusicPlayerBar() {
    Row() {
      Image($r('app.media.ic_play'))
        .width(30)
        .height(30)
        .margin({ left: 15 })

      Column({ space: 5 }) {
        Text('正在播放的歌曲')
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
        Text('歌手名')
          .fontSize(12)
          .fontColor('#666')
      }
      .margin({ left: 10 })

      Image($r('app.media.play_list'))
        .width(25)
        .height(25)
        .margin({ right: 15 })
    }
    .width('90%')
    .height(40)
    .borderRadius(30)
    .align(Alignment.Top)
    .offset({ y: -55 }) // 向上偏移一半高度，实现半露效果
    .backgroundColor($r('sys.color.alert'))
    .borderRadius(30)
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
      .margin({ top: 35 })
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
        .barHeight(75)
        .onChange(index => {
          this.currentName = tabsData[index].name
        })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('sys.color.black'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
    .opacity(this.opacityNum)
    .padding({
      bottom: AppStorage.get<number>('bottomHeight')
    })
  }
}

@Builder
export function IndexBuilder(): void {
  Index();
}
