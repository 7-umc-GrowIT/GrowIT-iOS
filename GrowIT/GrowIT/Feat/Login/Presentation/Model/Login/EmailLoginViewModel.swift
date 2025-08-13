//
//  EmailLoginViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Foundation
import Combine

final class EmailLoginViewModel {
    
    enum State {
        case idle
        case loading
        case success
        case failure(String)
    }
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published private(set) var state: State = .idle
    @Published private(set) var isFormValid: Bool = false
    
    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
        bindValidation()
    }
    
    // 폼 유효성 검사
    private func bindValidation() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailValid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
                let passwordValid = !password.isEmpty
                return emailValid && passwordValid
            }
            .assign(to: &$isFormValid)
    }
    
    // 이메일 로그인 실행
    func login() {
        state = .loading
        
        authService.loginEmailPublisher(email: email, password: password)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                if response.isSuccess {
                    let tokens = response.result
                    TokenManager.shared.saveTokens(
                        accessToken: tokens.accessToken,
                        refreshToken: tokens.refreshToken
                    )
                    self?.state = .success
                } else {
                    self?.state = .failure("로그인 실패: \(response.message)")
                }
            })
            .store(in: &cancellables)
    }
}
