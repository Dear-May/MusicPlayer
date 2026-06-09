export interface ApiResponse<T = object> {
  code: number;
  message?: string;
  data?: T;
  result?: object;
}

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
  vipType: number;
}

export interface UserProfile {
  nickname: string;
  avatarUrl: string;
  userId: number;
  signature: string;
  gender: number;
  level?: number;
  vipType: number;
}

export interface SongItem {
  id: number;
  name: string;
  artists: ArtistItem[];
  album: AlbumItem;
  duration: number;
  mvid?: number;
}

export interface ArtistItem {
  id: number;
  name: string;
  picUrl?: string;
}

export interface AlbumItem {
  id: number;
  name: string;
  artist: ArtistItem;
  picUrl: string;
}

export interface SongUrlResult {
  code: number;
  data: SongUrlData[];
}

export interface SongUrlData {
  id: number;
  url: string;
  br: number;
  level: string;
}

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
  description: string;
  tags: string[];
  tracks: SongItem[];
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
  creator: PlaylistCreator;
}

export interface RecommendSongsResult {
  code: number;
  data: RecommendSongsData;
}

export interface RecommendPlaylistResult {
  code: number;
  result: RecommendPlaylistItem[];
}

export interface RecommendPlaylistItem {
  id: number;
  name: string;
  picUrl: string;
  playCount: number;
}

export interface BannerResult {
  code: number;
  banners: BannerItem[];
}

export interface BannerItem {
  pic: string;
  typeTitle: string;
  url: string;
  targetId: number;
}

export interface SearchSuggestResult {
  code: number;
  result: SearchSuggestResultData;
}

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
  liked: boolean;
  likedCount: number;
  commentId: number;
}

export interface DjRadioItem {
  id: number;
  name: string;
  picUrl: string;
  dj: DjRadioAnchor;
  programCount: number;
}

export interface LoginStatusResult {
  code: number;
  account: AccountInfo;
  profile: UserProfile;
}

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

export interface SearchSuggestResultData {
  songs?: SongItem[];
  albums?: object[];
  artists?: object[];
  playlists?: object[];
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

export interface TrackIdItem {
  id: number;
}

export interface RecommendSongsData {
  dailySongs: SongItem[];
}

export interface PlaylistCreator {
  nickname: string;
}

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

export interface DjRadioAnchor {
  nickname: string;
}
