/**
 * Comment API
 * @layer feature/comment
 */
import HttpManager from '../../common/network/HttpManager';
import {
  ApiResponse,
  CommentResult
} from '../../common/models/ApiTypes';

const http: HttpManager = HttpManager.getInstance();

export default class CommentApi {
  static async getMusicComments(id: number, limit: number = 20, offset: number = 0): Promise<CommentResult> {
    interface CommentListParams {
      id: number;
      limit: number;
      offset: number;
    }
    const params: CommentListParams = { id: id, limit: limit, offset: offset };
    return await http.get<CommentResult>('/comment/music', params);
  }

  static async getPlaylistComments(id: number, limit: number = 20, offset: number = 0): Promise<CommentResult> {
    interface CommentListParams {
      id: number;
      limit: number;
      offset: number;
    }
    const params: CommentListParams = { id: id, limit: limit, offset: offset };
    return await http.get<CommentResult>('/comment/playlist', params);
  }

  static async getHotComments(id: number, type: number, limit: number = 20, offset: number = 0): Promise<CommentResult> {
    interface HotCommentParams {
      id: number;
      type: number;
      limit: number;
      offset: number;
    }
    const params: HotCommentParams = { id: id, type: type, limit: limit, offset: offset };
    return await http.get<CommentResult>('/comment/hot', params);
  }

  static async sendComment(id: number, type: number, t: number, content: string, commentId?: number): Promise<ApiResponse> {
    interface SendCommentParams {
      id: number;
      type: number;
      t: number;
      content: string;
      commentId?: number;
    }
    const params: SendCommentParams = { id: id, type: type, t: t, content: content };
    if (commentId !== undefined) {
      params.commentId = commentId;
    }
    return await http.get<ApiResponse>('/comment', params);
  }

  static async likeComment(id: number, type: number, t: number, commentId: number): Promise<ApiResponse> {
    interface LikeCommentParams {
      id: number;
      type: number;
      t: number;
      commentId: number;
    }
    const params: LikeCommentParams = { id: id, type: type, t: t, commentId: commentId };
    return await http.get<ApiResponse>('/comment/like', params);
  }
}
