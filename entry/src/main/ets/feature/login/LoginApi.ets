/**
 * Login API
 * @layer feature/login
 */
import HttpManager from '../../common/network/HttpManager';
import {
  ApiResponse,
  LoginResult,
  LoginStatusResult
} from '../../common/models/ApiTypes';

const http: HttpManager = HttpManager.getInstance();

export interface QrKeyResponse {
  unikey: string;
}

export interface QrCreateResponse {
  qrimg: string;
  qrurl: string;
}

export default class LoginApi {
  static async loginByPhone(phone: string, password: string, countrycode: string = '86'): Promise<LoginResult> {
    interface PhoneLoginParams {
      phone: string;
      password: string;
      countrycode: string;
    }
    const params: PhoneLoginParams = { phone: phone, password: password, countrycode: countrycode };
    return await http.get<LoginResult>('/login/cellphone', params);
  }

  static async loginByEmail(email: string, password: string): Promise<LoginResult> {
    interface EmailLoginParams {
      email: string;
      password: string;
    }
    const params: EmailLoginParams = { email: email, password: password };
    return await http.get<LoginResult>('/login', params);
  }

  static async getQrKey(): Promise<ApiResponse<QrKeyResponse>> {
    return await http.get<ApiResponse<QrKeyResponse>>('/login/qr/key');
  }

  static async createQr(key: string, qrimg: boolean = true, platform: string = 'pc'): Promise<ApiResponse> {
    interface QrCreateParams {
      key: string;
      qrimg: boolean;
      platform: string;
    }
    const params: QrCreateParams = { key: key, qrimg: qrimg, platform: platform };
    return await http.get<ApiResponse>('/login/qr/create', params);
  }

  static async checkQr(key: string): Promise<ApiResponse> {
    interface SingleKeyParams {
      key: string;
    }
    const params: SingleKeyParams = { key: key };
    return await http.get<ApiResponse>('/login/qr/check', params);
  }

  static async refreshLogin(): Promise<ApiResponse> {
    return await http.get<ApiResponse>('/login/refresh');
  }

  static async getLoginStatus(): Promise<LoginStatusResult> {
    return await http.get<LoginStatusResult>('/login/status');
  }

  static async logout(): Promise<ApiResponse> {
    const result = await http.get<ApiResponse>('/logout');
    http.clearCookie();
    return result;
  }

  static async registerAnonymous(): Promise<LoginResult> {
    return await http.get<LoginResult>('/register/anonimous');
  }

  static async sendCaptcha(phone: string, ctcode: string = '86'): Promise<ApiResponse> {
    interface CaptchaSentParams {
      phone: string;
      ctcode: string;
    }
    const params: CaptchaSentParams = { phone: phone, ctcode: ctcode };
    return await http.get<ApiResponse>('/captcha/sent', params);
  }

  static async verifyCaptcha(phone: string, captcha: string): Promise<ApiResponse> {
    interface CaptchaVerifyParams {
      phone: string;
      captcha: string;
    }
    const params: CaptchaVerifyParams = { phone: phone, captcha: captcha };
    return await http.get<ApiResponse>('/captcha/verify', params);
  }
}
