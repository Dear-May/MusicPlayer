/**
 * Song API
 * @layer feature/playlist
 */
import HttpManager from '../../common/network/HttpManager';
import {
  ApiResponse,
  SongUrlResult,
  SongItem,
  LyricResult
} from '../../common/models/ApiTypes';

const http: HttpManager = HttpManager.getInstance();

export interface SongDetailData {
  songs: SongItem[];
}

export interface SimiSongData {
  songs: SongItem[];
}

export default class SongApi {
  static async getSongDetail(ids: string): Promise<ApiResponse<SongDetailData>> {
    interface IdsParam {
      ids: string;
    }
    const params: IdsParam = { ids: ids };
    return await http.get<ApiResponse<SongDetailData>>('/song/detail', params);
  }

  static async getSongUrl(id: string, br: number = 320000): Promise<SongUrlResult> {
    interface IdBrParam {
      id: string;
      br: number;
    }
    const params: IdBrParam = { id: id, br: br };
    return await http.get<SongUrlResult>('/song/url', params);
  }

  static async getLyric(id: number): Promise<LyricResult> {
    interface IdParam {
      id: number;
    }
    const params: IdParam = { id: id };
    return await http.get<LyricResult>('/lyric', params);
  }

  static async checkMusic(id: number): Promise<ApiResponse> {
    interface IdParam {
      id: number;
    }
    const params: IdParam = { id: id };
    return await http.get<ApiResponse>('/check/music', params);
  }

  static async likeSong(id: number, like: boolean = true): Promise<ApiResponse> {
    interface IdLikeParam {
      id: number;
      like: boolean;
    }
    const params: IdLikeParam = { id: id, like: like };
    return await http.get<ApiResponse>('/like', params);
  }

  static async getSimiSong(id: number, limit: number = 50): Promise<ApiResponse<SimiSongData>> {
    interface IdLimitParam {
      id: number;
      limit: number;
    }
    const params: IdLimitParam = { id: id, limit: limit };
    return await http.get<ApiResponse<SimiSongData>>('/simi/song', params);
  }
}
