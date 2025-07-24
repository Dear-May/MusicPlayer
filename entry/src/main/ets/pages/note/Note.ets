import { changeSideBarShow, tryCloseSideBar } from "../../constants/GlobalFunction";
import { BasicDataSource } from "../../utils/BasicDataSource";


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

@Entry
@Component
struct Note {
  @StorageLink('showSideBar') show: boolean = false;
  uiContext: UIContext | undefined = undefined;
  private tabs: string[] = ['关注', '推荐'];
  private tabsDataSource: TabsDateSource = new TabsDateSource(this.tabs);
  @State currentTab: number = 0;
  private tabsController: TabsController = new TabsController();

  @Builder
  TabContent(index: number) {
    TabContent() {
      if (index === 0) {
      } else if (index === 1) {
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

  @Builder
  TopBar() {
    Row() {
      Row() {
      }
      .width('28%')

      Row() {
        Tabs({ controller: this.tabsController, index: 1 }) {
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
      .layoutWeight(1)
      .height(38)
      .padding(10)

      Row({ space: 5 }) {
        Image($r('app.media.search'))
          .width(30)
          .height(30)
          .margin({ right: 5 })
          .onClick(() => {
            tryCloseSideBar(this.getUIContext(), this.show, () => {
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
          })

        Image($r('app.media.ic_add'))
          .width(30)
          .height(30)
          .onClick(() => {
            tryCloseSideBar(this.getUIContext(), this.show, () => {
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
          })
      }
      .width('20%')

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

  build() {
    Column() {
      this.TopBar();
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

export default Note;