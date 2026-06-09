/**
 * Audio Player Manager - Singleton
 * @layer feature/player
 * Wraps AVPlayer lifecycle.
 * Supports play/pause/seek/prev/next/mode/playlist/progress callback.
 */
import media from '@ohos.multimedia.media';
import { BusinessError } from '@kit.BasicServicesKit';

export enum PlayMode {
  LIST_LOOP = 0,
  SINGLE_LOOP = 1,
  SHUFFLE = 2,
}

export interface PlaylistItemData {
  id: string;
  name: string;
  author: string;
  img: string;
  src: string;
}

export interface PlayerStateCallback {
  onPlayStateChange: (isPlaying: boolean) => void;
  onProgress: (currentTime: number, duration: number) => void;
  onSongChange: (songName: string, singer: string, songImg: string) => void;
  onError: (code: number, message: string) => void;
}

export default class AudioPlayerManager {
  private static instance: AudioPlayerManager;
  private avPlayer: media.AVPlayer | null = null;
  private isPlayState: boolean = false;
  private currentTime: number = 0;
  private totalDuration: number = 0;
  private playMode: PlayMode = PlayMode.LIST_LOOP;
  private currentSong: PlaylistItemData | null = null;
  private playList: PlaylistItemData[] = [];
  private callback: PlayerStateCallback | null = null;
  private timeInterval: number | null = null;

  static getInstance(): AudioPlayerManager {
    if (!AudioPlayerManager.instance) {
      AudioPlayerManager.instance = new AudioPlayerManager();
    }
    return AudioPlayerManager.instance;
  }

  getIsPlaying(): boolean {
    return this.isPlayState;
  }

  getCurrentTime(): number {
    return this.currentTime;
  }

  getDuration(): number {
    return this.totalDuration;
  }

  getPlayMode(): PlayMode {
    return this.playMode;
  }

  getPlaylist(): PlaylistItemData[] {
    return this.playList;
  }

  getCurrentSong(): PlaylistItemData | null {
    return this.currentSong;
  }

  setCallback(cb: PlayerStateCallback): void {
    this.callback = cb;
  }

  clearCallback(): void {
    this.callback = null;
  }

  async playSong(song: PlaylistItemData): Promise<void> {
    if (!song.src) {
      this.callback?.onError(-1, 'Empty song URL');
      return;
    }
    try {
      await this.releasePlayer();
      this.currentSong = song;
      this.avPlayer = await media.createAVPlayer();
      this.setupCallbacks();
      this.avPlayer.url = song.src;
      this.callback?.onSongChange(song.name, song.author, song.img);
    } catch (err) {
      console.error('playSong error:', JSON.stringify(err));
      this.callback?.onError(-1, 'Play failed');
    }
  }

  async togglePlay(): Promise<void> {
    if (this.isPlayState) {
      await this.pausePlay();
    } else {
      await this.resumePlay();
    }
  }

  async pausePlay(): Promise<void> {
    try {
      await this.avPlayer?.pause();
    } catch (err) {
      console.error('pause error:', JSON.stringify(err));
    }
  }

  async resumePlay(): Promise<void> {
    try {
      await this.avPlayer?.play();
    } catch (err) {
      console.error('resume error:', JSON.stringify(err));
    }
  }

  async stopPlay(): Promise<void> {
    try {
      this.stopTimeUpdate();
      await this.avPlayer?.stop();
      this.isPlayState = false;
      this.currentTime = 0;
    } catch (err) {
      console.error('stop error:', JSON.stringify(err));
    }
  }

  async seekTo(timeMs: number): Promise<void> {
    try {
      await this.avPlayer?.seek(timeMs);
      this.currentTime = Math.floor(timeMs / 1000);
    } catch (err) {
      console.error('seekTo error:', JSON.stringify(err));
    }
  }

  cyclePlayMode(): PlayMode {
    this.playMode = (this.playMode + 1) % 3;
    return this.playMode;
  }

  setPlaylist(list: PlaylistItemData[]): void {
    this.playList = list;
  }

  addToPlaylist(song: PlaylistItemData): void {
    this.playList.push(song);
  }

