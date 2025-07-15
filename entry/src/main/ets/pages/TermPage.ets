import { Router } from '@kit.ArkUI';


@Entry
@Component
struct TermPage {
  uiContext: UIContext | undefined = undefined;
  @State title: string = '';
  @State type: string = ''; // 用于存储解析出的 type

  aboutToAppear() {
    this.uiContext = this.getUIContext();
    const router: Router = this.uiContext.getRouter();
    const params = router.getParams();
    this.type = Reflect.get(params, 'type');
    switch (this.type) {
      case 'policy':
        this.title = '隐私政策';
        break;
      case 'terms':
        this.title = '服务条款';
        break;
      default:
        this.title = '儿童隐私政策';
        break;
    }
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
              this.getUIContext()
                .getRouter()
                .pushUrl({ url: 'pages/LoginPage', params: { source: 'termPage' } }, (err) => {
                  if (err) {
                    console.error('页面跳转失败', err);
                  } else {
                    console.info('页面跳转成功');
                  }
                });
            });
          Text('网易云音乐' + this.title)
            .fontSize(25)
            .fontColor($r('sys.color.white'))
            .fontWeight(FontWeight.Bold)
        }
        .backgroundColor('#1c1c1e')
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP],)
      }
    }
  }
}
