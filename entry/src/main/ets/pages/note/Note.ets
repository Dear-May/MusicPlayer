import componentUtils from '@ohos.arkui.componentUtils';
import { changeSideBarShow, tryCloseSideBar } from '../../constants/GlobalFunction';
import RecommendView from '../../views/note/RecommendView';

@Entry
@Component
struct Note {
  uiContext: UIContext | undefined = undefined;
  @StorageLink('showSideBar') show: boolean = false;
  @State tabArray: string[] = ['关注', '推荐']
  private controller: TabsController = new TabsController()
  @State currentIndex: number = 1
  @State animationDuration: number = 300
  @State indicatorLeftMargin: number = 0
  @State indicatorWidth: number = 0
  private tabsWidth: number = 0

  // 获取组件大小、位置、平移缩放旋转及仿射矩阵属性信息。
  private getTextInfo(index: number): Record<string, number> {
    let modePosition: componentUtils.ComponentInfo = componentUtils.getRectangleById('tab' + index.toString());
    if (!modePosition) {
      // 处理组件未找到的情况，返回默认值或抛出异常
      console.error('组件未找到');
      return { 'left': 0, 'width': 0 };
    }
    // 检查必要的属性是否存在
    if (!modePosition.windowOffset || !modePosition.size) {
      // 处理组件信息不完整的情况
      console.error('组件信息不完整');
      return { 'left': 0, 'width': 0 };
    }
    const px2vp = (px: number) => {
      return px / 750 * 100;
    };
    const left = px2vp(modePosition.windowOffset.x);
    const width = px2vp(modePosition.size.width);
    return { 'left': left, 'width': width };

  }

  private getCurrentIndicatorInfo(index: number, event: TabsAnimationEvent): Record<string, number> {
    let nextIndex = index
    if (index > 0 && event.currentOffset > 0) {
      nextIndex--
    } else if (index < 3 && event.currentOffset < 0) {
      nextIndex++
    }
    let indexInfo = this.getTextInfo(index)
    let nextIndexInfo = this.getTextInfo(nextIndex)
    let swipeRatio = Math.abs(event.currentOffset / this.tabsWidth)
    let currentIndex = swipeRatio > 0.5 ? nextIndex : index // 页面滑动超过一半，tabBar切换到下一页。
    let currentLeft = indexInfo.left + (nextIndexInfo.left - indexInfo.left) * swipeRatio
    let currentWidth = indexInfo.width + (nextIndexInfo.width - indexInfo.width) * swipeRatio
    return { 'index': currentIndex, 'left': currentLeft, 'width': currentWidth }
  }

  private startAnimateTo(duration: number, leftMargin: number, width: number) {
    this.getUIContext().animateTo({
      duration: duration, // 动画时长
      curve: Curve.Linear, // 动画曲线
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        console.info('play end')
      }
    }, () => {
      this.indicatorLeftMargin = leftMargin
      this.indicatorWidth = width
    })
  }

  // 单独的页签
  @Builder
  Tab(tabName: string, tabItem: number, tabIndex: number) {
    Row({ space: 20 }) {
      Text(tabName)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(tabItem === this.currentIndex ? Color.White : '#666')
        .id('tab' + tabIndex.toString())
        .onAreaChange((oldValue: Area, newValue: Area) => {
          if (this.currentIndex === tabIndex && (this.indicatorLeftMargin === 0 || this.indicatorWidth === 0)) {
            if (newValue.position.x != undefined) {
              let positionX = Number.parseFloat(newValue.position.x.toString())
              this.indicatorLeftMargin = Number.isNaN(positionX) ? 0 : positionX
            }
            let width = Number.parseFloat(newValue.width.toString())
            this.indicatorWidth = Number.isNaN(width) ? 0 : width
          }
        })
    }
    .justifyContent(FlexAlign.Center)
    .constraintSize({ minWidth: 35 })
    .width(80)
    .height(38)
    .borderRadius({ topLeft: 10, topRight: 10 })
    .onClick(() => {
      this.controller.changeIndex(tabIndex)
      this.currentIndex = tabIndex
    })
  }

  @Builder
  SideBarControllerButton() {
    Image($r('app.media.menu'))
      .width(24)
      .height(24)
      .margin({ right: 5 })
      .onClick(() => {
        changeSideBarShow(this.getUIContext())
      })
  }

  @Builder
  TopBar() {
    Stack({ alignContent: Alignment.TopStart }) {
      Row() {
        Row() {
          this.SideBarControllerButton()
        }
        .width('25%')

        Row() {
          ForEach(this.tabArray, (item: string, index: number) => {
            this.Tab(item, index, index)
          })
          Column()
            .width(60)
            .height(2)
            .backgroundColor(Color.White)
            .borderRadius(2)
            .margin({ left: this.indicatorLeftMargin - 160, top: 38 })
        }
        .layoutWeight(1)

        Row({ space: 10 }) {
          Image($r('app.media.search'))
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
        .justifyContent(FlexAlign.End)
        .width('30%')
      }
    }
    .width('100%')
    .backgroundColor('#0e0d11')
    .padding({
      left: 16,
      right: 16,
      top: 40,
      bottom: 5
    })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }

  build() {
    Column() {
      // 标题
      this.TopBar();

      //tabs
      Tabs({ barPosition: BarPosition.Start, controller: this.controller, index: 1 }) {
        ForEach(this.tabArray, (item: number, index: number) => {
          TabContent() {
            if (index === 0) {
            } else if (index === 1) {
              RecommendView();
            }
          }
        })
      }
      .onAreaChange((oldValue: Area, newValue: Area) => {
        let width = Number.parseFloat(newValue.width.toString())
        this.tabsWidth = Number.isNaN(width) ? 0 : width
      })
      .barWidth('100%')
      .barHeight(0)
      .width('100%')
      .height('100%')
      .animationDuration(this.animationDuration)
      .onChange((index: number) => {
        if (this.show) {
          tryCloseSideBar(this.getUIContext(), this.show, () => {
          })
          return false
        }
        this.currentIndex = index // 监听索引index的变化，实现页签内容的切换。
        return true
      })
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        // 切换动画开始时触发该回调。下划线跟着页面一起滑动，同时宽度渐变。
        this.currentIndex = targetIndex
        let targetIndexInfo = this.getTextInfo(targetIndex)
        console.log('onAnimationStart', targetIndexInfo.left, targetIndexInfo.width)
        this.startAnimateTo(this.animationDuration, targetIndexInfo.left, targetIndexInfo.width)
      })
      .onAnimationEnd((index: number, event: TabsAnimationEvent) => {
        // 切换动画结束时触发该回调。下划线动画停止。
        let currentIndicatorInfo = this.getCurrentIndicatorInfo(index, event)
        this.startAnimateTo(0, currentIndicatorInfo.left, currentIndicatorInfo.width)
      })
      .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
        if (this.show) {
          tryCloseSideBar(this.getUIContext(), this.show, () => {
          })
          return false
        }
        // 在页面跟手滑动过程中，逐帧触发该回调。
        let currentIndicatorInfo = this.getCurrentIndicatorInfo(index, event)
        this.currentIndex = currentIndicatorInfo.index
        this.indicatorLeftMargin = currentIndicatorInfo.left - 50
        this.indicatorWidth = currentIndicatorInfo.width + 20
        return true
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

export default Note;