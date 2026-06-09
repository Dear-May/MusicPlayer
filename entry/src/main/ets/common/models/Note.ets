import { SongItemData } from './PlayState';
import { UserSimpleData } from './User';

export interface NoteItemData {
  id: string;
  images: string[];
  music: SongItemData;
  content: string;
  author: string;
  time: string;
  like: number;
  comment: number;
}

export interface CommentItemData {
  id: string;
  user: UserSimpleData;
  content: string;
  time: string;
  like: number;
}