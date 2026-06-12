import { recommendCardType, songItemType } from '../../models/Music';
import { recommendCardList, songs } from '../../constants/MusicConstants';
import { tryCloseSideBar, navigateToPage } from '../../utils/GlobalFunction';
import { BasicDataSource } from '../../utils/BasicDataSource';
import { CommonConstants } from '../../constants/CommonConstants';
import RecommendApi from '../../feature/recommend/RecommendApi';
import PlaylistApi from '../../feature/playlist/PlaylistApi';
import SongApi from '../../feature/playlist/SongApi';
import AudioPlayerManager from '../../feature/player/AudioPlayerManager';
import { BannerItem, SongItem, PlaylistItem, RecommendPlaylistItem } from '../../common/models/ApiTypes';

class RecommendCardDateSource extends BasicDataSource<recommendCardType> {
  private data: recommendCardType[] = [];

  constructor(initialData: recommendCardType[]) {
    super();
    this.data = initialData;
  }

  public totalCount(): number {
    return this.data.length;
  }

  getData(index: number): recommendCardType {
    return this.data[index];
  }
}

class SongDataSource extends BasicDataSource<songItemType[]> {
  private data: songItemType[][] = [];

  constructor(initialData: songItemType[][]) {
    super();
    this.data = initialData;
  }

  public totalCount(): number {
    return this.data.length;
  }

  getData(index: number): songItemType[] {
    return this.data[index];
  }
}

interface ContentBlock {
  type: 'cardGrid' | 'titleOnly' | 'songTag';
  title: string;
  tag?: string;
}

interface PlaylistPageParams {
  playlistId: number;
  playlistName: string;
  coverImg: string;
}

@Component
@Reusable
struct CardItem {
  @Prop card: recommendCardType
  @StorageLink('showSideBar') show: boolean = false;
  @State private isPlay: boolean = false;

