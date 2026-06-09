/**
 * DJ / Radio API
 * @layer feature/recommend
 */
import HttpManager from '../../common/network/HttpManager';
import { ApiResponse } from '../../common/models/ApiTypes';

const http: HttpManager = HttpManager.getInstance();

export default class DjApi {
  static async getDetail(rid: number): Promise<ApiResponse> {
    interface RidParam {
      rid: number;
    }
    const params: RidParam = { rid: rid };
    return await http.get<ApiResponse>('/dj/detail', params);
  }

  static async getPrograms(rid: number, limit: number = 30, offset: number = 0): Promise<ApiResponse> {
    interface RidLimitOffsetParam {
      rid: number;
      limit: number;
      offset: number;
    }
    const params: RidLimitOffsetParam = { rid: rid, limit: limit, offset: offset };
    return await http.get<ApiResponse>('/dj/program', params);
  }

  static async getHot(limit: number = 6): Promise<ApiResponse> {
    interface LimitParam {
      limit: number;
    }
    const params: LimitParam = { limit: limit };
    return await http.get<ApiResponse>('/dj/hot', params);
  }

  static async getRecommend(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/dj/recommend');
  }

  static async subscribe(rid: number, t: number): Promise<ApiResponse> {
    interface RidTParam {
      rid: number;
      t: number;
    }
    const params: RidTParam = { rid: rid, t: t };
    return await http.get<ApiResponse>('/dj/sub', params);
  }

  static async getSubList(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/dj/sublist');
  }
}
