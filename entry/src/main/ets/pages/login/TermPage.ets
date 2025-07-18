import { Router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';


@Entry
@Component
struct TermPage {
  uiContext: UIContext | undefined = undefined;
  @State title: string = '';
  @State type: string = ''; // 用于存储解析出的 type
  @State currentTabIndex: number = 0
  private tabs: string[] = ['服务条款', '隐私政策', '儿童隐私政策']
  private webUrls: string[] = [
    'https://y.music.163.com/g/yida/36a81250504747a19283b29e4e9ff38c',
    'https://y.music.163.com/g/yida/6a5be9e3502947a9b794fc01932a83a3',
    'https://y.music.163.com/g/yida/b70f764b084a41a0b69e5c641158514f'
  ]
  private tabsController: TabsController = new TabsController();
  webviewController: webview.WebviewController = new webview.WebviewController();

  aboutToAppear() {
    this.uiContext = this.getUIContext();
    const router: Router = this.uiContext.getRouter();
    const params = router.getParams();
    this.type = Reflect.get(params, 'type');
    switch (this.type) {
      case 'policy':
        this.title = this.tabs[1];
        this.currentTabIndex = 1;
        break;
      case 'terms':
        this.title = this.tabs[0];
        this.currentTabIndex = 0;
        break;
      default:
        this.title = this.tabs[2];
        this.currentTabIndex = 2;
        break;
    }
    // 设置 Tabs 初始选中项
    this.tabsController.preloadItems([this.currentTabIndex])
  }

  @Builder
  TabContent(index: number) {
    TabContent() {
      Web({ src: this.webUrls[index], controller: this.webviewController })
        .width('100%')
        .height('100%')
    }
    .tabBar(SubTabBarStyle.of(this.tabs[index])
      .indicator({
        color: "#e94040", //下划线颜色
        height: 2, //下划线高度
        width: 80, //下划线宽度
        marginTop: 5//下划线与文字间距
      })
      .labelStyle({ unselectedColor: '#666', selectedColor: '#e94040' })
    )
  }

  build() {
    Column() {
      // 弹窗标题
      Column() {
        Row({ space: 5 }) {
          Button('←')
            .fontSize(35)
            .fontColor('#fff')
            .backgroundColor('rgba(0,0,0,0)')
            .onClick(() => {
              this.getUIContext().getRouter().back()
            });
          Text('网易云音乐' + this.title)
            .fontSize(20)
            .fontColor($r('sys.color.white'))
            .fontWeight(FontWeight.Bold)
        }
        .backgroundColor('#1c1c1e')
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP],)
      }

      // Tab 标签栏
      Tabs({ controller: this.tabsController, index: this.currentTabIndex }) {
        this.TabContent(0);
        this.TabContent(1);
        this.TabContent(2);
      }
      .scrollable(true)
      .animationDuration(300)
      .onChange((index) => {
        this.title = this.tabs[index]
      })
    }
  }
}
