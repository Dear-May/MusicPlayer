import { songs } from '../../constants/MusicConstants';
import { songItemType } from '../../models/Music';
import RecommendApi from '../../utils/api/RecommendApi';
import SongApi from '../../utils/api/SongApi';
import { SongItem } from '../../utils/api/ApiTypes';
import AudioPlayerManager from '../../utils/AudioPlayerManager';

@Component
struct Music {
  @State private musicSongs: songItemType[] = songs;
  @State private apiSongs: SongItem[] = [];
  @State private isLoading: boolean = false;
  private audioManager: AudioPlayerManager = AudioPlayerManager.getInstance();

  aboutToAppear(): void {
    this.loadSongs();
  }

  private async loadSongs() {
    this.isLoading = true;
    try {
      const result = await RecommendApi.getTopSongs(7);
      if (result.code === 200 && result.data) {
        this.apiSongs = result.data as SongItem[];
      }
    } catch (err) {
      console.error('Music load songs error:', JSON.stringify(err));
    } finally {
      this.isLoading = false;
    }
  }

  private async playSong(song: SongItem) {
    try {
      const urlResult = await SongApi.getSongUrl(song.id.toString(), 320000);
      if (urlResult.code === 200 && urlResult.data && urlResult.data.length > 0) {
        const songUrl = urlResult.data[0].url;
        if (songUrl && songUrl !== '') {
          const artistNames = song.artists.map(a => a.name).join('/');
          await this.audioManager.initPlayer(songUrl, song.name, artistNames, song.album?.picUrl || '');
        }
      }
    } catch (err) {
      console.error('Music play error:', JSON.stringify(err));
    }
  }

  build() {
    Column() {
      // 标题
      Row() {
        Text('热门推荐')
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
        // 歌曲列表
        Scroll() {
          Column() {
            if (this.apiSongs.length > 0) {
              ForEach(this.apiSongs.slice(0, 20), (item: SongItem, index: number) => {
                Row() {
                  Text((index + 1).toString())
                    .fontSize(14)
                    .fontColor('#666')
                    .width(30)
                  Column({ space: 4 }) {
                    Text(item.name)
                      .fontSize(16)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Text(item.artists.map(a => a.name).join('/'))
                      .fontSize(12)
                      .fontColor('#888')
                  }
                  .layoutWeight(1)
                  .margin({ left: 12 })

                  Image($r('app.media.ic_play'))
                    .width(24)
                    .height(24)
                    .onClick(() => this.playSong(item))
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .onClick(() => this.playSong(item))
              })
            } else {
              // 降级：使用本地数据
              ForEach(this.musicSongs, (item: songItemType, index: number) => {
                Row() {
                  Text((index + 1).toString())
                    .fontSize(14)
                    .fontColor('#666')
                    .width(30)
                  Column({ space: 4 }) {
                    Text(item.name)
                      .fontSize(16)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                    Text(item.author)
                      .fontSize(12)
                      .fontColor('#888')
                  }
                  .layoutWeight(1)
                  .margin({ left: 12 })

                  Image($r('app.media.ic_play'))
                    .width(24)
                    .height(24)
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .onClick(() => {
                  console.log('点击歌曲: ' + item.name);
                })
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

export default Music;
