//
//  EmailVerificationViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/23/25.
//

import Foundation
import Combine

final class EmailVerificationViewModel {
    
    enum State {
        case idle
        case sendingCode
        case codeSent
        case verifying
        case verified
        case failure(String)
    }
    
    @Published var email: String = ""
    @Published var code: String = ""
    @Published private(set) var isSendButtonEnabled: Bool = false
    @Published private(set) var isVerifyButtonEnabled: Bool = false
    @Published private(set) var isNextButtonEnabled: Bool = false
    @Published private(set) var state: State = .idle
    
    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
        bindValidation()
    }
    
    private func bindValidation() {
        $email
            .map { Self.isValidEmail($0) }
            .assign(to: &$isSendButtonEnabled)
        
        $code
            .map { !$0.isEmpty }
            .assign(to: &$isVerifyButtonEnabled)
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func sendCode() {
        guard isSendButtonEnabled else { return }
        state = .sendingCode
        
        authService.sendVerificationEmailPublisher(email: email, type: "SIGNUP")
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] _ in
                self?.state = .codeSent
            })
            .store(in: &cancellables)
    }
    
    func verifyCode() {
        guard isVerifyButtonEnabled else { return }
        state = .verifying
        
        authService.verifyCodePublisher(email: email, code: code)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] _ in
                self?.state = .verified
                self?.isNextButtonEnabled = true
            })
            .store(in: &cancellables)
    }
}
