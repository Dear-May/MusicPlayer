import { songs } from '../../constants/MusicConstants';
import { songItemType } from '../../models/Music';
import RecommendApi from '../../feature/recommend/RecommendApi';
import { SongItem } from '../../common/models/ApiTypes';

@Component
struct ListenFree {
  @State private apiNewSongs: SongItem[] = [];
  @State private localFreeSongs: songItemType[] = songs;
  @State private isLoading: boolean = false;

  aboutToAppear(): void {
    this.loadNewSongs();
  }

  private async loadNewSongs() {
    this.isLoading = true;
    try {
      const result = await RecommendApi.getNewSong(9);
      if (result.code === 200 && result.data) {
        this.apiNewSongs = result.data as SongItem[];
      }
    } catch (err) {
      console.error('ListenFree load new songs error:', JSON.stringify(err));
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('免费畅听')
          .fontSize(18)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)

        Text('VIP专享')
          .fontSize(12)
          .fontColor('#d8a0a0')
          .backgroundColor('#332222')
          .padding({ left: 6, right: 6, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ left: 8 })
        Blank()
        Text('更多>')
          .fontSize(14)
          .fontColor('#888')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      if (this.isLoading) {
        LoadingProgress().color(Color.White).width(36).height(36)
      } else if (this.apiNewSongs.length > 0) {
        // 使用API新歌
        Scroll() {
          Column() {
            // 分成三行展示
            ForEach([0, 3, 6], (start: number) => {
              Row({ space: 12 }) {
                ForEach(this.apiNewSongs.slice(start, start + 3), (item: SongItem) => {
                  Column({ space: 4 }) {
                    Image(item.album?.picUrl)
                      .width(100)
                      .height(100)
                      .borderRadius(8)
                      .objectFit(ImageFit.Cover)

                    Text(item.name)
                      .fontSize(12)
                      .fontColor(Color.White)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .width(100)

                    Text(item.artists.map(a => a.name).join('/'))
                      .fontSize(10)
                      .fontColor('#888')
                      .width(100)
                  }
                })
              }
              .padding({ left: 16, top: 8 })
            })
          }
        }
        .scrollBar(BarState.Off)
      } else {
        // 降级到本地数据
        Scroll() {
          Column() {
            ForEach([0, 3, 6], (start: number) => {
              Row({ space: 12 }) {
                ForEach(this.localFreeSongs.slice(start, start + 3), (item: songItemType) => {
                  Column({ space: 4 }) {
                    Image($r('app.media.image_1'))
                      .width(100)
                      .height(100)
                      .borderRadius(8)

                    Text(item.name)
                      .fontSize(12)
                      .fontColor(Color.White)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                      .width(100)

                    Text(item.author)
                      .fontSize(10)
                      .fontColor('#888')
                      .width(100)
                  }
                })
              }
              .padding({ left: 16, top: 8 })
            })
          }
        }
        .scrollBar(BarState.Off)
      }
    }
    .width('100%')
    .height('100%')
  }
}

export default ListenFree;
