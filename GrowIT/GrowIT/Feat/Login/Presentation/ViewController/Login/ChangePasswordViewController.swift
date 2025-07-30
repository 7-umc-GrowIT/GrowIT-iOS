//
//  ChangePasswordViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/17/25.
//

import UIKit
import Combine

class ChangePasswordViewController: UIViewController {
    
    private let changePasswordView = ChangePasswordView()
    private let viewModel = ChangePasswordViewModel()
    private let navigationBarManager = NavigationManager()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        setupActions()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupView() {
        self.view = changePasswordView
        navigationBarManager.setTitle(to: navigationItem, title: "비밀번호 변경", textColor: .gray900, font: .heading1Bold())
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(prevVC))
    }
    
    private func bindViewModel() {
        // UI 입력 → ViewModel 바인딩
        changePasswordView.emailTextField.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        changePasswordView.codeTextField.textField.addTarget(self, action: #selector(codeChanged), for: .editingChanged)
        changePasswordView.newPwdTextField.textField.addTarget(self, action: #selector(newPasswordChanged), for: .editingChanged)
        changePasswordView.pwdCheckTextField.textField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        
        // 버튼 상태 자동 업데이트
        viewModel.$isEmailValid
            .sink { [weak self] isValid in
                self?.changePasswordView.sendCodeButton.setButtonState(
                    isEnabled: isValid,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        viewModel.$isCodeValid
            .sink { [weak self] isValid in
                self?.changePasswordView.certificationButton.setButtonState(
                    isEnabled: isValid,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        viewModel.$isPasswordMatch
            .sink { [weak self] isMatch in
                self?.changePasswordView.changePwdButton.setButtonState(
                    isEnabled: isMatch,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .codeSent:
                    self?.showToast("인증번호를 발송했어요")
                case .codeVerified:
                    self?.showToast("인증번호 인증을 완료했어요")
                case .passwordChanged:
                    self?.showToast("비밀번호를 변경했어요")
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.showToast("오류: \(error)")
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        changePasswordView.sendCodeButton.addTarget(self, action: #selector(sendCodeTapped), for: .touchUpInside)
        changePasswordView.certificationButton.addTarget(self, action: #selector(verifyCodeTapped), for: .touchUpInside)
        changePasswordView.changePwdButton.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)
    }
    
    @objc private func emailChanged() {
        viewModel.email = changePasswordView.emailTextField.textField.text ?? ""
    }
    
    @objc private func codeChanged() {
        viewModel.code = changePasswordView.codeTextField.textField.text ?? ""
    }
    
    @objc private func newPasswordChanged() {
        viewModel.newPassword = changePasswordView.newPwdTextField.textField.text ?? ""
    }
    
    @objc private func confirmPasswordChanged() {
        viewModel.confirmPassword = changePasswordView.pwdCheckTextField.textField.text ?? ""
    }
    
    @objc private func sendCodeTapped() {
        viewModel.sendCode()
    }
    
    @objc private func verifyCodeTapped() {
        viewModel.verifyCode()
    }
    
    @objc private func changePasswordTapped() {
        viewModel.changePassword()
    }
    
    private func showToast(_ message: String) {
        let toastImage = UIImage(named: "Style=check") ?? UIImage()
        CustomToast(containerWidth: 225).show(
            image: toastImage,
            message: message,
            font: UIFont.heading3SemiBold()
        )
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
}
