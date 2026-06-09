/**
 * Playlist API
 * @layer feature/playlist
 */
import HttpManager from '../../common/network/HttpManager';
import {
  ApiResponse,
  PlaylistDetailResult,
  TopPlaylistResult
} from '../../common/models/ApiTypes';

const http: HttpManager = HttpManager.getInstance();

export default class PlaylistApi {
  static async getDetail(id: number, s: number = 8): Promise<PlaylistDetailResult> {
    interface IdSParam {
      id: number;
      s: number;
    }
    const params: IdSParam = { id: id, s: s };
    return await http.get<PlaylistDetailResult>('/playlist/detail', params);
  }

  static async getAllTracks(id: number, limit: number = 1000, offset: number = 0): Promise<ApiResponse> {
    interface TrackAllParam {
      id: number;
      limit: number;
      offset: number;
    }
    const params: TrackAllParam = { id: id, limit: limit, offset: offset };
    return await http.get<ApiResponse>('/playlist/track/all', params);
  }

  static async getDynamic(id: number): Promise<ApiResponse> {
    interface IdParam {
      id: number;
    }
    const params: IdParam = { id: id };
    return await http.get<ApiResponse>('/playlist/detail/dynamic', params);
  }

  static async subscribe(id: number, t: number): Promise<ApiResponse> {
    interface IdTParam {
      id: number;
      t: number;
    }
    const params: IdTParam = { id: id, t: t };
    return await http.get<ApiResponse>('/playlist/subscribe', params);
  }

  static async getTopPlaylist(cat: string = '全部', limit: number = 50, offset: number = 0): Promise<TopPlaylistResult> {
    interface CatLimitOffsetParam {
      cat: string;
      limit: number;
      offset: number;
    }
    const params: CatLimitOffsetParam = { cat: cat, limit: limit, offset: offset };
    return await http.get<TopPlaylistResult>('/top/playlist', params);
  }

  static async getHighQuality(cat: string = '全部', limit: number = 50, before?: number): Promise<ApiResponse> {
    interface HighQualityParam {
      cat: string;
      limit: number;
      before?: number;
    }
    const params: HighQualityParam = { cat: cat, limit: limit };
    if (before !== undefined) {
      params.before = before;
    }
    return await http.get<ApiResponse>('/top/playlist/highquality', params);
  }

  static async create(name: string, privacy: number = 0): Promise<ApiResponse> {
    interface CreateParam {
      name: string;
      privacy: number;
    }
    const params: CreateParam = { name: name, privacy: privacy };
    return await http.get<ApiResponse>('/playlist/create', params);
  }

  static async addTrack(pid: number, ids: string): Promise<ApiResponse> {
    interface AddTrackParam {
      pid: number;
      ids: string;
    }
    const params: AddTrackParam = { pid: pid, ids: ids };
    return await http.get<ApiResponse>('/playlist/track/add', params);
  }

  static async deleteTrack(pid: number, ids: string): Promise<ApiResponse> {
    interface DelTrackParam {
      id: number;
      ids: string;
    }
    const params: DelTrackParam = { id: pid, ids: ids };
    return await http.get<ApiResponse>('/playlist/track/delete', params);
  }

  static async delete(id: number): Promise<ApiResponse> {
    interface IdParam {
      id: number;
    }
    const params: IdParam = { id: id };
    return await http.get<ApiResponse>('/playlist/delete', params);
  }
}
