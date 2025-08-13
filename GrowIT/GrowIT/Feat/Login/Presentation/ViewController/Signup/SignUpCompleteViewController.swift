//
//  SignUpCompleteViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/26/25.
//

import UIKit
import Combine

final class SignUpCompleteViewController: UIViewController {
    
    private let signUpCompleteView = SignUpCompleteView()
    private let navigationBarManager = NavigationManager()
    private let viewModel = SignUpCompleteViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        setupActions()
    }
    
    private func setupView() {
        self.view = signUpCompleteView
        self.navigationController?.isNavigationBarHidden = false
        
        navigationBarManager.setTitle(
            to: self.navigationItem,
            title: "회원가입",
            textColor: .gray900,
            font: .heading1Bold()
        )
        
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    private func setupBindings() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .goToGroSetBackground:
                    let nextVC = GroSetBackgroundViewController()
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        signUpCompleteView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func loginButtonTapped() {
        viewModel.onLoginButtonTap()
    }
}
