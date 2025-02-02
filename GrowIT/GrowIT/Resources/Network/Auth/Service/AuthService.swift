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
    
    // MARK: - API funcs
    
    /// 이메일 인증 확인
    func verification(data: EmailVerifyRequest, completion: @escaping (Result<VerifyResponse, NetworkError>) -> Void) {
        request(target: .postVerification(data: data), decodingType: VerifyResponse.self, completion: completion)
    }

    /// 토큰 재발급
    func reissue(data: ReissueTokenRequest, completion: @escaping (Result<ReissueResponse, NetworkError>) -> Void) {
        request(target: .postReissueToken(data: data), decodingType: ReissueResponse.self, completion: completion)
    }
    
    /// 카카오 로그인
    func loginKakao(code: String, completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        request(target: .postKakaoLogin(code: code), decodingType: LoginResponse.self, completion: completion)
    }
    
    /// 이메일 로그인
    func loginEmail(data: EmailLoginRequest, completion: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        request(target: .postEmailLogin(data: data), decodingType: LoginResponse.self, completion: completion)
    }
    
    /// 이메일 인증 요청
    func email(type: String, data: SendEmailVerifyRequest, completion: @escaping (Result<EmailVerifyResponse, NetworkError>) -> Void) {
        request(target: .postSendEmailVerification(type: type, data: data), decodingType: EmailVerifyResponse.self, completion: completion)
    }
    
    /// 회원가입 요청 (디코딩 오류 출력 추가)
        func signUp(type: String, data: EmailSignUpRequest, completion: @escaping (Result<SignUpResponse, NetworkError>) -> Void) {
            provider.request(.postEmailSignUp(data: data)) { result in
                switch result {
                case .success(let response):
                    do {
                        // 📩 서버에서 받은 JSON 데이터 출력
                        let jsonString = String(data: response.data, encoding: .utf8)
                        print("📩 서버 응답 JSON: \(jsonString ?? "데이터 없음")")

                        // ✅ JSON 디코딩 시 오류 확인
                        let decodedResponse = try JSONDecoder().decode(SignUpResponse.self, from: response.data)
                        print("✅ 회원가입 성공! 액세스 토큰: \(decodedResponse.result.accessToken ?? "없음")")
                        completion(.success(decodedResponse))
                        
                    } catch {
                        // ❌ 디코딩 오류 발생 시 상세 원인 출력
                        print("❌ 회원가입 응답 디코딩 실패: \(error)")
                        if let decodingError = error as? DecodingError {
                            switch decodingError {
                            case .keyNotFound(let key, _):
                                print("❌ 키 없음: \(key.stringValue)")
                            case .typeMismatch(let type, let context):
                                print("❌ 타입 불일치: \(type), \(context.debugDescription)")
                            case .valueNotFound(let type, let context):
                                print("❌ 값 없음: \(type), \(context.debugDescription)")
                            default:
                                print("❌ 기타 디코딩 오류: \(error.localizedDescription)")
                            }
                        }
                        completion(.failure(.decodingError))
                    }

                case .failure(let error):
                    print("❌ 네트워크 요청 실패: \(error.localizedDescription)")
                }
            }
        }
    
    
//    /// 회원가입 요청
//    func signUp(type: String, data: EmailSignUpRequest, completion: @escaping (Result<SignUpResponse, NetworkError>) -> Void) {
//        request(target: .postEmailSignUp(data: data), decodingType: SignUpResponse.self, completion: completion)
//    }


}
