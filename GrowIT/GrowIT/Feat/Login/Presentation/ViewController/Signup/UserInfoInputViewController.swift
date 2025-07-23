//
//  UserInfoInputViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/25/25.
//

import UIKit
import Combine

final class UserInfoInputViewController: UIViewController {
    
    private let userInfoView = UserInfoInputView()
    private let navigationBarManager = NavigationManager()
    private let viewModel = UserInfoInputViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // 외부에서 데이터 주입
    var email: String = ""
    var isVerified: Bool = false
    var agreeTerms: [UserTermDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
        setupActions()
        
        // 데이터 주입
        viewModel.email = email
        viewModel.isVerified = isVerified
        viewModel.agreeTerms = agreeTerms
    }
    
    private func setupView() {
        self.view = userInfoView
        self.navigationController?.isNavigationBarHidden = false
        
        navigationBarManager.setTitle(to: self.navigationItem, title: "회원가입", textColor: .gray900, font: .heading1Bold())
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(prevVC))
    }
    
    private func setupBindings() {
        // 버튼 활성화 상태
        viewModel.$isNextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                self?.userInfoView.nextButton.setButtonState(
                    isEnabled: enabled,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        // 비밀번호 일치 메시지
        viewModel.$passwordMatchMessage
            .combineLatest(viewModel.$passwordMatchColor)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message, color in
                if !message.isEmpty {
                    self?.userInfoView.passwordCheckTextField.errorLabel.text = message
                    self?.userInfoView.passwordCheckTextField.errorLabel.textColor = color
                    self?.userInfoView.passwordCheckTextField.errorLabel.isHidden = false
                } else {
                    self?.userInfoView.passwordCheckTextField.errorLabel.isHidden = true
                }
            }
            .store(in: &cancellables)
        
        // 상태 변화
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .success:
                    self?.navigateToCompleteScreen()
                case .failure(let error):
                    self?.showToast("회원가입 실패: \(error)")
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        userInfoView.nameTextField.textField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        userInfoView.passwordTextField.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        userInfoView.passwordCheckTextField.textField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        
        userInfoView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func nameChanged() {
        viewModel.name = userInfoView.nameTextField.textField.text ?? ""
    }
    
    @objc private func passwordChanged() {
        viewModel.password = userInfoView.passwordTextField.textField.text ?? ""
    }
    
    @objc private func confirmPasswordChanged() {
        viewModel.confirmPassword = userInfoView.passwordCheckTextField.textField.text ?? ""
    }
    
    @objc private func nextTapped() {
        viewModel.signUp()
    }
    
    private func navigateToCompleteScreen() {
        let completeVC = SignUpCompleteViewController()
        navigationController?.pushViewController(completeVC, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showToast(_ message: String) {
        let toastImage = UIImage(named: "Style=check") ?? UIImage()
        CustomToast(containerWidth: 258).show(image: toastImage, message: message, font: UIFont.heading3SemiBold())
    }
}
