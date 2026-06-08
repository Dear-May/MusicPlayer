/**
 * 推荐相关 API
 */
import HttpManager from './HttpManager';
import {
  ApiResponse,
  BannerResult,
  RecommendPlaylistResult,
  RecommendSongsResult,
  ToplistDetailResult
} from './ApiTypes';

interface TypeParam {
  type: number;
}

interface LimitOffsetParam {
  limit: number;
  offset: number;
}

interface LimitParam {
  limit: number;
}

const http = HttpManager.getInstance();

export default class RecommendApi {
  /**
   * 14.1 首页轮播图
   */
  static async getBanners(type: number = 1): Promise<BannerResult> {
    const params: TypeParam = {
      type: type
    };
    return await http.get<BannerResult>('/banner', params);
  }

  /**
   * 11.1 每日推荐歌曲（需登录）
   */
  static async getDailySongs(): Promise<RecommendSongsResult> {
    return await http.get<RecommendSongsResult>('/recommend/songs');
  }

  /**
   * 11.2 每日推荐歌单（需登录）
   */
  static async getDailyPlaylists(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/recommend/resource');
  }

  /**
   * 11.3 推荐歌单
   */
  static async getPersonalized(limit: number = 30, offset: number = 0): Promise<RecommendPlaylistResult> {
    const params: LimitOffsetParam = {
      limit: limit,
      offset: offset
    };
    return await http.get<RecommendPlaylistResult>('/personalized', params);
  }

  /**
   * 11.4 推荐新音乐
   */
  static async getNewSong(limit: number = 30): Promise<ApiResponse> {
    const params: LimitParam = {
      limit: limit
    };
    return await http.get<ApiResponse>('/personalized/newsong', params);
  }

  /**
   * 10.2 排行榜详情
   */
  static async getToplistDetail(): Promise<ToplistDetailResult> {
    return await http.get<ToplistDetailResult>('/toplist/detail');
  }

  /**
   * 10.5 新歌速递
   */
  static async getTopSongs(type: number = 0): Promise<ApiResponse> {
    const params: TypeParam = {
      type: type
    };
    return await http.get<ApiResponse>('/top/song', params);
  }

  /**
   * 10.4 热门歌手
   */
  static async getTopArtists(limit: number = 50, offset: number = 0): Promise<ApiResponse> {
    const params: LimitOffsetParam = {
      limit: limit,
      offset: offset
    };
    return await http.get<ApiResponse>('/top/artists', params);
  }
}
