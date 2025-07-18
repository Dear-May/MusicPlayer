import {
  songItemType,
  recommendListType,
  recommendDailyType,
  favoriteListType,
  momentListType,
  paihangListType
} from '../models/Music'
import { TabClass } from '../models/Index'

// TabBar数据
export const tabsData: TabClass[] = [
  {
    title: '推荐',
    name: 'recommend',
    icon: $r("app.media.ic_recommend_gt"),
    iconLight: $r('app.media.ic_recommend_pt')
  }, {
  title: '漫游',
  name: 'roam',
  icon: $r('app.media.ic_roam_gt'),
  iconLight: $r('app.media.ic_roam_pt')
}, {
  title: '笔记',
  name: 'note',
  icon: $r('app.media.ic_note_gt'),
  iconLight: $r('app.media.ic_note_pt')
}, {
  title: '我的',
  name: 'mine',
  icon: $r('app.media.ic_mine_gt'),
  iconLight: $r('app.media.ic_mine_pt')
}]

// 每日推荐数据
export const dailyRecommend: recommendDailyType[] = [
  {
    img: 'resources/base/media/ic_img1.jpg',
    title: 'Music FM',
    type: '现在就听',
    song: 'Dream It Possible (Delacey)',
    bottom: 'rgba(0, 0, 0, 0.15)'
  },
  {
    img: 'resources/base/media/ic_img2.jpg',
    title: 'New',
    type: '新歌推荐',
    song: 'Dream It Possible (Delacey)',
    bottom: 'rgba(0, 0, 0, 0.15)'
  }
]

// 推荐歌单数据
export const recommendList: recommendListType[] = [
  {
    img: 'resources/base/media/ic_img3.jpg',
    title: '我在BGM中跳进了初夏的梦里',
    count: '257W'
  },
  {
    img: 'resources/base/media/ic_img4.jpg',
    title: '电波发送 | 叮！城市郊游指南',
    count: '257W'
  },
  {
    img: 'resources/base/media/ic_img5.jpg',
    title: '霓虹城市的合成器之音',
    count: '257W'
  }
]

// 歌曲列表
export const songs: songItemType[] = [
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0000'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0001'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0002'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0003'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0004'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0005'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0006'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0007'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0008'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0009'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0010'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0011'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0012'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0013'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0014'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0015'
  },
  {
    img: 'resources/base/media/cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0016'
  }
]

export const songsComment: songItemType[] = [
  {
    img: 'resources/base/media/ic_cover.png',
    name: 'Dream It Possible',
    author: 'Delacey',
    src: '',
    id: '0000'
  },
  {
    img: 'resources/base/media/ic_cover.png',
    name: 'xxxx',
    author: 'xxx',
    src: '',
    id: '0001'
  },
  {
    img: 'resources/base/media/ic_cover.png',
    name: 'xxxx',
    author: 'xxx',
    src: '',
    id: '0002'
  }
]

// 喜欢列表
export const favoriteList: favoriteListType = {
  name: '我喜欢的音乐',
  nickName: '小花',
  avatar: $r('app.media.logo'),
  songs: songs
}

// 动态列表
export const momentList: momentListType[] = [
  {
    author: '用户',
    avatar: 'resources/base/media/ic_user1.png',
    content: '花腔女高音 | 夜莺般的华彩炫技',
    comment: '个性签名',
    song: songsComment[0]
  },
  {
    author: '用户',
    avatar: 'resources/base/media/ic_user2.png',
    content: '花腔女高音 | 夜莺般的华彩炫技',
    comment: '个性签名',
    song: songsComment[1]
  },
  {
    author: '用户',
    avatar: 'resources/base/media/ic_user3.png',
    content: '花腔女高音 | 夜莺般的华彩炫技',
    comment: '个性签名',
    song: songsComment[2]
  }
]

//排行榜
export const paihangList: paihangListType[] = [
  {
    img: 'resources/base/media/ic_img1.jpg',
    title1: 'DIGIX',
    title2: '热歌榜',
    count: '105746万',
    song1: '歌曲1',
    author1: '歌手1',
    song2: '歌曲2',
    author2: '歌手2',
    song3: '歌曲3',
    author3: '歌手3'
  }, {
  img: 'resources/base/media/ic_img2.jpg',
  title1: 'DIGIX',
  title2: '热歌榜',
  count: '105746万',
  song1: '歌曲1',
  author1: '歌手1',
  song2: '歌曲2',
  author2: '歌手2',
  song3: '歌曲3',
  author3: '歌手3'
}, {
  img: 'resources/base/media/ic_img3.jpg',
  title1: 'DIGIX',
  title2: '热歌榜',
  count: '105746万',
  song1: '歌曲1',
  author1: '歌手1',
  song2: '歌曲2',
  author2: '歌手2',
  song3: '歌曲3',
  author3: '歌手3'
}, {
  img: 'resources/base/media/ic_img4.jpg',
  title1: 'DIGIX',
  title2: '热歌榜',
  count: '105746万',
  song1: '歌曲1',
  author1: '歌手1',
  song2: '歌曲2',
  author2: '歌手2',
  song3: '歌曲3',
  author3: '歌手3'
}, {
  img: 'resources/base/media/ic_img5.jpg',
  title1: 'DIGIX',
  title2: '热歌榜',
  count: '105746万',
  song1: '歌曲1',
  author1: '歌手1',
  song2: '歌曲2',
  author2: '歌手2',
  song3: '歌曲3',
  author3: '歌手3'
}
]
