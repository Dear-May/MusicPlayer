import { recommendCardType } from '../../models/Music'
import { recommendCardList } from '../../constants/MusicConstants'

@Entry
@Component
struct RecommendView {
  @Builder
  cardList() {
    Scroll() {
      Row({ space: 12 }) {
        ForEach(recommendCardList, (card: recommendCardType) => {
          Stack() {
            //标题
            Row() {
              if (card.icon) {
                Image(card.icon)
                  .width(16)
                  .height(16)
                  .margin({ right: 5 })
              }
              Text(card.title)
                .fontSize(16)
                .fontColor($r('sys.color.white'))
                .fontWeight(FontWeight.Bold)
            }
            .width(120)
            .margin({ left: 16 })
            .justifyContent(FlexAlign.Start)
            .zIndex(1)
            .offset({ y: -60 })

            //标题
            Row() {
              Row() {
                if (card.tag) {
                  Text(card.tag)
                    .fontSize(8)
                    .fontColor($r('sys.color.white'))
                    .backgroundColor('#33333380')
                    .padding({
                      left: 6,
                      right: 6,
                      top: 2,
                      bottom: 2
                    })
                    .borderRadius(4)
                }
                Blank()
                if (card.canPlay) {
                  if (!card.isPlay) {
                    Image($r('app.media.ic_play'))
                      .width(20)
                      .height(20)
                      .margin({ right: 16, bottom: 5 })
                      .onClick(() => {
                        card.isPlay = true
                      })
                  } else {
                    Image($r('app.media.ic_paused'))
                      .width(16)
                      .height(16)
                      .margin({ right: 5, bottom: 5 })
                      .onClick(() => {
                        card.isPlay = false
                      })
                  }
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
            }
            .width(120)
            .margin({ left: 16 })
            .justifyContent(FlexAlign.Start)
            .zIndex(1)
            .offset({ y: 30 })

            // 内容
            Column() {
              Image(card.img)
                .width(120)
                .height(120)
                .borderRadius({
                  topLeft: 12,
                  topRight: 12,
                })

              Column() {
                Text(card.subtitle)
                  .fontSize(12)
                  .fontColor($r('sys.color.white'))
              }
              .padding({
                top: 12,
                left: 6,
                right: 6,
                bottom: 12,
              })
              .backgroundColor('#1d1d1f')
              .width(120)
              .height(40)
              .borderRadius({
                bottomLeft: 12,
                bottomRight: 12,
              })
            }
          }
          .onClick(() => {
            console.log('点击了卡片');
          })
          .width(140)
        })
      }
      .padding({ left: 16 })
    }
    .padding({ top: 16 })
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Horizontal)
  }

  @Builder
  TitleBar(title: string) {
    // 标题
    Row() {
      Text(title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.Black)
    }
    .backgroundColor('#1d1d1f')
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
    Scroll() {
      Column() {
        this.cardList()
        Column() {
          Row() {
            Text('猜你喜欢的「华语」好歌')
              .fontSize(16)
              .fontColor(Color.White)
            Text('免费听')
              .fontSize(12)
              .fontColor('#d8a0a0')
              .backgroundColor('#332222')
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })
              .borderRadius(4)
              .margin({ left: 8 })
          }
          .padding({
            left: 16,
            right: 16,
            top: 12,
            bottom: 6
          })
        }
      }
      .justifyContent(FlexAlign.Start)
    }
    .height('100%')
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Vertical)
  }
}

export default RecommendView;