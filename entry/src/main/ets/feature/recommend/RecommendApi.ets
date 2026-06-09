/**
 * Recommend API
 * @layer feature/recommend
 */
import HttpManager from '../../common/network/HttpManager';
import {
  ApiResponse,
  BannerResult,
  RecommendPlaylistResult,
  RecommendSongsResult,
  ToplistDetailResult
} from '../../common/models/ApiTypes';

const http: HttpManager = HttpManager.getInstance();

export default class RecommendApi {
  static async getBanners(type: number = 1): Promise<BannerResult> {
    interface TypeParam {
      type: number;
    }
    const params: TypeParam = { type: type };
    return await http.get<BannerResult>('/banner', params);
  }

  static async getDailySongs(): Promise<RecommendSongsResult> {
    return await http.get<RecommendSongsResult>('/recommend/songs');
  }

  static async getDailyPlaylists(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/recommend/resource');
  }

  static async getPersonalized(limit: number = 30, offset: number = 0): Promise<RecommendPlaylistResult> {
    interface LimitOffsetParam {
      limit: number;
      offset: number;
    }
    const params: LimitOffsetParam = { limit: limit, offset: offset };
    return await http.get<RecommendPlaylistResult>('/personalized', params);
  }

  static async getNewSong(limit: number = 30): Promise<ApiResponse> {
    interface LimitParam {
      limit: number;
    }
    const params: LimitParam = { limit: limit };
    return await http.get<ApiResponse>('/personalized/newsong', params);
  }

  static async getToplistDetail(): Promise<ToplistDetailResult> {
    return await http.get<ToplistDetailResult>('/toplist/detail');
  }

  static async getTopSongs(type: number = 0): Promise<ApiResponse> {
    interface TypeParam {
      type: number;
    }
    const params: TypeParam = { type: type };
    return await http.get<ApiResponse>('/top/song', params);
  }

  static async getTopArtists(limit: number = 50, offset: number = 0): Promise<ApiResponse> {
    interface LimitOffsetParam {
      limit: number;
      offset: number;
    }
    const params: LimitOffsetParam = { limit: limit, offset: offset };
    return await http.get<ApiResponse>('/top/artists', params);
  }
}
