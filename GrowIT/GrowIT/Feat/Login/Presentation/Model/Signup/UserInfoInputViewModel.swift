//
//  UserInfoInputViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/23/25.
//

import Combine
import Foundation
import UIKit

final class UserInfoInputViewModel {
    
    enum State {
        case idle
        case signingUp
        case success
        case failure(String)
    }
    
    // Inputs
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // Outputs
    @Published private(set) var isNextButtonEnabled: Bool = false
    @Published private(set) var passwordMatchMessage: String = ""
    @Published private(set) var passwordMatchColor: UIColor = .clear
    @Published private(set) var state: State = .idle
    
    private var cancellables = Set<AnyCancellable>()
    private let authService: AuthService
    
    // 외부 전달 데이터
    var email: String = ""
    var isVerified: Bool = false
    var agreeTerms: [UserTermDTO] = []
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
        bindValidation()
    }
    
    private func bindValidation() {
        Publishers.CombineLatest($password, $confirmPassword)
            .map { password, confirm in
                guard !password.isEmpty && !confirm.isEmpty else { return false }
                return password == confirm
            }
            .sink { [weak self] isMatch in
                self?.isNextButtonEnabled = isMatch
                if isMatch {
                    self?.passwordMatchMessage = "비밀번호가 일치합니다"
                    self?.passwordMatchColor = .positive400
                } else {
                    self?.passwordMatchMessage = "비밀번호가 일치하지 않습니다"
                    self?.passwordMatchColor = .negative400
                }
            }
            .store(in: &cancellables)
    }
    
    func signUp() {
        guard isNextButtonEnabled, !name.isEmpty else { return }
        
        state = .signingUp
        
        let request = EmailSignUpRequest(
            isVerified: isVerified,
            email: email,
            name: name,
            password: password,
            userTerms: agreeTerms
        )
        
        authService.signUpPublisher(type: "email", data: request)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] _ in
                self?.state = .success
            })
            .store(in: &cancellables)
    }
}
