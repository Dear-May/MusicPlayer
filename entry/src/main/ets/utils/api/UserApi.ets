/**
 * 用户相关 API
 */
import HttpManager from './HttpManager';
import {
  ApiResponse,
  UserDetailResult,
  UserPlaylistResult,
  UserProfile,
  CommentResult
} from './ApiTypes';

const http = HttpManager.getInstance();

export default class UserApi {
  /**
   * 9.1 用户详情
   */
  static async getUserDetail(uid: number): Promise<UserDetailResult> {
    return await http.get<UserDetailResult>('/user/detail', {
      uid: uid
    });
  }

  /**
   * 9.2 用户歌单
   */
  static async getUserPlaylist(uid: number, limit: number = 30, offset: number = 0): Promise<UserPlaylistResult> {
    return await http.get<UserPlaylistResult>('/user/playlist', {
      uid: uid,
      limit: limit,
      offset: offset
    });
  }

  /**
   * 9.3 用户听歌排行
   */
  static async getUserRecord(uid: number, type: number = 0): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/user/record', {
      uid: uid,
      type: type
    });
  }

  /**
   * 9.6 获取用户账户信息（需登录）
   */
  static async getUserAccount(): Promise<ApiResponse<{ profile: UserProfile; [key: string]: any }>> {
    return await http.get<ApiResponse<{ profile: UserProfile; [key: string]: any }>>('/user/account');
  }

  /**
   * 9.7 用户等级（需登录）
   */
  static async getUserLevel(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/user/level');
  }

  /**
   * 3.7 获取点赞列表
   */
  static async getLikedSongs(uid: number): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/likelist', {
      uid: uid
    });
  }
}

/**
 * 评论相关 API
 */
export class CommentApi {
  /**
   * 8.3 歌曲评论
   */
  static async getMusicComments(id: number, limit: number = 20, offset: number = 0): Promise<CommentResult> {
    return await http.get<CommentResult>('/comment/music', {
      id: id,
      limit: limit,
      offset: offset
    });
  }

  /**
   * 8.2 歌单评论
   */
  static async getPlaylistComments(id: number, limit: number = 20, offset: number = 0): Promise<CommentResult> {
    return await http.get<CommentResult>('/comment/playlist', {
      id: id,
      limit: limit,
      offset: offset
    });
  }

  /**
   * 8.6 热门评论
   */
  static async getHotComments(id: number, type: number, limit: number = 20, offset: number = 0): Promise<CommentResult> {
    return await http.get<CommentResult>('/comment/hot', {
      id: id,
      type: type,
      limit: limit,
      offset: offset
    });
  }

  /**
   * 8.1 发送/回复评论
   */
  static async sendComment(id: number, type: number, t: number, content: string, commentId?: number): Promise<ApiResponse> {
    const params: Record<string, any> = {
      id: id,
      type: type,
      t: t,
      content: content
    };
    if (commentId !== undefined) {
      params.commentId = commentId;
    }
    return await http.get<ApiResponse>('/comment', params);
  }

  /**
   * 8.7 评论点赞
   */
  static async likeComment(id: number, type: number, t: number, commentId: number): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/comment/like', {
      id: id,
      type: type,
      t: t,
      commentId: commentId
    });
  }
}
