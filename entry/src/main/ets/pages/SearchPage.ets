import SearchApi from '../utils/api/SearchApi';
import SongApi from '../utils/api/SongApi';
import { SongItem } from '../utils/api/ApiTypes';
import AudioPlayerManager from '../utils/AudioPlayerManager';

@Entry
@Component
struct SearchPage {
  @State searchText: string = '';
  @State searchResults: SongItem[] = [];
  @State hasSearched: boolean = false;
  @State isLoading: boolean = false;
  @State errorMsg: string = '';
  private audioManager: AudioPlayerManager = AudioPlayerManager.getInstance();
  private searchTimer: number = -1;

  // 搜索
  private async doSearch() {
    if (!this.searchText.trim()) {
      this.searchResults = [];
      this.hasSearched = false;
      return;
    }

    this.isLoading = true;
    this.errorMsg = '';

    try {
      const result = await SearchApi.search(this.searchText.trim(), 1, 20);
      if (result.code === 200 && result.result?.songs) {
        this.searchResults = result.result.songs;
        this.hasSearched = true;
      } else {
        this.searchResults = [];
        this.hasSearched = true;
      }
    } catch (err) {
      console.error('SearchPage: search error', JSON.stringify(err));
      this.errorMsg = '搜索失败，请确认API服务已启动';
      this.searchResults = [];
      this.hasSearched = true;
    } finally {
      this.isLoading = false;
    }
  }

  // 播放歌曲
  private async playSong(song: SongItem) {
    try {
      const urlResult = await SongApi.getSongUrl(song.id.toString(), 320000);
      if (urlResult.code === 200 && urlResult.data && urlResult.data.length > 0) {
        const songUrl = urlResult.data[0].url;
        if (songUrl && songUrl !== '') {
          const artistNames = song.artists.map(a => a.name).join('/');
          await this.audioManager.initPlayer(songUrl, song.name, artistNames, song.album?.picUrl || '');
        } else {
          console.error('SearchPage: 歌曲无播放地址，可能需要VIP');
        }
      }
    } catch (err) {
      console.error('SearchPage: play error', JSON.stringify(err));
    }
  }

  build() {
    Column() {
      Row() {
        TextInput({ placeholder: '搜索歌曲、歌手、专辑', text: this.searchText })
          .width('85%')
          .height(40)
          .fontSize(16)
          .placeholderColor('#666')
          .backgroundColor('#333')
          .borderRadius(20)
          .padding({ left: 16 })
          .onChange((value: string) => {
            this.searchText = value;
            // 取消之前的定时器，实现防抖
            if (this.searchTimer !== -1) {
              clearTimeout(this.searchTimer);
            }
            this.searchTimer = setTimeout(() => {
              this.doSearch();
            }, 500);
          })
          .onSubmit(() => {
            this.doSearch();
          })

        Blank()

        Text('取消')
          .fontSize(16)
          .fontColor('#999')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 48 })
      .backgroundColor('#0e0d11')
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])

      // 加载中
      if (this.isLoading) {
        Column() {
          LoadingProgress()
            .color(Color.White)
            .width(36)
            .height(36)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.errorMsg) {
        // 错误提示
        Column() {
          Text(this.errorMsg)
            .fontSize(14)
            .fontColor('#ff6b6b')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.hasSearched && this.searchResults.length === 0) {
        // 无结果
        Column() {
          Text('未找到相关歌曲')
            .fontSize(14)
            .fontColor('#666')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (!this.hasSearched) {
        // 初始状态
        Column() {
          Text('搜索你喜欢的音乐')
            .fontSize(14)
            .fontColor('#666')
            .margin({ top: '60%' })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else {
        // 搜索结果
        Scroll() {
          Column() {
            ForEach(this.searchResults, (song: SongItem, index: number) => {
              Row() {
                // 专辑封面
                Image(song.album?.picUrl)
                  .width(50)
                  .height(50)
                  .borderRadius(6)
                  .objectFit(ImageFit.Cover)

                Column({ space: 4 }) {
                  Text(song.name)
                    .fontSize(16)
                    .fontColor(Color.White)
                    .fontWeight(FontWeight.Medium)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(song.artists.map(a => a.name).join('/'))
                    .fontSize(12)
                    .fontColor('#888')
                }
                .layoutWeight(1)
                .margin({ left: 12 })

                // 播放按钮
                Image($r('app.media.ic_play'))
                  .width(28)
                  .height(28)
                  .onClick(() => this.playSong(song))
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              .onClick(() => this.playSong(song))

              if (index < this.searchResults.length - 1) {
                Divider()
                  .height(0.5)
                  .color('#333')
                  .margin({ left: 76, right: 16 })
              }
            })
          }
          .padding({ top: 12 })
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}

@Builder
export function SearchBuilder(): void {
  SearchPage();
}