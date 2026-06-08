/**
 * HTTP请求管理器 - 单例模式
 * 管理API基础URL、Cookie持久化、统一请求/响应拦截
 */
import axios, { AxiosInstance, AxiosResponse, AxiosError, InternalAxiosRequestConfig } from '@ohos/axios';

/** API基础URL */
const BASE_URL: string = 'https://yy2003.fit:11478';

/** 请求超时时间(毫秒) */
const REQUEST_TIMEOUT: number = 15000;

export default class HttpManager {
  private static instance: HttpManager;
  private client: AxiosInstance;
  /** 持久化的Cookie字符串 */
  private cookie: string = '';

  static getInstance(): HttpManager {
    if (!HttpManager.instance) {
      HttpManager.instance = new HttpManager();
    }
    return HttpManager.instance;
  }

  private constructor() {
    this.client = axios.create({
      baseURL: BASE_URL,
      timeout: REQUEST_TIMEOUT,
      headers: {
        'User-Agent': 'Mozilla/5.0 (Linux; Android 10; HarmonyOS) AppleWebKit/537.36',
        'Content-Type': 'application/x-www-form-urlencoded',
      }
    });

    // 请求拦截器 - 自动添加Cookie
    this.client.interceptors.request.use(
      (config: InternalAxiosRequestConfig) => {
        if (this.cookie) {
          (config.headers as Record<string, string>)['Cookie'] = this.cookie;
        }
        return config;
      },
      (error: AxiosError) => {
        console.error('HttpManager request interceptor error:', JSON.stringify(error));
        return Promise.reject(error);
      }
    );

    // 响应拦截器 - 自动提取并保存Set-Cookie
    this.client.interceptors.response.use(
      (response: AxiosResponse) => {
        // 提取Set-Cookie头
        const headers = response.headers as Record<string, string | string[]>;
        const setCookie = headers['Set-Cookie'] || headers['set-cookie'];
        if (setCookie) {
          this.mergeCookies(setCookie);
        }
        return response;
      },
      (error: AxiosError) => {
        console.error('HttpManager response interceptor error:', JSON.stringify(error));
        // 也尝试从错误响应中提取Cookie
        if (error.response?.headers) {
          const errHeaders = error.response.headers as Record<string, string | string[]>;
          const setCookie = errHeaders['Set-Cookie'] || errHeaders['set-cookie'];
          if (setCookie) {
            this.mergeCookies(setCookie);
          }
        }
        return Promise.reject(error);
      }
    );
  }

  /**
   * 合并Cookie（保留旧的cookie并追加新的）
   */
  private mergeCookies(setCookie: string | string[]): void {
    try {
      let cookies: string[] = [];
      if (typeof setCookie === 'string') {
        cookies = [setCookie];
      } else if (Array.isArray(setCookie)) {
        cookies = setCookie;
      }
      const newParts: string[] = [];
      for (const raw of cookies) {
        // 只取 'key=value' 部分，忽略 path/domain/expires 等
        const semicolonIdx = raw.indexOf(';');
        const part = semicolonIdx > 0 ? raw.substring(0, semicolonIdx) : raw;
        if (part) {
          newParts.push(part);
        }
      }
      if (newParts.length > 0) {
        // 合并到现有cookie（已有key替换，新key追加）
        const existingMap = new Map<string, string>();
        if (this.cookie) {
          this.cookie.split(';').forEach(pair => {
            const eqIdx = pair.indexOf('=');
            if (eqIdx > 0) {
              existingMap.set(pair.substring(0, eqIdx).trim(), pair.trim());
            }
          });
        }
        newParts.forEach(part => {
          const eqIdx = part.indexOf('=');
          if (eqIdx > 0) {
            existingMap.set(part.substring(0, eqIdx).trim(), part.trim());
          } else if (part) {
            // 无=的cookie值也保留
            existingMap.set(part, part);
          }
        });
        this.cookie = Array.from(existingMap.values()).join(';');
      }
      console.info('HttpManager cookie updated');
    } catch (err) {
      console.error('HttpManager mergeCookies error:', JSON.stringify(err));
    }
  }

  /** 获取当前Cookie */
  getCookie(): string {
    return this.cookie;
  }

  /** 设置Cookie（用于从持久化存储恢复） */
  setCookie(cookie: string): void {
    this.cookie = cookie;
  }

  /** 清空Cookie（退出登录时使用） */
  clearCookie(): void {
    this.cookie = '';
    console.info('HttpManager cookie cleared');
  }

  /** 检查是否有有效的登录态 */
  hasLogin(): boolean {
    // 检查是否存在MUSIC_U或MUSIC_A等关键cookie
    return this.cookie.includes('MUSIC_U') || this.cookie.includes('MUSIC_A');
  }

  // ============ 通用请求方法 ============

  /**
   * GET 请求
   */
  async get<T>(url: string, params?: Object): Promise<T> {
    try {
      const response: AxiosResponse = await this.client.get(url, {
        params: params
      });
      return response.data as T;
    } catch (err) {
      console.error(`HttpManager GET ${url} error:`, JSON.stringify(err));
      throw (err instanceof Error ? err : new Error(String(err)));
    }
  }

  /**
   * POST 请求
   */
  async post<T>(url: string, data?: Object): Promise<T> {
    try {
      const response: AxiosResponse = await this.client.post(url, data, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        }
      });
      return response.data as T;
    } catch (err) {
      console.error(`HttpManager POST ${url} error:`, JSON.stringify(err));
      throw (err instanceof Error ? err : new Error(String(err)));
    }
  }
}
