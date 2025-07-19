import { recommendList, dailyRecommend } from '../../constants/MusicConstants'
import { recommendListType, recommendDailyType } from '../../models/Music'

@Entry
@Component
struct Recommend {
  @State currentTab: number = 0;
  private tabs: string[] = ['推荐', '音乐', '播客', '听书', '免费听'];
  @State navList: Array<number> = [0, 1, 2, 3, 4, 5];
  @State active: number = 0;
  @State show: boolean = false;

  @Builder
  TopBar() {
    Row() {
      Row({ space: 5 }) {
        Image($r('app.media.search'))
          .width(24)
          .height(24)
          .margin({ right: 12 })

        TextInput({ placeholder: '****', })
          .width('70%')
          .height(36)
          .borderRadius(18)
          .padding({ left: 10 })

        Image($r('app.media.ScanCode'))
          .width(24)
          .height(24)
          .margin({ right: 12 })
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
    .padding({
      top: 40,
      left: 16,
      right: 16,
    })
  }

  @Builder
  TitleBar(title: string) {
    // 标题
    Row() {
      Text(title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
      Image($r('app.media.ic_mine_gt'))
        .width(15)
    }
    .width('100%')
    .padding(8)
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({
      left: '12vp',
      right: '12vp'
    })
    .margin({
      top: '20vp',
      bottom: '12vp'
    })
  }

  build() {
    Column() {
      this.TopBar()
      Scroll() {
        Column({}) {
          //轮播
          Scroll() {
            Row({ space: 10 }) {
              ForEach(dailyRecommend, (item: recommendDailyType) => {
                Column() {
                  Column() {
                    Row() {
                      Image($r('app.media.ic_mine_gt'))
                        .width('60px')
                        .height('60px')
                        .fillColor('#000000')
                        .margin({ left: '10px' })
                      Text(item.title)
                        .width('100%')
                        .textAlign(TextAlign.Start)
                        .fontColor(Color.White)
                        .fontWeight(FontWeight.Bold)
                        .fontSize(13)
                        .padding(8)
                    }
                    .padding({ left: 8, top: 6 })

                    Stack({ alignContent: Alignment.Center }) {
                      Row() {
                        Image($r('app.media.ic_mine_gt'))
                          .width('50%')
                          .aspectRatio(1)
                        Image($r('app.media.ic_mine_gt'))
                          .width('50%')
                          .aspectRatio(1)
                      }
                      .width('100%')
                      .margin({ top: '50px' })
                      .alignItems(VerticalAlign.Center)

                      Image(item.img)
                        .width('63%')
                        .borderRadius('10px')
                        .aspectRatio(1)
                    }
                    .width('100%')
                    .margin({ top: '50px' })
                    .alignContent(Alignment.Center)
                  }
                  .height('33%')
                  .backgroundImage(item.img)
                  .backgroundImageSize(ImageSize.Cover)
                  .backdropBlur(50)
                  .flexGrow(3)

                  Row() {
                    Column() {
                      Text(item.type)
                        .fontSize(20)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#ffffff')
                        .margin({ left: '20px' })
                        .textOverflow({
                          overflow: TextOverflow.Ellipsis
                        })
                      Text(item.song)
                        .fontSize(13)
                        .fontColor('#f8f8ff')
                        .margin({ left: '20px' })
                        .maxLines(1)
                        .textOverflow({
                          overflow: TextOverflow.Ellipsis
                        })
                        .padding({ top: 5 })
                    }
                    .width('80%')
                    .justifyContent(FlexAlign.Start)
                    .alignItems(HorizontalAlign.Start)
                    .margin({ top: '30px', bottom: '30px' })

                    Image($r('app.media.ic_mine_gt'))
                      .width('117px')
                      .height('120px')
                      .fillColor('#000000')
                  }
                  .flexGrow(1)
                  .width('100%')
                  .height('11%')
                  .padding({ left: 10, right: 12 })
                  .justifyContent(FlexAlign.SpaceBetween)
                  .backgroundColor(item.bottom)
                }
                .backgroundImage(item.img)
                .backgroundImageSize(ImageSize.Cover)
                .backdropBlur(70.68)
                .width('63%')
                .borderRadius(16)
                .clip(true)
              })
            }
          }
          .width('100%')
          .scrollable(ScrollDirection.Horizontal)
          .scrollBarWidth(0)
          .padding({ left: 16 })

          //   推荐歌单
          Column() {
            this.TitleBar('Hi Raven，为你推荐')
            // 歌单项
            Row() {
              Scroll() {
                Row({ space: 10 }) {
                  ForEach(recommendList, (item: recommendListType) => {
                    Column() {
                      Column() {
                        Stack({ alignContent: Alignment.Center }) {
                          Row() {
                            Image($r('app.media.ic_mine_gt'))
                              .width('50%')
                              .aspectRatio(1)
                            Image($r('app.media.ic_mine_gt'))
                              .width('50%')
                              .aspectRatio(1)
                          }
                          .width('100%')
                          .margin({ top: '50px' })
                          .alignItems(VerticalAlign.Center)

                          Image(item.img)
                            .width('63%')
                            .borderRadius(10)
                            .aspectRatio(1)
                        }
                        .padding({ top: 18, bottom: 4 })
                        .alignContent(Alignment.Center)

                        Row() {
                          Image($r('app.media.ic_mine_gt'))
                            .width('70px')
                            .height('70px')
                            .fillColor($r('sys.color.black'))
                            .margin({ left: '30px', bottom: '20px' })
                          Text(item.count)
                            .width('100%')
                            .fontSize(11)
                            .textAlign(TextAlign.Start)
                            .fontColor(Color.White)
                            .fontWeight(FontWeight.Bold)
                            .padding(8)
                        }
                        .margin({ bottom: '20px' })
                        .alignItems(VerticalAlign.Center)
                      }
                      .aspectRatio(1)
                      .borderRadius(10)
                      .backgroundImage(item.img)
                      .backgroundImageSize(ImageSize.Cover)
                      .backdropBlur(65.24)

                      Text(item.title)
                        .textAlign(TextAlign.Start)
                        .fontSize(15)
                        .fontWeight(FontWeight.Regular)
                        .fontColor($r('sys.color.black'))
                        .maxLines(2)
                        .textOverflow({
                          overflow: TextOverflow.Ellipsis
                        })
                        .margin({
                          top: 8
                        })
                    }
                    .justifyContent(FlexAlign.SpaceBetween)
                    .borderRadius(16)
                    .width('38%')
                  })
                }
              }
              .width('100%')
              .scrollable(ScrollDirection.Horizontal)
              .scrollBar(BarState.Off)
            }
            .padding({ left: 16 })
          }
        }
        .width('100%')
        .backgroundColor($r('sys.color.icon_on_primary'))
        .justifyContent(FlexAlign.Start)
        .padding({
          top: AppStorage.get<number>('topHeight'),
          bottom: AppStorage.get<number>('bottomHeight')
        })
      }
      .height('100%')
    }
    .onClick(() => {
      this.getUIContext().animateTo({
        duration: 1500,
        curve: Curve.EaseOut,
        playMode: PlayMode.Normal,
      }, () => {
        this.show = false;
      })
    })
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

export default Recommend