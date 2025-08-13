//
//  LoginViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/13/25.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private lazy var loginView = LoginView()
    private let viewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        bindViewModel()
        setupActions()
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle:
                    break
                case .loading:
                    print("로딩 중...")
                case .success:
                    self?.navigateToMainScreen()
                case .signupRequired(let oauthInfo):
                    let termsVC = KakaoTermsAgreeViewController(oauthUserInfo: oauthInfo)
                    self?.navigationController?.pushViewController(termsVC, animated: true)
                case .failure(let error):
                    print("로그인 실패: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        loginView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)
        loginView.emailLoginButton.addTarget(self, action: #selector(emailLoginTapped), for: .touchUpInside)
    }
    
    @objc private func kakaoLoginTapped() {
        viewModel.send(.kakaoLogin)
    }
    
    @objc private func emailLoginTapped() {
        let emailLoginVC = EmailLoginViewController()
        navigationController?.pushViewController(emailLoginVC, animated: true)
    }
    
    private func navigateToMainScreen() {
        let homeVC = HomeViewController()
        navigationController?.setViewControllers([homeVC], animated: true)
    }
}
