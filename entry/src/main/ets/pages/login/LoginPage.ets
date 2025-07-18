import { KeyboardAvoidMode } from '@kit.ArkUI';
import countries from '../../../assets/country_code_cn.json'
import { BasicDataSource } from '../../utils/BasicDataSource'

interface CountryInfoStruct {
  cn: string;
  en: string;
  code: string;
}

interface CountryStruct {
  title: string;
  project: CountryInfoStruct[];
}

class CountryDateSource extends BasicDataSource<CountryStruct> {
  private data: CountryStruct[] = [];

  constructor(initialData: CountryStruct[]) {
    super();
    this.data = initialData;
  }

  public totalCount(): number {
    return this.data.length;
  }

  getData(index: number): CountryStruct {
    return this.data[index];
  }
}


@Entry
@Component
struct LoginPage {
  uiContext: UIContext | undefined = undefined;
  listScroller: ListScroller = new ListScroller()
  @State areaCode: string = '+86';
  @State phone: string = '';
  @State agree: boolean = false;
  @State countryList: CountryStruct[] = countries;
  private countryDataSource: CountryDateSource = new CountryDateSource(this.countryList);
  @State selectCountryIndex: number = 0; //当前选中的国家索引
  @State letterIndex: number = 0;
  @State AlphabetList: string[] = ['常', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  scroller: Scroller = new Scroller();
  // 弹窗显示
  @State showExperiencePopup: boolean = false;
  @State showProblemPopup: boolean = false;
  @State showOtherWaysLogin: boolean = false;
  @State showCountryListPopup: boolean = false;

  aboutToAppear() {
    this.uiContext = this.getUIContext();
    if (!this.uiContext) {
      console.warn("no uiContext");
      return;
    }
  }

  private togglePopupWithAnimation(popupName: string) {
    this.uiContext?.animateTo({
      duration: 300,
      curve: Curve.EaseOut,
      onFinish: () => {
        console.info('卡片动画完成')
      }
    }, () => {
      switch (popupName) {
        case 'experience':
          this.showExperiencePopup = !this.showExperiencePopup;
          break;
        case 'problem':
          this.showProblemPopup = !this.showProblemPopup;
          break;
        case 'otherWays':
          this.showOtherWaysLogin = !this.showOtherWaysLogin;
          break;
        case 'countryList':
          this.showCountryListPopup = !this.showCountryListPopup;
          break;
      }
    })
  }

  private RouterToPage(text: string, parms: string) {
    this.getUIContext()
      .getRouter()
      .pushUrl({ url: text, params: { type: parms, source: 'loginPage' } }, (err) => {
        if (err) {
          console.error('页面跳转失败', err);
        } else {
          console.info('页面跳转成功');
        }
      });
  }

  // 顶部内容
  @Builder
  titleBar() {
    // 顶部立即体验
    Column() {
      Text('立即体验')
        .fontSize(16)
        .fontColor('#888')
        .padding({ top: 10, right: 20 })
        .onClick(() => this.togglePopupWithAnimation('experience'))
    }
    .alignItems(HorizontalAlign.End)
    .width('100%')
  }

  // 底部内容
  @Builder
  underBar() {
    Column() {
      Row({ space: 5 }) {
        Text('登录遇到问题')
          .fontSize(14)
          .fontColor('#666')
          .onClick(() => this.togglePopupWithAnimation('problem'))
        if (!this.showOtherWaysLogin) {
          Text('|')
            .fontColor('#666')
          Text('其他登录方式 >')
            .fontSize(14)
            .fontColor('#666')
            .onClick(() => this.togglePopupWithAnimation('otherWays'))
        }
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .position({ bottom: 5 })
  }

  // 点击空白区域关闭弹窗
  @Builder
  blankStyle(text: string) {
    Blank()
      .width('100%')
      .height('100%')
      .onClick(() => this.togglePopupWithAnimation(text))
  }

  // ”立即体验“弹窗
  @Builder
  experiencePopup() {
    Column() {
      this.blankStyle('experience')

      // 弹出内容
      Column() {
        Text('服务协议和隐私政策等指引')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.white'))
          .margin({ bottom: 8 })

        Column() {
          Text('进入下一步前，请阅读并同意网易云音乐的')
            .fontSize(14)
            .fontColor('#AAAAAA')
            .textAlign(TextAlign.Start)
            .lineHeight(22)
            .margin({ bottom: 5 })
          Row() {
            Text('《服务条款》、')
              .fontSize(14)
              .fontColor('#3388ff')
              .textAlign(TextAlign.Start)
              .lineHeight(22)
              .onClick(() => {
                this.RouterToPage('pages/login/TermPage', 'terms');
              })
            Text('《隐私政策》')
              .fontSize(14)
              .fontColor('#3388ff')
              .textAlign(TextAlign.Start)
              .lineHeight(22)
              .onClick(() => {
                this.RouterToPage('pages/login/TermPage', 'policy');
              })
          }
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .margin({ bottom: 20 })

        Row({ space: 16 }) {
          Button('不同意')
            .backgroundColor('#1E1E1E')
            .borderColor('#FF3B30')
            .borderWidth(1)
            .fontColor('#FF3B30')
            .borderRadius(24)
            .width('45%')
            .onClick(() => this.togglePopupWithAnimation('experience'))

          Button('同意并继续')
            .backgroundColor('#FF3B30')
            .fontColor($r('sys.color.comp_background_list_card'))
            .borderRadius(24)
            .width('45%')
            .onClick(() => {
              this.RouterToPage('pages/Index', '');
            })
        }
      }
      .width('100%')
      .backgroundColor('#1c1c1e')
      .borderRadius({ topLeft: 20, topRight: 20 })
      .position({ x: 0, y: '78%' })
      .padding(30)
      .alignItems(HorizontalAlign.Center)
      .animation({
        duration: 300,
        curve: Curve.EaseOut
      })
    }
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP],)
  }

  // 问题弹窗
  @Builder
  problemChoose(text: string, way: string) {
    Text(text)
      .fontSize(18)
      .fontColor('white')
      .onClick(() => {
        this.RouterToPage(way, '');
      })
  }

  @Builder
  problemPopup() {
    Column() {
      this.blankStyle('problem')

      Column({ space: 14 }) {
        // 标题
        Text('登录遇到问题')
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.comp_background_list_card'))
          .margin({ bottom: 10 })
        // 分割线
        Divider()
          .backgroundColor('#ff3b3b3e')
          .strokeWidth(2)
        // 选项
        Column({ space: 20 }) {
          this.problemChoose('手机号已更换', 'pages/AccountRecoveryPage')
          this.problemChoose('找回原账号', 'pages/AccountRecoveryPage')
          this.problemChoose('其他问题', 'pages/CustomerServicePage')
        }
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .backgroundColor('#1c1c1e')
      .borderRadius({ topLeft: 20, topRight: 20 })
      .position({ x: 0, y: '74%' })
      .padding(30)
      .alignItems(HorizontalAlign.Start)
      .animation({
        duration: 300,
        curve: Curve.EaseOut
      })
    }
    .backgroundColor('rgba(0, 0, 0, 0.5)')
    .width('100%')
    .height('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
  }

  // 国家码选择框
  @Builder
  itemHead(text: string) {
    Column() {
      Text(text)
        .fontSize(18)
        .fontColor($r('sys.color.white'))
        .fontWeight(FontWeight.Bold)
        .margin({ top: 10, bottom: 10, left: 20 })
    }
    .backgroundColor('#1c1c1e')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  countryListPopup() {
    Column() {
      // 点击空白区域关闭弹窗
      Blank()
        .width('100%')
        .height('5%')
        .onClick(() => this.togglePopupWithAnimation('countryList'))

      Column() {
        // 弹窗标题
        Column() {
          Row({ space: 5 }) {
            Button('×')
              .fontSize(30)
              .fontColor('#fff')
              .backgroundColor('rgba(0,0,0,0)')
              .margin({ top: 10, bottom: 10 })
              .onClick(() => this.togglePopupWithAnimation('countryList'))
            Text('选择国家和地区')
              .fontSize(20)
              .fontColor($r('sys.color.white'))
              .fontWeight(FontWeight.Bold)
              .margin({ top: 10, bottom: 10 })
          }
          .backgroundColor('#1c1c1e')
          .borderRadius({ topLeft: 20, topRight: 20 })
          .width('100%')
          .justifyContent(FlexAlign.Start)
        }

        // 国家和地区列表
        Row() {
          Scroll(this.scroller) {
            Column() {
              List({ space: 5, scroller: this.listScroller }) {
                LazyForEach(this.countryDataSource, (item: CountryStruct) => {
                  ListItemGroup({ header: this.itemHead(item.title) }) {
                    ForEach(item.project, (item: CountryInfoStruct, index) => {
                      ListItem() {
                        Column() {
                          Row() {
                            Text(item.cn)
                              .fontSize(18)
                              .fontColor($r('sys.color.white'))
                              .margin({ left: 10 })
                              .layoutWeight(1)
                            Text(`${item.code}`)
                              .fontSize(16)
                              .fontColor('#888')
                              .margin({ right: 20 })
                          }
                          .width('100%')
                          .height(40)

                          Divider()
                            .strokeWidth(1)
                            .color('#333')
                            .margin({ left: 10, right: 10 })
                        }
                        .backgroundColor('#1c1c1e')
                        .padding(10)
                        .onClick(() => {
                          this.areaCode = `${item.code}`;
                          this.selectCountryIndex = index;
                          this.togglePopupWithAnimation('countryList');
                        })
                      }
                    })
                  }
                }, (item: CountryStruct) => item.title)
              }
              .width('100%')
              .height('100%')
              .sticky(StickyStyle.Header)
              .edgeEffect(EdgeEffect.None)
              .onScrollIndex((start: number) => {
                this.letterIndex = start
              })
            }
            .width('100%')
            .backgroundColor('#1c1c1e')
          }
          .scrollable(ScrollDirection.Vertical)
          .scrollBar(BarState.Off)
          .scrollBarColor('#888')
          .scrollBarWidth(4)
          .enableScrollInteraction(true)
          .layoutWeight(1)
          .height('100%')

          // 右侧导航栏
          Column() {
            AlphabetIndexer({ arrayValue: this.AlphabetList, selected: this.letterIndex })
              .color($r('sys.color.white'))
              .selectedColor($r('sys.color.white'))
              .popupColor($r('sys.color.white'))
              .alignStyle(IndexerAlign.Right) // 弹出框在索引条左侧弹出
              .popupBackground('#ffb7b7b7') // 弹出框背景颜色
              .usingPopup(true) // 是否显示弹出框
              .font({ size: 16 })
              .onSelect((index: number) => {
                this.listScroller.scrollToItemInGroup(index, 0)
              })
          }
          .borderRadius(20)
          .width("12%")
          .padding(5)
          .justifyContent(FlexAlign.Start)
          .backgroundColor('#6d6d6f')
          .padding(10)
          .margin({ top: -100 })
        }
        .backgroundColor('#1c1c1e')
        .width('100%')
        .height('100%')
      }
      .backgroundColor('rgba(0, 0, 0, 0.5)')
      .alignItems(HorizontalAlign.Start)
      .width('100%')
      .height('100%')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP])
    }
  }

  //第三方登录
  @Builder
  otherWaysLoginIcon(text_icon: string, text: string) {
    Column() {
      Image($r(text_icon))
        .width(30)
        .height(30)
        .objectFit(ImageFit.Contain)
    }
    .alignItems(HorizontalAlign.Center)
    .width(45)
    .height(45)
    .backgroundColor('#2f2e36')
    .borderRadius(22.5)
    .padding(9)
    .onClick(() => {
      console.log('点击了' + text + '登录')
    })
  }

  @Builder
  otherWaysLoginPopup() {
    Row({ space: 13 }) {
      this.otherWaysLoginIcon('app.media.wechat', '微信')
      this.otherWaysLoginIcon('app.media.qq', 'QQ')
      this.otherWaysLoginIcon('app.media.weibo', '微博')
      this.otherWaysLoginIcon('app.media.neteasy', '网易')
      this.otherWaysLoginIcon('app.media.huawei', '华为')
    }
    .margin(40)
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        Column({ space: 20 }) {
          this.titleBar();

          Column() {
            // LOGO
            Column() {
              Image($r("app.media.foreground"))
                .width('60')
                .height('60')
                .objectFit(ImageFit.Contain)
            }
            .width(90)
            .height(90)
            .borderRadius(45)
            .backgroundColor('#ec271b')
            .padding(15)

            // 手机输入框
            Row({ space: 5 }) {
              Select([])
                .value(this.areaCode)
                .fontColor('#ccc')
                .selectedOptionFont({ weight: FontWeight.Bold, size: 20 })
                .font({ size: 20 })
                .onClick(() => this.togglePopupWithAnimation('countryList'))

              Divider()
                .vertical(true)
                .height(30)
                .color('#ff999999')
                .strokeWidth(1)

              TextInput({
                placeholder: '输入手机号',
                text: this.phone,
              })
                .fontColor('#ccc')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .layoutWeight(1) // 使用剩余空间
                .maxLength(11)
                .caretColor('#ec271b')
                .inputFilter("[0-9]")
                .placeholderColor('#ff4f4f4f')
                .backgroundColor('#2a2a2a')
            }
            .padding(10)
            .backgroundColor('#2a2a2a')
            .borderRadius(10)
            .margin({ top: '45%', left: 30, right: 30 })

            // 登录按钮
            Button('验证码登录')
              .fontSize(16)
              .fontColor('#fff')
              .backgroundColor('#fe3a3b')
              .borderRadius(22.5)
              .width('75%')
              .height(45)
              .margin({ top: 20 })
              .onClick(() => {
                console.log('点击登录，手机号:', this.phone)
              })

            // 勾选协议
            Row({ space: 5 }) {
              Checkbox({ group: 'agree' })
                .onChange(val => this.agree = val)
              Text('我已阅读并同意')
                .fontColor('#aaa')
                .fontSize(12)
              Text('《服务条款》、')
                .fontColor('#3388ff')
                .fontSize(12)
                .onClick(() => {
                  this.RouterToPage('pages/login/TermPage', 'terms');
                })
              Text('《隐私政策》')
                .fontColor('#3388ff')
                .fontSize(12)
                .onClick(() => {
                  this.RouterToPage('pages/login/TermPage', 'policy');
                })
            }
            .margin({ top: 10 })

            if (this.showOtherWaysLogin) {
              this.otherWaysLoginPopup()
            }
          }
          .margin({ top: '30%' })

          // 底部提示
          this.underBar();
        }
        .backgroundColor('#1A0B1E')
        .width('100%')
        .height('100%')
        .padding(5)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.TOP],)

        if (this.showExperiencePopup) {
          this.experiencePopup();
        }

        if (this.showProblemPopup) {
          this.problemPopup();
        }

        if (this.showCountryListPopup) {
          this.countryListPopup()
        }
      }
    }
    .onShown(() => {
      if (this.uiContext) {
        this.uiContext.setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
      } else {
        console.warn("uiContext is not available in onShown");
      }
    })
  }
}

@Builder
export function LoginBuilder(): void {
  LoginPage();
}