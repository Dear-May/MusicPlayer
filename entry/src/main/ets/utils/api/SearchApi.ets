/**
 * 搜索相关 API
 */
import HttpManager from './HttpManager';
import {
  SearchResult,
  SearchSuggestResult,
  ApiResponse,
  HttpParams
} from './ApiTypes';

export interface HotSearchItem {
  first: string;
}

export interface HotSearchData {
  hots: HotSearchItem[];
}

export interface HotSearchDetailItem {
  searchWord: string;
}

export interface HotSearchDetailData {
  data: HotSearchDetailItem[];
}

export interface DefaultKeywordData {
  showKeyword: string;
}

export interface DefaultKeywordResult {
  data: DefaultKeywordData;
}

const http = HttpManager.getInstance();

export default class SearchApi {
  /**
   * 2.1 搜索
   * @param keywords 关键词
   * @param type 1:单曲 10:专辑 100:歌手 1000:歌单 1002:用户
   * @param limit 每页数量，默认30
   * @param offset 偏移量，默认0
   */
  static async search(
    keywords: string,
    type: number = 1,
    limit: number = 30,
    offset: number = 0
  ): Promise<SearchResult> {
    const params: HttpParams = {
      keywords: keywords,
      type: type,
      limit: limit,
      offset: offset
    };
    return await http.get<SearchResult>('/search', params);
  }

  /**
   * 2.2 搜索建议
   */
  static async suggest(keywords: string, type: string = 'mobile'): Promise<SearchSuggestResult> {
    const params: HttpParams = {
      keywords: keywords,
      type: type
    };
    return await http.get<SearchSuggestResult>('/search/suggest', params);
  }

  /**
   * 2.3 热搜列表
   */
  static async hotSearch(): Promise<ApiResponse<HotSearchData>> {
    return await http.get<ApiResponse<HotSearchData>>('/search/hot');
  }

  /**
   * 2.4 热搜详情
   */
  static async hotSearchDetail(): Promise<ApiResponse<HotSearchDetailData>> {
    return await http.get<ApiResponse<HotSearchDetailData>>('/search/hot/detail');
  }

  /**
   * 2.5 默认搜索词
   */
  static async defaultKeyword(): Promise<ApiResponse<DefaultKeywordResult>> {
    return await http.get<ApiResponse<DefaultKeywordResult>>('/search/default');
  }

  /**
   * 2.6 多重匹配搜索
   */
  static async multiMatch(keywords: string): Promise<ApiResponse> {
    const params: HttpParams = {
      keywords: keywords
    };
    return await http.get<ApiResponse>('/search/multimatch', params);
  }
}
