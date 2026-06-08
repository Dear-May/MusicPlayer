/**
 * 歌单相关 API
 */
import HttpManager from './HttpManager';
import {
  ApiResponse,
  PlaylistDetailResult,
  TopPlaylistResult,
  PlaylistItem,
  HttpParams
} from './ApiTypes';

const http = HttpManager.getInstance();

export default class PlaylistApi {
  /**
   * 4.1 歌单详情
   */
  static async getDetail(id: number, s: number = 8): Promise<PlaylistDetailResult> {
    const params: HttpParams = {
      id: id,
      s: s
    };
    return await http.get<PlaylistDetailResult>('/playlist/detail', params);
  }

  /**
   * 4.2 歌单内全部歌曲
   */
  static async getAllTracks(id: number, limit: number = 1000, offset: number = 0): Promise<ApiResponse> {
    const params: HttpParams = {
      id: id,
      limit: limit,
      offset: offset
    };
    return await http.get<ApiResponse>('/playlist/track/all', params);
  }

  /**
   * 4.3 歌单动态信息
   */
  static async getDynamic(id: number): Promise<ApiResponse> {
    const params: HttpParams = {
      id: id
    };
    return await http.get<ApiResponse>('/playlist/detail/dynamic', params);
  }

  /**
   * 4.4 收藏/取消收藏歌单
   */
  static async subscribe(id: number, t: number): Promise<ApiResponse> {
    const params: HttpParams = {
      id: id,
      t: t
    };
    return await http.get<ApiResponse>('/playlist/subscribe', params);
  }

  /**
   * 4.6 热门歌单
   */
  static async getTopPlaylist(cat: string = '全部', limit: number = 50, offset: number = 0): Promise<TopPlaylistResult> {
    const params: HttpParams = {
      cat: cat,
      limit: limit,
      offset: offset
    };
    return await http.get<TopPlaylistResult>('/top/playlist', params);
  }

  /**
   * 4.7 精品歌单
   */
  static async getHighQuality(cat: string = '全部', limit: number = 50, before?: number): Promise<ApiResponse> {
    if (before !== undefined) {
      const params: HttpParams = {
        cat: cat,
        limit: limit,
        before: before
      };
      return await http.get<ApiResponse>('/top/playlist/highquality', params);
    } else {
      const params: HttpParams = {
        cat: cat,
        limit: limit
      };
      return await http.get<ApiResponse>('/top/playlist/highquality', params);
    }
  }

  /**
   * 4.8 创建歌单
   */
  static async create(name: string, privacy: number = 0): Promise<ApiResponse> {
    const params: HttpParams = {
      name: name,
      privacy: privacy
    };
    return await http.get<ApiResponse>('/playlist/create', params);
  }

  /**
   * 4.9 歌单添加歌曲
   */
  static async addTrack(pid: number, ids: string): Promise<ApiResponse> {
    const params: HttpParams = {
      pid: pid,
      ids: ids
    };
    return await http.get<ApiResponse>('/playlist/track/add', params);
  }

  /**
   * 4.10 歌单删除歌曲
   */
  static async deleteTrack(pid: number, ids: string): Promise<ApiResponse> {
    const params: HttpParams = {
      id: pid,
      ids: ids
    };
    return await http.get<ApiResponse>('/playlist/track/delete', params);
  }

  /**
   * 4.11 删除歌单
   */
  static async delete(id: number): Promise<ApiResponse> {
    const params: HttpParams = {
      id: id
    };
    return await http.get<ApiResponse>('/playlist/delete', params);
  }
}
