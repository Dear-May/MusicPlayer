import HttpManager from './HttpManager';
import {
  LoginResult, LoginStatusResult, ApiResponse
} from './ApiTypes';

export interface QrKeyResponse {
  unikey: string;
}

export interface QrCreateResponse {
  qrimg: string;
  qrurl: string;
}

export interface QrCheckResponse {
  code: number;
  message?: string;
}

// 登录相关参数接口
interface PhoneLoginParams {
  phone: string;
  password: string;
  countrycode: string;
}

interface EmailLoginParams {
  email: string;
  password: string;
}

interface QrCreateParams {
  key: string;
  qrimg: boolean;
  platform: string;
}

interface SingleKeyParams {
  key: string;
}

interface PhoneOnlyParams {
  phone: string;
  ctcode: string;
}

interface PhoneCaptchaParams {
  phone: string;
  captcha: string;
}

const http = HttpManager.getInstance();

export default class LoginApi {
  /**
   * 1.1 手机号登录
   */
  static async loginByPhone(phone: string, password: string, countrycode: string = '86'): Promise<LoginResult> {
    const params: PhoneLoginParams = {
      phone: phone,
      password: password,
      countrycode: countrycode
    };
    return await http.get<LoginResult>('/login/cellphone', params);
  }

  /**
   * 1.2 邮箱登录
   */
  static async loginByEmail(email: string, password: string): Promise<LoginResult> {
    const params: EmailLoginParams = {
      email: email,
      password: password
    };
    return await http.get<LoginResult>('/login', params);
  }

  /**
   * 1.3.1 二维码登录 - 获取 Key
   */
  static async getQrKey(): Promise<ApiResponse<QrKeyResponse>> {
    return await http.get<ApiResponse<QrKeyResponse>>('/login/qr/key');
  }

  /**
   * 1.3.2 二维码登录 - 创建二维码
   */
  static async createQr(key: string, qrimg: boolean = true, platform: string = 'pc'): Promise<ApiResponse> {
    const params: QrCreateParams = {
      key: key,
      qrimg: qrimg,
      platform: platform
    };
    return await http.get<ApiResponse>('/login/qr/create', params);
  }

  /**
   * 1.3.3 二维码登录 - 检查扫码状态
   * 返回码: 800=过期 801=等待扫码 802=授权中 803=授权成功(登录成功)
   */
  static async checkQr(key: string): Promise<ApiResponse> {
    const params: SingleKeyParams = {
      key: key
    };
    return await http.get<ApiResponse>('/login/qr/check', params);
  }

  /**
   * 1.4 刷新登录状态
   */
  static async refreshLogin(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/login/refresh');
  }

  /**
   * 1.5 获取登录状态
   */
  static async getLoginStatus(): Promise<LoginStatusResult> {
    return await http.get<LoginStatusResult>('/login/status');
  }

  /**
   * 1.6 退出登录
   */
  static async logout(): Promise<ApiResponse> {
    const result = await http.get<ApiResponse>('/logout');
    http.clearCookie();
    return result;
  }

  /**
   * 1.7 匿名注册（获取游客Cookie）
   */
  static async registerAnonymous(): Promise<LoginResult> {
    return await http.get<LoginResult>('/register/anonimous');
  }

  /**
   * 1.9 发送验证码
   */
  static async sendCaptcha(phone: string, ctcode: string = '86'): Promise<ApiResponse> {
    const params: PhoneOnlyParams = {
      phone: phone,
      ctcode: ctcode
    };
    return await http.get<ApiResponse>('/captcha/sent', params);
  }

  /**
   * 1.10 验证验证码
   */
  static async verifyCaptcha(phone: string, captcha: string): Promise<ApiResponse> {
    const params: PhoneCaptchaParams = {
      phone: phone,
      captcha: captcha
    };
    return await http.get<ApiResponse>('/captcha/verify', params);
  }
}
