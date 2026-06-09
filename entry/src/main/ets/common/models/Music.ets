import { SongItemData } from './PlayState';

export interface RecommendCardData {
  icon?: Resource;
  title: string;
  subtitle: string;
  tag?: string;
  img: ResourceStr;
  canPlay?: boolean;
  isPlay?: boolean;
}

export interface RecommendListData {
  img: string;
  title: string;
  count: string;
}

export interface FavoriteListData {
  name: string;
  nickName: string;
  avatar: ResourceStr;
  songs: SongItemData[];
}

export interface MomentItemData {
  author: string;
  avatar: string;
  content: string;
  comment: string;
  song: SongItemData;
}

export interface RankingListData {
  img: string;
  title1: string;
  title2: string;
  count: string;
  song1: string;
  author1: string;
  song2: string;
  author2: string;
  song3: string;
  author3: string;
}

export interface TabClassData {
  title: string;
  name: string;
  icon: ResourceStr;
  iconLight: ResourceStr;
}