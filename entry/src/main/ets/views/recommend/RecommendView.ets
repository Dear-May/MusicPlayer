import { recommendCardType, songItemType } from '../../models/Music'
import { recommendCardList, songs } from '../../constants/MusicConstants'
import { tryCloseSideBar } from '../../constants/GlobalFunction';

@Reusable
struct CardItem {
  @Prop card: recommendCardType
  @StorageLink('showSideBar') show: boolean = false;

  build() {
    Stack() {
      //标题
      Row() {
        if (this.card.icon) {
          Image(this.card.icon)
            .width(16)
            .height(16)
            .margin({ right: 5 })
        }
        Text(this.card.title)
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
          if (this.card.tag) {
            Text(this.card.tag)
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
          if (this.card.canPlay) {
            if (!this.card.isPlay) {
              Image($r('app.media.ic_play'))
                .width(20)
                .height(20)
                .margin({ right: 16, bottom: 5 })
                .onClick(() => {
                  this.card.isPlay = true
                })
            } else {
              Image($r('app.media.ic_paused'))
                .width(16)
                .height(16)
                .margin({ right: 5, bottom: 5 })
                .onClick(() => {
                  this.card.isPlay = false
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
        Image(this.card.img)
          .width(120)
          .height(120)
          .borderRadius({
            topLeft: 12,
            topRight: 12,
          })

        Column() {
          Text(this.card.subtitle)
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
      tryCloseSideBar(this.getUIContext(), this.show, () => {
        console.log('点击了歌单');
      })
    })
    .width(140)
  }
}

@Reusable
struct SongCardItem {
  @Prop song: songItemType
  @StorageLink('showSideBar') show: boolean = false;

  build() {
    Row() {
      Image(this.song.img)
        .width(70)
        .height(70)
        .borderRadius(4)
      Column({ space: 10 }) {
        Text(this.song.name)
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
        Row() {
          if (this.song.tag) {
            Text(this.song.tag)
              .fontSize(10)
              .fontColor('#ff4a4a')
              .margin({ right: 6 })
          }
          Text(this.song.author).fontSize(12).fontColor('#888888')
        }
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 10 })
      .layoutWeight(1)

      Image($r('app.media.ic_play'))
        .width(25)
        .height(25)
    }
    .padding({
      left: '23vp',
      right: 3,
    })
    .width('88%')
  }
}

@Preview
@Component
struct RecommendView {
  @StorageLink('showSideBar') show: boolean = false;
  @State loadedOne: boolean = false
  @State loadedTwo: boolean = false
  @State loadedThree: boolean = false
  @State loadedFour: boolean = false
  @State loadedFive: boolean = false
  @State loadedSix: boolean = false

  private chunkSongs(data: songItemType[], size: number): songItemType[][] {
    let result: songItemType[][] = [];
    for (let i = 0; i < data.length; i += size) {
      result.push(data.slice(i, i + size));
    }
    return result;
  }

  @Builder
  cardList() {
    Scroll() {
      Row({ space: 12 }) {
        ForEach(recommendCardList, (card: recommendCardType) => {
          CardItem({ card: card })
        })
      }
      .padding({ left: 16 })
    }
    .padding({ top: 16 })
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Horizontal)
  }

  @Builder
  songCardList() {
    Scroll() {
      Row() {
        ForEach(this.chunkSongs(songs, 3), (group: songItemType[]) => {
          Column({ space: 0 }) {
            ForEach(group, (song: songItemType) => {
              SongCardItem({ song: song })
            })
          }
        })
      }
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }

  @Builder
  TitleBar(title: string) {
    Row() {
      Text(title)
        .fontSize(18)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .padding({
      left: '23vp',
      right: 16,
      top: 12,
      bottom: 6
    })
  }

  build() {
    Scroll() {
      Column() {
        this.cardList()
        Column() {
          Row() {
            Text('猜你喜欢的「华语」好歌')
              .fontSize(18)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Bold)
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
          .width('100%')
          .padding({
            left: '23vp',
            right: 16,
            top: 12,
            bottom: 6
          })

          this.songCardList();
        }

        Column() {
          this.TitleBar('推荐歌单>')
          this.cardList()
        }

        // 第一块页面
        Column() {
          if (this.loadedOne) {
            Column() {
              this.TitleBar('雷达歌单>')
              this.cardList()
            }

            Column() {
              this.TitleBar('排行榜>')
              this.cardList()
            }

            Column() {
              this.TitleBar('XX最近的热门歌曲')
              this.cardList()
            }
          }
        }
        .onAppear(() => {
          this.loadedOne = true;
        })

        // 第二块页面
        Column() {
          if (this.loadedTwo) {
            Column() {
              Row() {
                Text('VIP专属好歌限时免费听>')
                  .fontSize(18)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
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
              .width('100%')
              .padding({
                left: '23vp',
                right: 16,
                top: 12,
                bottom: 6
              })

              this.songCardList();
            }

            Column() {
              this.TitleBar('从你喜欢的歌曲开始漫游')
              this.cardList()
            }

            Column() {
              this.TitleBar('XX的推荐歌单')
              this.cardList()
            }
          }
        }
        .onAppear(() => {
          this.loadedTwo = true;
        })

        // 第三块页面
        Column() {
          if (this.loadedThree) {
            Column() {
              Row() {
                Text('为你精选的音乐播客>')
                  .fontSize(18)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')
              .padding({
                left: '23vp',
                right: 16,
                top: 12,
                bottom: 6
              })

              this.songCardList();
            }

            Column() {
              Row() {
                Text('为你严选的精品有声书>')
                  .fontSize(18)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')
              .padding({
                left: '23vp',
                right: 16,
                top: 12,
                bottom: 6
              })

              this.songCardList();
            }

            Column() {
              Row() {
                Text('为你推荐的热门节目>')
                  .fontSize(18)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')
              .padding({
                left: '23vp',
                right: 16,
                top: 12,
                bottom: 6
              })

              this.songCardList();
            }
          }
        }
        .onAppear(() => {
          this.loadedThree = true;
        })

        // 第四块页面
        Column() {
          if (this.loadedFour) {
            Column() {
              this.TitleBar('从你喜欢的艺人开始漫游')
              this.cardList()
            }

            Column() {
              this.TitleBar('场景歌单')
              this.cardList()
            }

            Column() {
              this.TitleBar('你的专属推荐歌单')
              this.cardList()
            }
          }
        }
        .onAppear(() => {
          this.loadedFour = true;
        })

        // 第五块页面
        Column() {
          if (this.loadedFive) {
            Column() {
              Row() {
                Text('电音风暴 二创狂欢')
                  .fontSize(18)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')
              .padding({
                left: '23vp',
                right: 16,
                top: 12,
                bottom: 6
              })

              this.songCardList();
            }

            Column() {
              Row() {
                Text('大家都爱听')
                  .fontSize(18)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
              .width('100%')
              .padding({
                left: '23vp',
                right: 16,
                top: 12,
                bottom: 6
              })

              this.songCardList();
            }

            Column() {
              this.TitleBar('为你精选的原创歌曲')
              this.cardList()
            }
          }
        }
        .onAppear(() => {
          this.loadedFive = true;
        })

        // 第六块页面
        Column() {
          if (this.loadedSix) {
            Column() {
              this.TitleBar('每周新热趋势')
              this.cardList()
            }

            Column() {
              this.TitleBar('广播')
              this.cardList()
            }

            Column() {
              this.TitleBar('影视原声')
              this.cardList()
            }
          }
        }
        .onAppear(() => {
          this.loadedSix = true;
        })

        Blank()
          .height('20%')
      }
      .justifyContent(FlexAlign.Start)
    }
    .height('100%')
    .scrollBar(BarState.Off)
    .scrollable(ScrollDirection.Vertical)
  }
}

export default RecommendView;