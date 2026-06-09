export interface SongItemData {
  id: string;
  name: string;
  author: string;
  img: string;
  src: string;
  tag?: string;
}

export class PlayStateData {
  playIndex: number = 0;
  playList: SongItemData[] = [];
  currentTime: number = 0;
  duration: number = 0;
  isPlaying: boolean = false;
  playMode: number = 0;
}