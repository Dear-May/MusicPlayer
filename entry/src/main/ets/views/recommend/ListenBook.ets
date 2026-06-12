import { songs } from '../../constants/MusicConstants';
import { songItemType } from '../../models/Music';
import DjApi from '../../feature/recommend/DjApi';
import { SongItem, DjRadioItem } from '../../common/models/ApiTypes';

@Component
struct ListenBook {
  @State private apiBookList: DjRadioItem[] = [];
  @State private localBookList: songItemType[] = songs.slice(0, 5);
  @State private isLoading: boolean = false;

  aboutToAppear(): void {
    this.loadBookData();
  }

  private async loadBookData() {
    this.isLoading = true;
    try {
      const result = await DjApi.getHot(5);
      if (result.code === 200 && result.result) {
        this.apiBookList = result.result as DjRadioItem[];
      }
    } catch (err) {
      console.error('ListenBook load error:', JSON.stringify(err));
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('精品有声书')
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
        // 有声书列表
        Scroll() {
          Column() {
            if (this.apiBookList.length > 0) {
              ForEach(this.apiBookList, (item: DjRadioItem, index: number) => {
                Row() {
                  Stack() {
                    Image(item.picUrl)
                      .width(80)
                      .height(80)
                      .borderRadius(6)
                      .objectFit(ImageFit.Cover)

                    Text('第' + (index + 1) + '集')
                      .fontSize(10)
                      .fontColor(Color.White)
                      .backgroundColor('#80000000')
                      .borderRadius({ bottomLeft: 6, bottomRight: 6 })
                      .width('100%')
                      .height(20)
                      .textAlign(TextAlign.Center)
                      .align(Alignment.Bottom)
                  }

                  Column({ space: 6 }) {
                    Text(item.name)
                      .fontSize(16)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Row({ space: 4 }) {
                      Text('有声书')
                        .fontSize(10)
                        .fontColor('#d8a0a0')
                        .backgroundColor('#332222')
                        .padding({ left: 4, right: 4, top: 2, bottom: 2 })
                        .borderRadius(4)

                      Text((item.dj?.nickname || '未知主播') + ' · 已更新' + item.programCount + '期')
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
              ForEach(this.localBookList, (item: songItemType, index: number) => {
                Row() {
                  Stack() {
                    Image($r('app.media.record_center'))
                      .width(80)
                      .height(80)
                      .borderRadius(6)

                    Text('第' + (index + 1) + '集')
                      .fontSize(10)
                      .fontColor(Color.White)
                      .backgroundColor('#80000000')
                      .borderRadius({ bottomLeft: 6, bottomRight: 6 })
                      .width('100%')
                      .height(20)
                      .textAlign(TextAlign.Center)
                      .align(Alignment.Bottom)
                  }

                  Column({ space: 6 }) {
                    Text(item.name + ' - 有声小说')
                      .fontSize(16)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })

                    Row({ space: 4 }) {
                      Text('有声书')
                        .fontSize(10)
                        .fontColor('#d8a0a0')
                        .backgroundColor('#332222')
                        .padding({ left: 4, right: 4, top: 2, bottom: 2 })
                        .borderRadius(4)

                      Text(item.author + ' · 已更新35集')
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

export default ListenBook;
