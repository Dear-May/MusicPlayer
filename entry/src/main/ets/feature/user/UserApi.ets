/**
 * User API
 * @layer feature/user
 */
import HttpManager from '../../common/network/HttpManager';
import {
  ApiResponse,
  UserDetailResult,
  UserPlaylistResult,
  UserProfile,
  CommentResult
} from '../../common/models/ApiTypes';

const http: HttpManager = HttpManager.getInstance();

export default class UserApi {
  static async getUserDetail(uid: number): Promise<UserDetailResult> {
    interface UidParam {
      uid: number;
    }
    const params: UidParam = { uid: uid };
    return await http.get<UserDetailResult>('/user/detail', params);
  }

  static async getUserPlaylist(uid: number, limit: number = 30, offset: number = 0): Promise<UserPlaylistResult> {
    interface UserPlaylistParams {
      uid: number;
      limit: number;
      offset: number;
    }
    const params: UserPlaylistParams = { uid: uid, limit: limit, offset: offset };
    return await http.get<UserPlaylistResult>('/user/playlist', params);
  }

  static async getUserRecord(uid: number, type: number = 0): Promise<ApiResponse> {
    interface UserRecordParams {
      uid: number;
      type: number;
    }
    const params: UserRecordParams = { uid: uid, type: type };
    return await http.get<ApiResponse>('/user/record', params);
  }

  static async getUserAccount(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/user/account');
  }

  static async getUserLevel(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/user/level');
  }

  static async getLikedSongs(uid: number): Promise<ApiResponse> {
    interface UidParam {
      uid: number;
    }
    const params: UidParam = { uid: uid };
    return await http.get<ApiResponse>('/likelist', params);
  }
}
