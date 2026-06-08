/**
 * 电台/DJ 相关 API
 */
import HttpManager from './HttpManager';
import {
  ApiResponse,
} from './ApiTypes';

interface RidParam {
  rid: number;
}

interface RidLimitOffsetParam {
  rid: number;
  limit: number;
  offset: number;
}

interface LimitParam {
  limit: number;
}

interface RidTParam {
  rid: number;
  t: number;
}

const http = HttpManager.getInstance();

export default class DjApi {
  /**
   * 13.1 电台详情
   */
  static async getDetail(rid: number): Promise<ApiResponse> {
    const params: RidParam = {
      rid: rid
    };
    return await http.get<ApiResponse>('/dj/detail', params);
  }

  /**
   * 13.2 电台节目
   */
  static async getPrograms(rid: number, limit: number = 30, offset: number = 0): Promise<ApiResponse> {
    const params: RidLimitOffsetParam = {
      rid: rid,
      limit: limit,
      offset: offset
    };
    return await http.get<ApiResponse>('/dj/program', params);
  }

  /**
   * 13.3 热门电台
   */
  static async getHot(limit: number = 6): Promise<ApiResponse> {
    const params: LimitParam = {
      limit: limit
    };
    return await http.get<ApiResponse>('/dj/hot', params);
  }

  /**
   * 13.4 电台推荐
   */
  static async getRecommend(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/dj/recommend');
  }

  /**
   * 13.5 订阅/取消订阅电台
   */
  static async subscribe(rid: number, t: number): Promise<ApiResponse> {
    const params: RidTParam = {
      rid: rid,
      t: t
    };
    return await http.get<ApiResponse>('/dj/sub', params);
  }

  /**
   * 13.6 订阅电台列表
   */
  static async getSubList(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/dj/sublist');
  }
}
