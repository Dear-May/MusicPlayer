/**
 * 网易云音乐 API 响应类型定义
 */

/** 通用响应包装 */
export interface ApiResponse<T = object> {
  code: number;
  message?: string;
  data?: T;
  result?: object;
}

// ============ 登录相关 ============

export interface LoginResult {
  code: number;
  cookie: string;
  token: string;
  account: AccountInfo;
  profile: UserProfile;
  message?: string;
}

export interface AccountInfo {
  id: number;
  userName: string;
  type: number;
  status: number;
  whitelistAuthority: number;
  createTime: number;
  salt: string;
  tokenVersion: number;
  ban: number;
  baoyueVersion: number;
  donateVersion: number;
  vipType: number;
  viptypeVersion: number;
  anonimousUser: boolean;
}

export interface UserProfile {
  nickname: string;
  avatarUrl: string;
  userId: number;
  signature: string;
  backgroundUrl: string;
  gender: number;
  birthday: number;
  city: number;
  province: number;
  detailDescription: string;
  followed: boolean;
  following: boolean;
  followeds: number;
  follows: number;
  eventCount: number;
  playlistCount: number;
  playlistBeSubscribedCount: number;
  level?: number;
}

export interface LoginStatusResult {
  code: number;
  account: AccountInfo;
  profile: UserProfile;
}

// ============ 搜索相关 ============

export interface SearchResult {
  code: number;
  result: SearchResultData;
}

export interface SearchResultData {
  songs?: SongItem[];
  songCount?: number;
  albums?: object[];
  artists?: object[];
  playlists?: object[];
}

export interface SearchSuggestResult {
  code: number;
  result: SearchSuggestResultData;
}

export interface SearchSuggestResultData {
  songs?: SongItem[];
  albums?: object[];
  artists?: object[];
  playlists?: object[];
}

// ============ 歌曲相关 ============

export interface SongItem {
  id: number;
  name: string;
  artists: ArtistItem[];
  album: AlbumItem;
  duration: number;
  copyrightId: number;
  status: number;
  alias: string[];
  rtype: number;
  rurl: string;
  mvid?: number;
}

export interface ArtistItem {
  id: number;
  name: string;
  picUrl?: string;
  alias: string[];
  albumSize: number;
  picId: number;
  img1v1Url?: string;
  img1v1: number;
}

export interface AlbumItem {
  id: number;
  name: string;
  artist: ArtistItem;
  picUrl: string;
  publishTime: number;
  size: number;
  copyrightId: number;
  status: number;
}

export interface SongUrlResult {
  code: number;
  data: SongUrlData[];
}

export interface SongUrlData {
  id: number;
  url: string;
  br: number;
  size: number;
  md5: string;
  code: number;
  expi: number;
  type: string;
  gain: number;
  fee: number;
  payed: number;
  flag: number;
  canExtend: boolean;
  freeTrialInfo: object | null;
  level: string;
  encodeType: string;
  freeTrialPrivilege: FreeTrialPrivilege;
  freeTimeTrialPrivilege: FreeTimeTrialPrivilege;
  urlSource: number;
}

export interface FreeTrialPrivilege {
  resConsumable: boolean;
  userConsumable: boolean;
  listenType: number;
  cannotListenReason: number;
}

export interface FreeTimeTrialPrivilege {
  resConsumable: boolean;
  userConsumable: boolean;
  type: number;
  remainTime: number;
}

export interface LyricResult {
  code: number;
  lrc: LyricData;
  klyric: LyricData;
  tlyric: LyricData;
  romalrc: LyricData;
}

export interface LyricData {
  lyric: string;
  version: number;
}

// ============ 歌单相关 ============

export interface PlaylistDetailResult {
  code: number;
  playlist: PlaylistItem;
  privileges: object[];
}

export interface PlaylistItem {
  id: number;
  name: string;
  coverImgUrl: string;
  creator: UserProfile;
  trackCount: number;
  playCount: number;
  bookCount: number;
  subscribedCount: number;
  shareCount: number;
  commentCount: number;
  description: string;
  tags: string[];
  tracks: SongItem[];
  trackIds: TrackIdItem[];
  updateTime: number;
  createTime: number;
}

export interface TrackIdItem {
  id: number;
}

// ============ 推荐相关 ============

export interface BannerResult {
  code: number;
  banners: BannerItem[];
}

export interface BannerItem {
  pic: string;
  typeTitle: string;
  url: string;
  targetId: number;
  targetType: number;
  titleColor: string;
}

export interface RecommendPlaylistResult {
  code: number;
  result: RecommendPlaylistItem[];
}

export interface RecommendPlaylistItem {
  id: number;
  type: number;
  name: string;
  copywriter: string;
  picUrl: string;
  playCount: number;
  trackCount: number;
}

export interface RecommendSongsResult {
  code: number;
  data: RecommendSongsData;
}

export interface RecommendSongsData {
  dailySongs: SongItem[];
}

export interface TopPlaylistResult {
  code: number;
  playlists: TopPlaylistItem[];
  total: number;
}

export interface TopPlaylistItem {
  id: number;
  name: string;
  coverImgUrl: string;
  playCount: number;
  trackCount: number;
  creator: PlaylistCreator;
}

export interface PlaylistCreator {
  nickname: string;
}

// ============ 排行榜相关 ============

export interface ToplistDetailResult {
  code: number;
  list: ToplistItem[];
}

export interface ToplistItem {
  id: number;
  name: string;
  coverImgUrl: string;
  playCount: number;
  trackCount: number;
  updateFrequency: string;
}

// ============ 用户相关 ============

export interface UserDetailResult {
  code: number;
  profile: UserProfile;
  level: number;
  listenSongs: number;
}

export interface UserPlaylistResult {
  code: number;
  playlist: PlaylistItem[];
}

// ============ 评论相关 ============

export interface CommentResult {
  code: number;
  comments: CommentItem[];
  hotComments?: CommentItem[];
  total: number;
}

export interface CommentItem {
  user: UserProfile;
  content: string;
  time: number;
  timeStr: string;
  liked: boolean;
  likedCount: number;
  commentId: number;
}

// ============ 电台/DJ相关 ============

export interface DjRadioItem {
  id: number;
  name: string;
  picUrl: string;
  dj: DjRadioAnchor;
  programCount: number;
}

export interface DjRadioAnchor {
  nickname: string;
}

// ============ HTTP请求参数 ============

/** HTTP请求参数字段值类型 */
export type HttpParamValue = string | number | boolean;

/** HTTP请求参数对象 - 包含所有可能用到的查询参数 */
export interface HttpParams {
  id?: number;
  s?: number;
  limit?: number;
  offset?: number;
  cat?: string;
  before?: number;
  name?: string;
  privacy?: number;
  pid?: number;
  ids?: string;
  keywords?: string;
  type?: number | string;
  t?: number;
}
