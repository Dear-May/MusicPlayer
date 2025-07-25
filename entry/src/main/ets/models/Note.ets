import { songItemType } from ".";
import { userType } from "./User";

export interface NoteType {
  id: string;
  images: string [];
  Music: songItemType;
  subtitle: string;
  content: string;
  author: string;
  topic: string [];
  time: string;
  area: string;
  like: number;
  comment: number;
}

export interface CommentType {
  id: string;
  user: userType;
  content: string;
  time: string;
  area: string;
  like: number;
}