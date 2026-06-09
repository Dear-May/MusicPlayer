/**
 * Search API
 * @layer feature/search
 */
import HttpManager from '../../common/network/HttpManager';
import {
  ApiResponse,
  SearchResult,
  SearchSuggestResult
} from '../../common/models/ApiTypes';

const http: HttpManager = HttpManager.getInstance();

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

export default class SearchApi {
  static async search(
    keywords: string,
    type: number = 1,
    limit: number = 30,
    offset: number = 0
  ): Promise<SearchResult> {
    interface SearchParams {
      keywords: string;
      type: number;
      limit: number;
      offset: number;
    }
    const params: SearchParams = {
      keywords: keywords,
      type: type,
      limit: limit,
      offset: offset
    };
    return await http.get<SearchResult>('/search', params);
  }

  static async suggest(keywords: string, type: string = 'mobile'): Promise<SearchSuggestResult> {
    interface SuggestParams {
      keywords: string;
      type: string;
    }
    const params: SuggestParams = {
      keywords: keywords,
      type: type
    };
    return await http.get<SearchSuggestResult>('/search/suggest', params);
  }

  static async hotSearch(): Promise<ApiResponse<HotSearchData>> {
    return await http.get<ApiResponse<HotSearchData>>('/search/hot');
  }

  static async hotSearchDetail(): Promise<ApiResponse<HotSearchDetailData>> {
    return await http.get<ApiResponse<HotSearchDetailData>>('/search/hot/detail');
  }

  static async defaultKeyword(): Promise<ApiResponse<DefaultKeywordResult>> {
    return await http.get<ApiResponse<DefaultKeywordResult>>('/search/default');
  }

  static async multiMatch(keywords: string): Promise<ApiResponse> {
    interface MultiMatchParams {
      keywords: string;
    }
    const params: MultiMatchParams = {
      keywords: keywords
    };
    return await http.get<ApiResponse>('/search/multimatch', params);
  }
}
