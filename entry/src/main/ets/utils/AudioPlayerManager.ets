import media from '@ohos.multimedia.media';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 音频播放管理器 - 单例模式
 * 封装AVPlayer的完整生命周期管理
 */
export default class AudioPlayerManager {
  private static instance: AudioPlayerManager;
  private avPlayer: media.AVPlayer | null = null;
  private isPlay: boolean = false;
  private songName: string = '';
  private singerName: string = '';
  private songImg: string = '';
  private onStateChangeCallback: ((isPlaying: boolean, songName: string, singer: string, songImg: string) => void) | null = null;

  static getInstance(): AudioPlayerManager {
    if (!AudioPlayerManager.instance) {
      AudioPlayerManager.instance = new AudioPlayerManager();
    }
    return AudioPlayerManager.instance;
  }

  getSongImg(): string {
    return this.songImg;
  }

  setOnStateChange(callback: (isPlaying: boolean, songName: string, singer: string, songImg: string) => void): void {
    this.onStateChangeCallback = callback;
  }

  getIsPlay(): boolean {
    return this.isPlay;
  }

  getSongName(): string {
    return this.songName;
  }

  getSingerName(): string {
    return this.singerName;
  }

  async initPlayer(url: string, songName: string, singer: string, songImg: string = ''): Promise<void> {
    try {
      if (this.avPlayer) {
        await this.avPlayer.release();
        this.avPlayer = null;
      }

      this.songName = songName;
      this.singerName = singer;
      this.songImg = songImg;

      this.avPlayer = await media.createAVPlayer();
      this.setPlayerCallbacks();
      this.avPlayer.url = url;
    } catch (err) {
      console.error('AudioPlayerManager initPlayer error:', JSON.stringify(err));
    }
  }

  private setPlayerCallbacks(): void {
    if (!this.avPlayer) {
      return;
    }

    this.avPlayer.on('stateChange', (state: string) => {
      switch (state) {
        case 'initialized':
          this.avPlayer?.prepare().then(() => {
            console.info('AVPlayer prepare succeeded.');
          }).catch((err: BusinessError) => {
            console.error(`AVPlayer prepare failed: ${err.message}`);
          });
          break;
        case 'prepared':
          this.avPlayer?.play();
          break;
        case 'playing':
          this.isPlay = true;
          this.notifyStateChange();
          break;
        case 'paused':
          this.isPlay = false;
          this.notifyStateChange();
          break;
        case 'completed':
          this.avPlayer?.stop();
          break;
        case 'stopped':
          this.avPlayer?.reset();
          break;
        default:
          break;
      }
    });

    this.avPlayer.on('error', (err: BusinessError) => {
      console.error(`AVPlayer error: ${err.code}, ${err.message}`);
    });
  }

  private notifyStateChange(): void {
    if (this.onStateChangeCallback) {
      this.onStateChangeCallback(this.isPlay, this.songName, this.singerName, this.songImg);
    }
  }

  async play(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    try {
      await this.avPlayer.play();
      this.isPlay = true;
      this.notifyStateChange();
    } catch (err) {
      console.error('play error:', JSON.stringify(err));
    }
  }

  async pause(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    try {
      await this.avPlayer.pause();
      this.isPlay = false;
      this.notifyStateChange();
    } catch (err) {
      console.error('pause error:', JSON.stringify(err));
    }
  }

  async togglePlay(): Promise<void> {
    if (this.isPlay) {
      await this.pause();
    } else {
      await this.play();
    }
  }

  async stop(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    try {
      await this.avPlayer.stop();
      this.isPlay = false;
      this.notifyStateChange();
    } catch (err) {
      console.error('stop error:', JSON.stringify(err));
    }
  }

  async release(): Promise<void> {
    if (!this.avPlayer) {
      return;
    }
    try {
      await this.avPlayer.release();
      this.avPlayer = null;
      this.isPlay = false;
      this.songName = '';
      this.singerName = '';
      this.songImg = '';
    } catch (err) {
      console.error('release error:', JSON.stringify(err));
    }
  }
}
