//
//  ChangePasswordViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Foundation
import Combine

final class ChangePasswordViewModel {
    
    enum State {
        case idle
        case loading
        case codeSent
        case codeVerified
        case passwordChanged
        case failure(String)
    }
    
    // Input
    @Published var email: String = ""
    @Published var code: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    
    // Output
    @Published private(set) var isEmailValid: Bool = false
    @Published private(set) var isCodeValid: Bool = false
    @Published private(set) var isPasswordMatch: Bool = false
    @Published private(set) var state: State = .idle
    
    private var cancellables = Set<AnyCancellable>()
    
    private let authService: AuthService
    private let userService: UserService
    
    init(authService: AuthService = AuthService(), userService: UserService = UserService()) {
        self.authService = authService
        self.userService = userService
        bindValidation()
    }
    
    private func bindValidation() {
        $email
            .map { email in
                let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
                return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
            }
            .assign(to: &$isEmailValid)
        
        $code
            .map { code in
                let regex = "^[A-Za-z0-9]{8}$"
                return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: code)
            }
            .assign(to: &$isCodeValid)
        
        Publishers.CombineLatest($newPassword, $confirmPassword)
            .map { newPwd, confirmPwd in
                !newPwd.isEmpty && newPwd == confirmPwd
            }
            .assign(to: &$isPasswordMatch)
    }
    
    // 인증번호 발송
    func sendCode() {
        guard isEmailValid else { return }
        state = .loading
        
        authService.sendVerificationEmailPublisher(email: email, type: "PASSWORD_RESET")
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] _ in
                self?.state = .codeSent
            })
            .store(in: &cancellables)
    }
    
    // 인증번호 확인
    func verifyCode() {
        guard isCodeValid else { return }
        state = .loading
        
        authService.verifyCodePublisher(email: email, code: code)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] _ in
                self?.state = .codeVerified
            })
            .store(in: &cancellables)
    }
    
    // 비밀번호 변경
    func changePassword() {
        guard isPasswordMatch else { return }
        state = .loading
        
        userService.changePasswordPublisher(email: email, newPassword: newPassword, confirmPassword: confirmPassword)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] _ in
                self?.state = .passwordChanged
            })
            .store(in: &cancellables)
    }
}
