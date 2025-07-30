//
//  LoginViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Foundation
import Combine

final class LoginViewModel {
    
    enum Input {
        case kakaoLogin
        case emailLogin
    }
    
    enum State {
        case idle
        case loading
        case success
        case signupRequired(oauthInfo: KakaoUserInfo)
        case failure(error: String)
    }
    
    @Published private(set) var state: State = .idle
    
    private let authService: AuthService
    private let kakaoLoginManager: KakaoLoginManager
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthService = AuthService(),
         kakaoLoginManager: KakaoLoginManager = .shared) {
        self.authService = authService
        self.kakaoLoginManager = kakaoLoginManager
    }
    
    func send(_ input: Input) {
        switch input {
        case .kakaoLogin:
            loginWithKakao()
        case .emailLogin:
            break
        }
    }
    
    private func loginWithKakao() {
        state = .loading
        
        kakaoLoginManager.loginWithKakaoPublisher()
            .flatMap { authCode in
                self.authService.loginKakaoPublisher(code: authCode)
            }
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.state = .failure(error: error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                if response.signupRequired,
                   let oauthInfo = response.oauthUserInfo {
                    self.state = .signupRequired(oauthInfo: oauthInfo)
                } else {
                    if let tokens = response.tokens {
                        TokenManager.shared.saveTokens(
                            accessToken: tokens.accessToken,
                            refreshToken: tokens.refreshToken
                        )
                        self.state = .success
                    } else {
                        self.state = .failure(error: "토큰 없음")
                    }
                }
            })
            .store(in: &cancellables)
    }
}
