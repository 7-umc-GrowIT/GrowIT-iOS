//
//  AuthService.swift
//  GrowIT
//
//  Created by 이수현 on 1/26/25.
//

import Foundation
import Moya

final class AuthService: NetworkManager {
    typealias Endpoint = AuthorizationEndpoints
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<AuthorizationEndpoints>
    
    public init(provider: MoyaProvider<AuthorizationEndpoints>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<AuthorizationEndpoints>(plugins: plugins)
    }
    
    // MARK: - DTO funcs
    
    
    // MARK: - API funcs
    func verification(data: EmailVerifyRequest, completion: @escaping (Result<VerifyResponse, NetworkError>) -> Void) {
        request(target: .postVerification(data: data), decodingType: VerifyResponse.self, completion: completion)
    }
    
    func users(data: EmailSignUpRequest, completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        request(target: .postEmailSignUp(data: data), decodingType: LoginResponse.self, completion: completion)
    }
    
    func reissue(data: ReissueTokenRequest, completion: @escaping (Result<ReissueResponse, NetworkError>) -> Void) {
        request(target: .postReissueToken(data: data), decodingType: ReissueResponse.self, completion: completion)
    }
    
    func loginKakao(code: String, completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        request(target: .postKakaoLogin(code: code), decodingType: LoginResponse.self, completion: completion)
    }
    
    func loginEmail(data: EmailLoginRequest, completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        request(target: .postEmailLogin(data: data), decodingType: LoginResponse.self, completion: completion)
    }
    
    func email(type: String, data: SendEmailVerifyRequest, completion: @escaping (Result<EmailVerifyResponse, NetworkError>) -> Void) {
        request(target: .postSendEmailVerification(type: type, data: data), decodingType: EmailVerifyResponse.self, completion: completion)
    }
}
