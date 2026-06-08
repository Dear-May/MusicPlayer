import { Context } from '@kit.AbilityKit'
import { preferences } from '@kit.ArkData'
import { PlayStateType } from '../models/PlayState'

/**
 * 歌曲状态管理器 - 使用preferences持久化播放状态
 */
export default class SongManager {
  static context: Context

  private static readonly STORE_NAME: string = 'song_cache'
  private static readonly SONG_KEY: string = 'song_cache_key'

  static getStore() {
    try {
      return preferences.getPreferencesSync(SongManager.context, {
        name: SongManager.STORE_NAME
      });
    } catch (err) {
      console.error('SongManager getStore error:', JSON.stringify(err));
      return undefined;
    }
  }

  // 更新音乐播放状态
  static async updateSong(song: string) {
    try {
      const store = SongManager.getStore()
      store?.putSync(SongManager.SONG_KEY, song)
      await store?.flush()
    } catch (err) {
      console.error('SongManager updateSong error:', JSON.stringify(err))
    }
  }

  // 获取音乐播放状态
  static async getSong(): Promise<PlayStateType> {
    try {
      const store = SongManager.getStore()
      const result = store?.getSync(SongManager.SONG_KEY, JSON.stringify(new PlayStateType())) as string
      return result ? JSON.parse(result) as PlayStateType : new PlayStateType()
    } catch (err) {
      console.error('SongManager getSong error:', JSON.stringify(err))
      return new PlayStateType()
    }
  }
}
