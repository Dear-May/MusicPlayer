import { SongItem } from '../../utils/api/ApiTypes';
import PlaylistApi from '../../utils/api/PlaylistApi';
import SongApi from '../../utils/api/SongApi';
import AudioPlayerManager from '../../utils/AudioPlayerManager';

@Entry
@Component
struct PlaylistDetailPage {
  private playlistId: number = 0;
  private playlistName: string = '';
  @State private tracks: SongItem[] = [];
  @State private isLoading: boolean = true;
  @State private coverImg: string = '';
  private audioManager: AudioPlayerManager = AudioPlayerManager.getInstance();

  aboutToAppear(): void {
    const params = this.getUIContext().getRouter().getParams();
    if (params) {
      const id = Reflect.get(params, 'playlistId');
      const name = Reflect.get(params, 'playlistName');
      const cover = Reflect.get(params, 'coverImg');
      if (id !== undefined) this.playlistId = id as number;
      if (name !== undefined) this.playlistName = name as string;
      if (cover !== undefined) this.coverImg = cover as string;
    }
    this.loadPlaylistTracks();
  }

  private async loadPlaylistTracks() {
    this.isLoading = true;
    try {
      const result = await PlaylistApi.getDetail(this.playlistId, 20);
      if (result.code === 200 && result.playlist) {
        this.tracks = result.playlist.tracks || [];
        this.coverImg = this.coverImg || result.playlist.coverImgUrl;
        this.playlistName = this.playlistName || result.playlist.name;
      }
    } catch (err: any) {
      console.error('PlaylistDetailPage load error:', JSON.stringify(err));
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
    } catch (err: any) {
      console.error('PlaylistDetailPage play error:', JSON.stringify(err));
    }
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Image($r('app.media.menu'))
          .width(24)
          .height(24)
          .rotate({ angle: 90 })
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })
        Text(this.playlistName || '歌单详情')
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 12 })
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .padding({ left: 16, top: 40, bottom: 10 })

      if (this.isLoading) {
        Column() {
          LoadingProgress().color(Color.White).width(36).height(36)
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else if (this.tracks.length > 0) {
        Scroll() {
          Column() {
            ForEach(this.tracks, (item: SongItem, index: number) => {
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
          }
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
      } else {
        Column() {
          Text('暂无歌曲数据')
            .fontSize(14)
            .fontColor('#666')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#0e0d11')
  }
}