  build() {
    Stack() {
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
            Image($r(!this.isPlay ? 'app.media.ic_play' : 'app.media.ic_paused'))
              .width(this.isPlay ? 16 : 20)
              .height(this.isPlay ? 16 : 20)
              .margin({ right: 16, bottom: 5 })
              .onClick(() => {
                tryCloseSideBar(this.getUIContext(), this.show, () => {
                  this.isPlay = !this.isPlay;
                });
              })
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

      Column() {
        Image(this.card.img)
          .width(120)
          .height(120)
          .borderRadius({ topLeft: 12, topRight: 12 })

        Column() {
          Text(this.card.subtitle)
            .fontSize(12)
            .fontColor($r('sys.color.white'))
        }
        .padding({
          top: 12,
          left: 6,
          right: 6,
          bottom: 12
        })
        .backgroundColor('#1d1d1f')
        .width(120)
        .height(40)
        .borderRadius({ bottomLeft: 12, bottomRight: 12 })
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

@Component
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
    .padding({ left: '23vp', right: 3 })
    .width('88%')
  }
}

@Preview
@Component
struct RecommendView {
  @State isRefreshing: boolean = false;
  @StorageLink('showSideBar') show: boolean = false;
  @State loadedBlockIndex: number = 0;
  @State private recommendCardDataSource: RecommendCardDateSource = new RecommendCardDateSource(recommendCardList);
  @State private songDataSource: SongDataSource = new SongDataSource(this.chunkSongs(songs, 3));
  // API 数据
  @State private banners: BannerItem[] = [];
  @State private personalizedPlaylists: RecommendPlaylistItem[] = [];
  @State private topSongs: SongItem[] = [];
  @State private dailySongs: SongItem[] = [];
  private audioManager: AudioPlayerManager = AudioPlayerManager.getInstance();

  aboutToAppear(): void {
    this.loadApiData();
  }

  private async loadApiData() {
    try {
      // 并行加载多个数据源
      const bannerPromise = RecommendApi.getBanners(1).catch((err: Error) => {
        console.error('load banners error:', JSON.stringify(err));
        return null;
      });
      const personalizedPromise = RecommendApi.getPersonalized(6).catch((err: Error) => {
        console.error('load personalized error:', JSON.stringify(err));
        return null;
      });
      const topSongsPromise = RecommendApi.getTopSongs(7).catch((err: Error) => {
        console.error('load top songs error:', JSON.stringify(err));
        return null;
      });
      const bannerRes = await bannerPromise;
      const personalizedRes = await personalizedPromise;
      const topSongsRes = await topSongsPromise;

      if (bannerRes?.banners) {
        this.banners = bannerRes.banners;
      }

      if (personalizedRes?.code === 200 && personalizedRes?.result) {
        this.personalizedPlaylists = personalizedRes.result.map((item: RecommendPlaylistItem) => {
          const playlistItem: RecommendPlaylistItem = {
            id: item.id,
            type: item.type,
            name: item.name,
            copywriter: item.copywriter,
            picUrl: item.picUrl,
            playCount: item.playCount,
            trackCount: item.trackCount
          };
          return playlistItem;
        });
      }

      if (topSongsRes?.code === 200 && topSongsRes?.data) {
        this.topSongs = topSongsRes.data as SongItem[];
      }

      // 尝试加载每日推荐（需登录）
      try {
        const dailyRes = await RecommendApi.getDailySongs();
        if (dailyRes?.code === 200 && dailyRes?.data?.dailySongs) {
          this.dailySongs = dailyRes.data.dailySongs;
        }
      } catch (_err) {
        // 未登录时忽略
      }

      console.info('RecommendView: API data loaded successfully');
    } catch (err) {
      console.error('RecommendView: loadApiData error', JSON.stringify(err));
    }
  }

  // 播放歌曲
  private async playSongById(songId: number, songName: string, artistNames: string, songImg: string = '') {
    try {
      const urlResult = await SongApi.getSongUrl(songId.toString(), 320000);
      if (urlResult.code === 200 && urlResult.data && urlResult.data.length > 0) {
        const songUrl = urlResult.data[0].url;
        if (songUrl && songUrl !== '') {
          await this.audioManager.initPlayer(songUrl, songName, artistNames, songImg);
        } else {
          console.error('RecommendView: 歌曲无播放地址，可能需要VIP');
        }
      }
    } catch (err) {
      console.error('RecommendView: play error', JSON.stringify(err));
    }
  }

  // 数据驱动的页面区块定义（减少重复代码）
  private contentBlocks: ContentBlock[][] = [
    [
      { type: 'cardGrid', title: '雷达歌单>' },
      { type: 'cardGrid', title: '排行榜>' },
      { type: 'cardGrid', title: 'XX最近的热门歌曲' },
    ],
    [
      { type: 'songTag', title: 'VIP专属好歌限时免费听>', tag: '免费听' },
      { type: 'cardGrid', title: '从你喜欢的歌曲开始漫游' },
      { type: 'cardGrid', title: 'XX的推荐歌单' },
    ],
    [
      { type: 'titleOnly', title: '为你精选的音乐播客>' },
      { type: 'titleOnly', title: '为你严选的精品有声书>' },
      { type: 'titleOnly', title: '为你推荐的热门节目>' },
    ],
    [
      { type: 'cardGrid', title: '从你喜欢的艺人开始漫游' },
      { type: 'cardGrid', title: '场景歌单' },
      { type: 'cardGrid', title: '你的专属推荐歌单' },
    ],
    [
      { type: 'titleOnly', title: '电音风暴 二创狂欢' },
      { type: 'titleOnly', title: '大家都爱听' },
      { type: 'cardGrid', title: '为你精选的原创歌曲' },
    ],
    [
      { type: 'cardGrid', title: '每周新热趋势' },
      { type: 'cardGrid', title: '广播' },
      { type: 'cardGrid', title: '影视原声' },
    ],
  ];

  private chunkSongs(data: songItemType[], size: number): songItemType[][] {
    let result: songItemType[][] = [];
    for (let i = 0; i < data.length; i += size) {
      result.push(data.slice(i, i + size));
    }
    return result;
  }

  private refresh() {
    this.isRefreshing = true;
    this.loadApiData();
    setTimeout(() => {
      this.isRefreshing = false;
      console.log('刷新完成');
    }, 2000);
  }

  @Builder
  cardList() {
    Scroll() {
      Row({ space: 12 }) {
        if (this.personalizedPlaylists.length > 0) {
          // 使用API推荐的歌单
          ForEach(this.personalizedPlaylists, (item: RecommendPlaylistItem) => {
            Column() {
              Image(item.picUrl)
                .width(120)
                .height(120)
                .borderRadius(12)
                .objectFit(ImageFit.Cover)
              Text(item.name)
                .fontSize(12)
                .fontColor(Color.White)
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width(120)
                .margin({ top: 4 })
            }
            .onClick(() => {
              tryCloseSideBar(this.getUIContext(), this.show, () => {
                const pageParams: PlaylistPageParams = {
                  playlistId: item.id,
                  playlistName: item.name,
                  coverImg: item.picUrl
                };
                navigateToPage(this.getUIContext(), 'pages/other/PlaylistDetailPage', pageParams);
              });
            })
          })
        } else {
          // 降级到本地数据
          LazyForEach(this.recommendCardDataSource, (card: recommendCardType) => {
            CardItem({ card: card })
          }, (card: recommendCardType) => card.title)
        }
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
      Row({ space: 12 }) {
        if (this.topSongs.length > 0) {
          // 使用API新歌列表
          ForEach(this.topSongs.slice(0, 6), (song: SongItem) => {
            Column({ space: 6 }) {
              Image(song.album?.picUrl)
                .width(120)
                .height(120)
                .borderRadius(12)
                .objectFit(ImageFit.Cover)
              Text(song.name)
                .fontSize(14)
                .fontColor(Color.White)
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width(120)
              Text(song.artists.map(a => a.name).join('/'))
                .fontSize(12)
                .fontColor('#888')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .width(120)
            }
            .onClick(() => {
              this.playSongById(song.id, song.name, song.artists.map(a => a.name).join('/'), song.album?.picUrl || '');
            })
          })
        } else {
          // 降级到本地数据
          LazyForEach(this.songDataSource, (group: songItemType[]) => {
            Column({ space: 0 }) {
              ForEach(group, (song: songItemType) => {
                SongCardItem({ song: song })
              })
            }
          })
        }
      }
      .padding({ left: 16 })
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

  @Builder
  headerRefresh() {
    Column() {
      LoadingProgress()
        .color(Color.White)
        .opacity(0.6)
        .width('36vp')
        .height('36vp')
    }
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  renderContentBlock(block: ContentBlock) {
    if (block.type === 'cardGrid') {
      Column() {
        this.TitleBar(block.title)
        this.cardList()
      }
    } else if (block.type === 'titleOnly') {
      Column() {
        Row() {
          Text(block.title)
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
    } else if (block.type === 'songTag') {
      Column() {
        Row() {
          Text(block.title)
            .fontSize(18)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
          Text(block.tag!)
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
    }
  }

  @Builder
  renderBlockGroup(groupIndex: number) {
    Column() {
      if (this.loadedBlockIndex > groupIndex) {
        ForEach(this.contentBlocks[groupIndex], (block: ContentBlock) => {
          this.renderContentBlock(block)
        })
      }
    }
    .onAppear(() => {
      if (this.loadedBlockIndex <= groupIndex) {
        this.loadedBlockIndex = groupIndex + 1;
      }
    })
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing, builder: this.headerRefresh() }) {
      Scroll() {
        Column() {
          // Banner轮播（从API加载）
          if (this.banners.length > 0) {
            Swiper() {
              ForEach(this.banners, (banner: BannerItem) => {
                Image(banner.pic)
                  .width('95%')
                  .aspectRatio(2.2)
                  .borderRadius(12)
                  .objectFit(ImageFit.Cover)
              })
            }
            .autoPlay(true)
            .interval(4000)
            .indicator(true)
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 8,
              bottom: 4
            })
          }

          // 每日推荐数据（需登录）
          if (this.dailySongs.length > 0) {
            Row() {
              Text('每日推荐')
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

          this.renderBlockGroup(0)
          this.renderBlockGroup(1)
          this.renderBlockGroup(2)
          this.renderBlockGroup(3)
          this.renderBlockGroup(4)
          this.renderBlockGroup(5)

          Blank()
            .height('20%')
        }
        .justifyContent(FlexAlign.Start)
      }
      .height('100%')
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
    }
    .refreshOffset(CommonConstants.REFRESH_OFFSET)
    .onRefreshing(() => {
      this.refresh();
    })
  }
}

export default RecommendView;
