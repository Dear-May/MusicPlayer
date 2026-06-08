import { songs } from '../../constants/MusicConstants';
import { songItemType } from '../../models/Music';
import DjApi from '../../utils/api/DjApi';
import { SongItem, DjRadioItem } from '../../utils/api/ApiTypes';

@Component
struct Podcast {
  @State private apiDjList: DjRadioItem[] = [];
  @State private localPodcastList: songItemType[] = songs.slice(0, 6);
  @State private isLoading: boolean = false;

  aboutToAppear(): void {
    this.loadDjData();
  }

  private async loadDjData() {
    this.isLoading = true;
    try {
      const result = await DjApi.getRecommend();
      if (result.code === 200 && result.result) {
        this.apiDjList = result.result as DjRadioItem[];
      }
    } catch (err) {
      console.error('Podcast load DJ data error:', JSON.stringify(err));
      // 降级到推荐电台
      try {
        const hotResult = await DjApi.getHot(6);
        if (hotResult.code === 200 && hotResult.result) {
          this.apiDjList = hotResult.result as DjRadioItem[];
        }
      } catch (_e) {
        console.error('Podcast hot fallback also failed');
      }
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('精选播客')
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text('更多>')
          .fontSize(14)
          .fontColor('#888')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      if (this.isLoading) {
        LoadingProgress().color(Color.White).width(36).height(36)
      } else {
        // 播客列表
        Scroll() {
          Column() {
            if (this.apiDjList.length > 0) {
              ForEach(this.apiDjList, (item: DjRadioItem) => {
                Row() {
                  Column() {
                    Image(item.picUrl)
                      .width(60)
                      .height(60)
                      .borderRadius(8)
                      .objectFit(ImageFit.Cover)
                  }

                  Column({ space: 6 }) {
                    Text(item.name)
                      .fontSize(16)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Row({ space: 4 }) {
                      Text('播客')
                        .fontSize(10)
                        .fontColor('#ff4a4a')
                        .backgroundColor('#332222')
                        .padding({ left: 4, right: 4, top: 2, bottom: 2 })
                        .borderRadius(4)

                      Text((item.dj?.nickname || '未知主播') + ' · ' + item.programCount + '期')
                        .fontSize(12)
                        .fontColor('#888')
                    }
                  }
                  .layoutWeight(1)
                  .margin({ left: 12 })
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              })
            } else {
              // 降级到本地数据
              ForEach(this.localPodcastList, (item: songItemType) => {
                Row() {
                  Column() {
                    Image($r('app.media.record'))
                      .width(60)
                      .height(60)
                      .borderRadius(8)
                  }

                  Column({ space: 6 }) {
                    Text(item.name + ' - 播客专访')
                      .fontSize(16)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Row({ space: 4 }) {
                      Text('播客')
                        .fontSize(10)
                        .fontColor('#ff4a4a')
                        .backgroundColor('#332222')
                        .padding({ left: 4, right: 4, top: 2, bottom: 2 })
                        .borderRadius(4)

                      Text(item.author + ' · 45分钟')
                        .fontSize(12)
                        .fontColor('#888')
                    }
                  }
                  .layoutWeight(1)
                  .margin({ left: 12 })
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              })
            }
          }
        }
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
  }
}

export default Podcast;