  removeFromPlaylist(index: number): void {
    if (index >= 0 && index < this.playList.length) {
      this.playList.splice(index, 1);
    }
  }

  clearPlaylist(): void {
    this.playList = [];
  }

  async playPrevious(): Promise<void> {
    if (this.playList.length === 0) {
      return;
    }
    let idx = this.playList.findIndex(s => s.id === this.currentSong?.id);
    if (idx <= 0) {
      idx = this.playList.length - 1;
    } else {
      idx--;
    }
    await this.playSong(this.playList[idx]);
  }

  async playNext(): Promise<void> {
    if (this.playList.length === 0) {
      return;
    }
    let idx = this.playList.findIndex(s => s.id === this.currentSong?.id);
    if (this.playMode === PlayMode.SHUFFLE) {
      idx = Math.floor(Math.random() * this.playList.length);
    } else {
      idx = (idx + 1) % this.playList.length;
    }
    await this.playSong(this.playList[idx]);
  }

  private setupCallbacks(): void {
    if (!this.avPlayer) {
      return;
    }
    this.avPlayer.on('stateChange', (state: string) => {
      switch (state) {
        case 'initialized':
          this.avPlayer?.prepare().catch((err: BusinessError) => {
            console.error('prepare failed: ' + err.message);
          });
          break;
        case 'prepared':
          this.totalDuration = (this.avPlayer?.duration ?? 0) / 1000;
          this.avPlayer?.play();
          break;
        case 'playing':
          this.isPlayState = true;
          this.startTimeUpdate();
          this.callback?.onPlayStateChange(true);
          break;
        case 'paused':
          this.isPlayState = false;
          this.callback?.onPlayStateChange(false);
          break;
        case 'completed':
          this.playNext();
          break;
        case 'stopped':
          this.stopTimeUpdate();
          break;
        default:
          break;
      }
    });
    this.avPlayer.on('error', (err: BusinessError) => {
      console.error('AVPlayer error: ' + err.code + ' ' + err.message);
      this.callback?.onError(err.code, err.message);
    });
  }

  private startTimeUpdate(): void {
    this.stopTimeUpdate();
    this.timeInterval = setInterval(() => {
      if (this.avPlayer) {
        this.currentTime = Math.floor((this.avPlayer.currentTime ?? 0) / 1000);
        this.callback?.onProgress(this.currentTime, this.totalDuration);
      }
    }, 500);
  }

  private stopTimeUpdate(): void {
    if (this.timeInterval !== null) {
      clearInterval(this.timeInterval);
      this.timeInterval = null;
    }
  }

  private async releasePlayer(): Promise<void> {
    try {
      this.stopTimeUpdate();
      if (this.avPlayer) {
        await this.avPlayer.release();
        this.avPlayer = null;
      }
    } catch (err) {
      console.error('releasePlayer error:', JSON.stringify(err));
    }
  }

  // ========== Backward Compat Methods ==========

  setOnStateChange(callback: (isPlaying: boolean, song: string, singer: string, img: string) => void): void {
    const cb: PlayerStateCallback = {
      onPlayStateChange: (playing: boolean): void => {
        callback(playing, '', '', '');
      },
      onSongChange: (name: string, singer: string, img: string): void => {
        callback(this.isPlayState, name, singer, img);
      },
      onProgress: (_currentTime: number, _duration: number): void => {},
      onError: (_code: number, _message: string): void => {}
    };
    this.callback = cb;
  }

  getIsPlay(): boolean {
    return this.isPlayState;
  }

  getSongName(): string {
    return this.currentSong?.name ?? '';
  }

  getSingerName(): string {
    return this.currentSong?.author ?? '';
  }

  getSongImg(): string {
    return this.currentSong?.img ?? '';
  }

  async initPlayer(url: string, name: string, singer: string, img: string): Promise<void> {
    await this.playSong({ id: '', name: name, author: singer, img: img, src: url });
  }

  async play(): Promise<void> {
    await this.resumePlay();
  }

  async pause(): Promise<void> {
    await this.pausePlay();
  }

  async stop(): Promise<void> {
    await this.stopPlay();
  }
}
