//
//  AuthService+Combine.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//  Updated by OpenAI on 7/23/25
//

import Combine
import Foundation

extension AuthService {
    
    // MARK: - 공통 에러 변환
    private func mapError(_ error: Error) -> Error {
        let nsError = error as NSError
        if nsError.domain == NSURLErrorDomain {
            return NSError(domain: "Network", code: nsError.code, userInfo: [
                NSLocalizedDescriptionKey: "네트워크 오류가 발생했습니다. 다시 시도해주세요."
            ])
        }
        return error
    }
    
    // MARK: - 카카오 로그인
    func loginKakaoPublisher(code: String) -> AnyPublisher<LoginUnifiedResponse, Error> {
        Future<LoginUnifiedResponse, Error> { promise in
            self.loginKakao(code: code) { result in
                switch result {
                case .success(let kakaoResponse):
                    let converted = LoginUnifiedResponse(
                        signupRequired: kakaoResponse.result.signupRequired,
                        tokens: kakaoResponse.result.tokens,
                        oauthUserInfo: kakaoResponse.result.oauthUserInfo,
                        message: kakaoResponse.message,
                        code: kakaoResponse.code
                    )
                    promise(.success(converted))
                    
                case .failure(let error):
                    promise(.failure(self.mapError(error)))
                }
            }
        }
        .timeout(.seconds(10), scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
        .eraseToAnyPublisher()
    }
    
    // MARK: - 이메일 로그인
    func loginEmailPublisher(email: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        Future<LoginResponse, Error> { promise in
            let request = EmailLoginRequest(email: email, password: password)
            self.loginEmail(data: request) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(self.mapError(error)))
                }
            }
        }
        .timeout(.seconds(10), scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
        .eraseToAnyPublisher()
    }
    
    // MARK: - 인증 메일 발송
    func sendVerificationEmailPublisher(email: String, type: String) -> AnyPublisher<EmailVerifyResponse, Error> {
        Future { promise in
            self.email(type: type, data: SendEmailVerifyRequest(email: email)) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(self.mapError(error)))
                }
            }
        }
        .timeout(.seconds(10), scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
        .eraseToAnyPublisher()
    }
    
    // MARK: - 인증 코드 확인
    func verifyCodePublisher(email: String, code: String) -> AnyPublisher<VerifyResponse, Error> {
        Future { promise in
            self.verification(data: EmailVerifyRequest(email: email, authCode: code)) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(self.mapError(error)))
                }
            }
        }
        .timeout(.seconds(10), scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
        .eraseToAnyPublisher()
    }
    
    // MARK: - 회원가입
    func signUpPublisher(type: String, data: EmailSignUpRequest) -> AnyPublisher<SignUpResponse, Error> {
        Future { promise in
            self.signUp(type: type, data: data) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(self.mapError(error)))
                }
            }
        }
        .timeout(.seconds(15), scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
        .eraseToAnyPublisher()
    }
    
    // MARK: - 토큰 재발급 (ReissueResponse)
        func reissueTokenPublisher(refreshToken: String) -> AnyPublisher<ReissueResponse, Error> {
            Future { promise in
                self.reissueToken(refreshToken: refreshToken) { result in
                    switch result {
                    case .success(let response): promise(.success(response))
                    case .failure(let error): promise(.failure(self.mapError(error)))
                    }
                }
            }
            .timeout(.seconds(10), scheduler: DispatchQueue.main, customError: { URLError(.timedOut) })
            .eraseToAnyPublisher()
        }
}
