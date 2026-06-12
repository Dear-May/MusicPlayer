/**
 * HTTP 请求管理器 - 单例模式
 * @layer common/network
 * 管理 API 基础 URL、Cookie 持久化、统一请求拦截
 */
import axios, { AxiosInstance, AxiosResponse, AxiosError, InternalAxiosRequestConfig } from '@ohos/axios';

const BASE_URL: string = 'https://yy2003.fit:11478';
const REQUEST_TIMEOUT: number = 15000;
const MAX_RETRIES: number = 2;

export default class HttpManager {
  private static instance: HttpManager;
  private client: AxiosInstance;
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

    this.client.interceptors.request.use(
      (config: InternalAxiosRequestConfig): InternalAxiosRequestConfig => {
        if (this.cookie) {
          (config.headers as Record<string, string>)['Cookie'] = this.cookie;
        }
        return config;
      },
      (error: AxiosError): Promise<AxiosError> => {
        console.error('HttpManager request interceptor error:', JSON.stringify(error));
        return Promise.reject(error);
      }
    );

    this.client.interceptors.response.use(
      (response: AxiosResponse): AxiosResponse => {
        const headers = response.headers as Record<string, string | string[]>;
        const setCookie = headers['Set-Cookie'] || headers['set-cookie'];
        if (setCookie) {
          this.mergeCookies(setCookie);
        }
        return response;
      },
      (error: AxiosError): Promise<AxiosError> => {
        console.error('HttpManager response error:', JSON.stringify(error));
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
        const semicolonIdx = raw.indexOf(';');
        const part = semicolonIdx > 0 ? raw.substring(0, semicolonIdx) : raw;
        if (part) {
          newParts.push(part);
        }
      }
      if (newParts.length > 0) {
        const existingMap: Map<string, string> = new Map();
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
          }
        });
        this.cookie = Array.from(existingMap.values()).join(';');
      }
    } catch (err) {
      console.error('HttpManager mergeCookies error:', JSON.stringify(err));
    }
  }

  getCookie(): string {
    return this.cookie;
  }

  setCookie(cookie: string): void {
    this.cookie = cookie;
  }

  clearCookie(): void {
    this.cookie = '';
  }

  hasLogin(): boolean {
    return this.cookie.includes('MUSIC_U') || this.cookie.includes('MUSIC_A');
  }

  async get<T>(url: string, params?: object, retries: number = MAX_RETRIES): Promise<T> {
    for (let attempt = 0; attempt <= retries; attempt++) {
      try {
        const response: AxiosResponse = await this.client.get(url, { params });
        return response.data as T;
      } catch (err) {
        if (attempt < retries) {
          console.warn('HttpManager GET retry ' + url + ' attempt ' + (attempt + 1));
          continue;
        }
        console.error('HttpManager GET ' + url + ' error');
        throw (err instanceof Error ? err : new Error(String(err)));
      }
    }
    throw new Error('HttpManager GET ' + url + ' failed');
  }

  async post<T>(url: string, data?: object, retries: number = MAX_RETRIES): Promise<T> {
    for (let attempt = 0; attempt <= retries; attempt++) {
      try {
        const response: AxiosResponse = await this.client.post(url, data, {
          headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
        });
        return response.data as T;
      } catch (err) {
        if (attempt < retries) {
          console.warn('HttpManager POST retry ' + url + ' attempt ' + (attempt + 1));
          continue;
        }
        console.error('HttpManager POST ' + url + ' error:', JSON.stringify(err));
        throw (err instanceof Error ? err : new Error(String(err)));
      }
    }
    throw new Error('HttpManager POST ' + url + ' failed');
  }
}