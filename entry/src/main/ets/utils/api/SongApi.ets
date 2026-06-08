/**
 * 歌曲相关 API
 */
import HttpManager from './HttpManager';
import {
  ApiResponse,
  SongUrlResult,
  LyricResult,
  SongItem
} from './ApiTypes';

export interface SongDetailData {
  songs: SongItem[];
}

export interface SimiSongData {
  songs: SongItem[];
}

interface IdsParam {
  ids: string;
}

interface IdBrParam {
  id: string;
  br: number;
}

interface IdParam {
  id: number;
}

interface IdLikeParam {
  id: number;
  like: boolean;
}

interface IdLimitParam {
  id: number;
  limit: number;
}

const http = HttpManager.getInstance();

export default class SongApi {
  /**
   * 3.1 歌曲详情
   */
  static async getSongDetail(ids: string): Promise<ApiResponse<SongDetailData>> {
    const params: IdsParam = {
      ids: ids
    };
    return await http.get<ApiResponse<SongDetailData>>('/song/detail', params);
  }

  /**
   * 3.2 歌曲播放地址
   * @param id 歌曲ID，多个用逗号分隔
   * @param br 码率: 999000(无损) 320000 192000 128000
   */
  static async getSongUrl(id: string, br: number = 320000): Promise<SongUrlResult> {
    const params: IdBrParam = {
      id: id,
      br: br
    };
    return await http.get<SongUrlResult>('/song/url', params);
  }

  /**
   * 3.3 歌曲歌词
   */
  static async getLyric(id: number): Promise<LyricResult> {
    const params: IdParam = {
      id: id
    };
    return await http.get<LyricResult>('/lyric', params);
  }

  /**
   * 3.5 检查歌曲可用性
   */
  static async checkMusic(id: number): Promise<ApiResponse> {
    const params: IdParam = {
      id: id
    };
    return await http.get<ApiResponse>('/check/music', params);
  }

  /**
   * 3.6 点赞/取消点赞歌曲
   */
  static async likeSong(id: number, like: boolean = true): Promise<ApiResponse> {
    const params: IdLikeParam = {
      id: id,
      like: like
    };
    return await http.get<ApiResponse>('/like', params);
  }

  /**
   * 3.8 相似歌曲
   */
  static async getSimiSong(id: number, limit: number = 50): Promise<ApiResponse<SimiSongData>> {
    const params: IdLimitParam = {
      id: id,
      limit: limit
    };
    return await http.get<ApiResponse<SimiSongData>>('/simi/song', params);
  }
}
