import { KeyboardAvoidMode } from '@kit.ArkUI';
import countries from '../../../assets/country_code_cn.json'
import { BasicDataSource } from '../../utils/BasicDataSource'
import LoginApi from '../../feature/login/LoginApi'
import { ApiResponse } from '../../common/models/ApiTypes'
import UserStateManager from '../../feature/user/UserStateManager'

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
  @State password: string = '';
  @State captcha: string = '';
  @State agree: boolean = false;
  @State loginMode: 'captcha' | 'password' = 'password';
  @State isLoading: boolean = false;
  @State errorMsg: string = '';
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
  @State isFromIndexPage: boolean = false;

  aboutToAppear() {
    this.uiContext = this.getUIContext();
    if (!this.uiContext) {
      console.warn("no uiContext");
      return;
    }
    // 检查来源：侧边栏(IndexPage) push 进来的，还是 WelcomePage replace 过来的
    const params = this.uiContext.getRouter().getParams();
    if (params && Reflect.get(params, 'source') === 'IndexPage') {
      this.isFromIndexPage = true;
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

  private RouterToPage(text: string, parms: string, useReplace: boolean = false) {
    const router = this.getUIContext().getRouter();
    if (useReplace) {
      router.replaceUrl({ url: text, params: { type: parms, source: 'loginPage' } }, (err: BusinessError) => {
        if (err) {
          console.error('页面跳转失败', JSON.stringify(err));
        }
      });
    } else {
      router.pushUrl({ url: text, params: { type: parms, source: 'loginPage' } }, (err: BusinessError) => {
        if (err) {
          console.error('页面跳转失败', JSON.stringify(err));
        }
      });
    }
  }

  // 登录
  private async handleLogin() {
    if (!this.phone || this.phone.length < 6) {
      this.errorMsg = '请输入正确的手机号';
      return;
    }
    if (!this.agree) {
      this.errorMsg = '请先阅读并同意服务条款和隐私政策';
      return;
    }

    this.isLoading = true;
    this.errorMsg = '';

    try {
      const countryCode = this.areaCode.replace('+', '');
      // 密码登录
      if (this.loginMode === 'password') {
        if (!this.password) {
          this.errorMsg = '请输入密码';
          this.isLoading = false;
          return;
        }
        const result = await LoginApi.loginByPhone(this.phone, this.password, countryCode);
        if (result.code === 200) {
          // 登录成功
          console.info('LoginPage: login success', result.profile?.nickname);
          const appContext = this.getUIContext().getHostContext()?.getApplicationContext();
          if (!appContext) {
            console.error('LoginPage: failed to get application context');
            this.isLoading = false;
            return;
          }
          await UserStateManager.onLoginSuccess(appContext, result.profile);
          AppStorage.setOrCreate('showSideBar', false);
          if (this.isFromIndexPage) {
            this.getUIContext().getRouter().back();
          } else {
            this.RouterToPage('pages/Index', '', true);
          }
        } else {
          this.errorMsg = result.message || '登录失败，请检查账号密码';
        }
      } else {
        // 验证码登录 - 先发送验证码
        if (!this.captcha) {
          this.errorMsg = '请输入验证码';
          this.isLoading = false;
          return;
        }
        const verifyResult: ApiResponse = await LoginApi.verifyCaptcha(this.phone, this.captcha);
        if (verifyResult.code === 200) {
          this.errorMsg = '验证码验证通过（需后端配合完善完整登录流程）';
        } else {
          this.errorMsg = verifyResult.message || '验证码错误';
        }
      }
    } catch (err) {
      console.error('LoginPage: login error', JSON.stringify(err));
      this.errorMsg = '网络连接失败，请确认API服务已启动(localhost:3000)';
    } finally {
      this.isLoading = false;
    }
  }

  // 发送验证码
  private async sendCaptcha() {
    const countryCode = this.areaCode.replace('+', '');
    if (!this.phone || this.phone.length < 6) {
      this.errorMsg = '请输入正确的手机号';
      return;
    }
    try {
      this.isLoading = true;
      this.areaCode = this.areaCode.replace('+', '');
      const result: ApiResponse = await LoginApi.sendCaptcha(this.phone, countryCode);
      if (result.code === 200) {
        this.errorMsg = '验证码已发送';
      } else {
        this.errorMsg = result.message || '发送失败';
      }
    } catch (err) {
      console.error('LoginPage: send captcha error', JSON.stringify(err));
      this.errorMsg = '网络连接失败，请确认API服务已启动(localhost:3000)';
    } finally {
      this.isLoading = false;
    }
  }

  //游客登录
  private async handleGuestLogin() {
    this.isLoading = true;
    try {
      const result = await LoginApi.registerAnonymous()
      console.info('LoginPage: guest login result', result.code)
      if (result.code === 200) {
        console.info('LoginPage: guest login success', result.profile?.nickname);
        const appContext = this.getUIContext().getHostContext()?.getApplicationContext();
        if (!appContext) {
          console.error('LoginPage: failed to get application context');
          this.isLoading = false;
          return;
        }
        await UserStateManager.onLoginSuccess(appContext, result.profile);
        AppStorage.setOrCreate('showSideBar', false);
        if (this.isFromIndexPage) {
          this.getUIContext().getRouter().back();
        } else {
          this.RouterToPage('pages/Index', '', true);
        }
      } else {
        this.errorMsg = result.message || '登录失败';
      }
    } catch (err) {
      console.error('LoginPage: guest login error', JSON.stringify(err));
      this.errorMsg = '网络连接失败，请确认API服务已启动(localhost:3000)';
    } finally {
      this.isLoading = false;
    }
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
              AppStorage.setOrCreate('showSideBar', false);
              this.handleGuestLogin();
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
          this.problemChoose('手机号已更换', 'pages/other/AccountRecoveryPage')
          this.problemChoose('找回原账号', 'pages/other/AccountRecoveryPage')
          this.problemChoose('其他问题', 'pages/other/CustomerServicePage')
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
                try {
                  this.listScroller.scrollToItemInGroup(index, 0)
                } catch (error) {
                  // TODO: Implement error handling.
                }
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
        Column({ space: 10 }) {
          this.titleBar();

          Column() {
            // LOGO
            Column() {
              Image($r("app.media.foreground"))
                .width(60)
                .height(60)
                .objectFit(ImageFit.Contain)
            }
            .width(90)
            .height(90)
            .borderRadius(45)
            .backgroundColor('#ec271b')
            .padding(15)

            // 手机输入框
            Column() {
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
                  .onChange((value: string) => {
                    this.phone = value;
                    this.errorMsg = '';
                  })
              }
              .padding(10)
              .backgroundColor('#2a2a2a')
              .borderRadius(10)
              .margin({ top: '35%', left: 30, right: 30 })

              // 密码输入框（密码登录模式）
              if (this.loginMode === 'password') {
                Row({ space: 10 }) {
                  TextInput({ placeholder: '输入密码', text: this.password })
                    .type(InputType.Password)
                    .fontColor('#ccc')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .layoutWeight(1)
                    .caretColor('#ec271b')
                    .placeholderColor('#ff4f4f4f')
                    .backgroundColor('#2a2a2a')
                    .padding(13)
                    .borderRadius(10)
                    .margin({ top: 10, left: 30, right: 30 })
                    .onChange((value: string) => {
                      this.password = value;
                      this.errorMsg = '';
                    })
                }
              }

              // 验证码输入框（验证码登录模式）
              if (this.loginMode === 'captcha') {
                Row({ space: 10 }) {
                  TextInput({ placeholder: '输入验证码', text: this.captcha })
                    .fontColor('#ccc')
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .layoutWeight(1)
                    .maxLength(6)
                    .caretColor('#ec271b')
                    .inputFilter("[0-9]")
                    .placeholderColor('#ff4f4f4f')
                    .backgroundColor('#2a2a2a')
                    .padding(13)
                    .borderRadius(10)
                    .onChange((value: string) => {
                      this.captcha = value;
                      this.errorMsg = '';
                    })

                  Button('获取验证码')
                    .fontSize(14)
                    .fontColor('#fff')
                    .backgroundColor('#fe3a3b')
                    .borderRadius(20)
                    .height(45)
                    .width(110)
                    .onClick(() => this.sendCaptcha())
                }
                .margin({ top: 10, left: 30, right: 30 })
              }

              // 登录模式切换
              Row({ space: 10 }) {
                Text('密码登录')
                  .fontSize(14)
                  .fontColor(this.loginMode === 'password' ? '#fe3a3b' : '#666')
                  .onClick(() => {
                    this.loginMode = 'password';
                    this.errorMsg = '';
                  })
                Text('|')
                  .fontColor('#666')
                Text('验证码登录')
                  .fontSize(14)
                  .fontColor(this.loginMode === 'captcha' ? '#fe3a3b' : '#666')
                  .onClick(() => {
                    this.loginMode = 'captcha';
                    this.errorMsg = '';
                  })
              }
              .margin({ top: 15 })
              .justifyContent(FlexAlign.Center)
              .width('100%')

              // 错误提示
              if (this.errorMsg) {
                Text(this.errorMsg)
                  .fontSize(13)
                  .fontColor('#ff6b6b')
                  .margin({ top: 8, left: 30, right: 30 })
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }

              // 登录按钮
              Button(this.loginMode === 'password' ? '手机号登录' : '验证码登录')
                .fontSize(16)
                .fontColor('#fff')
                .backgroundColor('#fe3a3b')
                .borderRadius(22.5)
                .width('75%')
                .height(45)
                .margin({ top: 15 })
                .enabled(!this.isLoading)
                .onClick(() => this.handleLogin())

              // 加载提示
              if (this.isLoading) {
                LoadingProgress()
                  .color(Color.White)
                  .width(24)
                  .height(24)
                  .margin({ top: 8 })
              }

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