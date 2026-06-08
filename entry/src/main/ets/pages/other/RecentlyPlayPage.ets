import { songs } from '../../constants/MusicConstants';
import { songItemType } from '../../models/Music';
import SongApi from '../../utils/api/SongApi';
import RecommendApi from '../../utils/api/RecommendApi';
import { SongItem } from '../../utils/api/ApiTypes';
import AudioPlayerManager from '../../utils/AudioPlayerManager';

@Entry
@Component
struct RecentlyPlayPage {
  @State private apiSongs: SongItem[] = [];
  @State private isLoading: boolean = false;
  private audioManager: AudioPlayerManager = AudioPlayerManager.getInstance();

  aboutToAppear(): void {
    this.loadRecentSongs();
  }

  private async loadRecentSongs() {
    this.isLoading = true;
    try {
      const result = await RecommendApi.getTopSongs(0);
      if (result.code === 200 && result.data) {
        this.apiSongs = result.data as SongItem[];
      }
    } catch (err) {
      console.error('RecentlyPlayPage load error:', JSON.stringify(err));
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
      console.error('RecentlyPlayPage play error:', JSON.stringify(err));
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.menu'))
          .width(24)
          .height(24)
          .rotate({ angle: 90 })
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
        Text('新歌速递')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      if (this.isLoading) {
        Column() {
          LoadingProgress().color(Color.White).width(36).height(36)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            if (this.apiSongs.length > 0) {
              ForEach(this.apiSongs, (item: SongItem) => {
                Row() {
                  Image(item.album?.picUrl)
                    .width(50)
                    .height(50)
                    .borderRadius(6)
                    .objectFit(ImageFit.Cover)
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
                  .margin({ left: 12 })
                  .layoutWeight(1)
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
                .onClick(() => this.playSong(item))
              })
            } else {
              // 降级到本地数据
              ForEach(songs, (item: songItemType) => {
                Row() {
                  Image($r('app.media.record'))
                    .width(50)
                    .height(50)
                    .borderRadius(6)
                  Column({ space: 4 }) {
                    Text(item.name)
                      .fontSize(16)
                      .fontColor(Color.White)
                      .fontWeight(FontWeight.Medium)
                    Text(item.author)
                      .fontSize(12)
                      .fontColor('#888')
                  }
                  .margin({ left: 12 })
                  .layoutWeight(1)
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 8, bottom: 8 })
              })
            }
          }
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
export function RecentlyPlayBuilder(): void {
  RecentlyPlayPage();
}
