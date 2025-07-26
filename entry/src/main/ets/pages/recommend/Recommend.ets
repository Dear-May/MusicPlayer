import { changeSideBarShow } from '../../constants/GlobalFunction';
import { BasicDataSource } from '../../utils/BasicDataSource';
import ListenBook from '../../views/recommend/ListenBook';
import ListenFree from '../../views/recommend/ListenFree';
import Music from '../../views/recommend/Music';
import Podcast from '../../views/recommend/Podcast';
import RecommendView from '../../views/recommend/RecommendView'

class TabsDateSource extends BasicDataSource<string> {
  private data: string[] = [];

  constructor(initialData: string[]) {
    super();
    this.data = initialData;
  }

  public totalCount(): number {
    return this.data.length;
  }

  getData(index: number): string {
    return this.data[index];
  }
}

@Preview
@Component
struct Recommend {
  @StorageLink('showSideBar') show: boolean = false;
  uiContext: UIContext | undefined = undefined;
  @State currentTab: number = 0;
  private tabs: string[] = ['推荐', '音乐', '播客', '听书', '免费听'];
  private tabsDataSource: TabsDateSource = new TabsDateSource(this.tabs);
  @State navList: Array<number> = [0, 1, 2, 3, 4, 5];
  @State active: number = 0;
  @State keyWord: string = '搜索';
  private tabsController: TabsController = new TabsController();

  @Builder
  TopBar() {
    Row() {
      Row({ space: 5 }) {
        Row({ space: 0 }) {
          Image($r('app.media.search'))
            .width(20)
            .height(20)
            .margin({ right: 5 })

          Text('🔥' + this.keyWord)
            .width('80%')
            .height(36)
            .fontSize(16)
            .fontColor("#969290")
        }
        .onClick(() => {
          this.getUIContext()
            .getRouter()
            .pushUrl({ url: 'pages/SearchPage', params: { source: 'IndexPage' } }, (err) => {
              if (err) {
                console.error('页面跳转失败', err);
              } else {
                console.info('页面跳转成功');
              }
            });
        })

        Image($r('app.media.ScanCode'))
          .width(20)
          .height(20)
          .margin({ right: 6 })
          .onClick(() => {
            console.log('点击了')
          })
      }
      .height(38)
      .width('80%')
      .padding(10)
      .margin({ left: 35 })
      .backgroundColor('rgba(117, 116, 116, 0.35)')
      .borderRadius(24)

      Image($r('app.media.ic_mic'))
        .width(24)
        .height(24)
        .margin({ left: 12 })
    }
    .width('100%')
    .backgroundColor('#0e0d11')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .padding({
      top: 40,
      left: 16,
      right: 16,
    })
  }

  @Builder
  TabContent(index: number) {
    TabContent() {
      if (index === 0) {
        RecommendView();
      } else if (index === 1) {
        Music();
      } else if (index === 2) {
        Podcast();
      } else if (index === 3) {
        ListenBook();
      } else if (index === 4) {
        ListenFree();
      }
    }
    .tabBar(SubTabBarStyle.of(this.tabs[index])
      .indicator({
        color: $r('sys.color.white'), //下划线颜色
        height: 2, //下划线高度
        width: 50, //下划线宽度
        marginTop: 5//下划线与文字间距
      })
      .labelStyle({
        unselectedColor: '#666',
        selectedColor: $r('sys.color.white'),
        font: { family: 'PingFangSC-Regular' }
      })
    )
  }

  build() {
    Column() {
      this.TopBar()
      // Tab 标签栏
      Tabs({ controller: this.tabsController }) {
        LazyForEach(this.tabsDataSource, (item: string, index: number) => {
          this.TabContent(index);
        }, (item: string) => item)
      }
      .scrollable(true)
      .animationDuration(300)
      .onContentWillChange(() => {
        if (this.show) {
          changeSideBarShow(this.getUIContext());
          return false;
        }
        return true;
      });
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

export default Recommend;