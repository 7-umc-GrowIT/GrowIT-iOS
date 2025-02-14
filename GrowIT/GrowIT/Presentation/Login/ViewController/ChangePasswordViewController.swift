//
//  ChangePasswordViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/17/25.
//

import UIKit
import Foundation
import SnapKit

class ChangePasswordViewController: UIViewController {
    
    // MARK: - Properties
    private let changePasswordView = ChangePasswordView()
    private let navigationBarManager = NavigationManager()
    private var isEmailFieldDisabled = false
    private var isCodeFieldDisabled = false
    
    private var userService: UserService {
        return UserService()
    }
    
    private var authService: AuthService {
        return AuthService()
    }
    
    private var email: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        updateSendCodeButtonState()
        updateCertificationButtonState()
        updatePasswordMatchState()
        updatePwdChangeBtnState()
    }
    
    // MARK: - Setup View
    private func setupView() {
        self.view = changePasswordView
        self.navigationController?.isNavigationBarHidden = false
        
        navigationBarManager.setTitle(
            to: self.navigationItem,
            title: "비밀번호 변경",
            textColor: .gray900,
            font: .heading1Bold()
        )
        
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        // TextField 이벤트 설정
        changePasswordView.emailTextField.textField.addTarget(
            self, action: #selector(textFieldsDidChange), for: .editingChanged
        )
        changePasswordView.codeTextField.textField.addTarget(
            self, action: #selector(textFieldsDidChange), for: .editingChanged
        )
        changePasswordView.newPwdTextField.textField.isSecureTextEntry = true
        changePasswordView.newPwdTextField.textField.addTarget(
            self, action: #selector(textFieldsDidChange), for: .editingChanged
        )
        changePasswordView.pwdCheckTextField.textField.isSecureTextEntry = true
        changePasswordView.pwdCheckTextField.textField.addTarget(
            self, action: #selector(textFieldsDidChange), for: .editingChanged
        )
        
        // 버튼 이벤트 설정
        changePasswordView.sendCodeButton.addTarget(
            self, action: #selector(sendCodeButtonTapped), for: .touchUpInside
        )
        changePasswordView.certificationButton.addTarget(
            self, action: #selector(certificationButtonTapped), for: .touchUpInside
        )
        changePasswordView.changePwdButton.addTarget(
            self, action: #selector(changePwdButtonTapped), for: .touchUpInside
        )
    }
    
    // MARK: - TextField Change Handler
    @objc private func textFieldsDidChange() {
        updateSendCodeButtonState()
        updateCertificationButtonState()
        updatePasswordMatchState()
        updatePwdChangeBtnState()
    }
    
    // MARK: - Update Button States
    private func updateSendCodeButtonState() {
        guard let emailText = changePasswordView.emailTextField.textField.text else { return }
        
        if isEmailFieldDisabled {
            setEmailFieldDisabledUI()
            return
        }
        
        if emailText.isEmpty {
            changePasswordView.emailTextField.clearError()
            changePasswordView.emailLabel.isHidden = false
        } else if isValidEmail(emailText) {
            changePasswordView.emailTextField.clearError()
            changePasswordView.emailLabel.isHidden = false
        } else {
            changePasswordView.emailTextField.setError(message: "올바르지 않은 이메일 형식입니다.")
            changePasswordView.emailLabel.isHidden = true
        }
        
        let isEmailValid = isValidEmail(emailText)
        changePasswordView.sendCodeButton.setButtonState(
            isEnabled: isEmailValid,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400
        )
    }
    
    private func updateCertificationButtonState() {
        guard let codeText = changePasswordView.codeTextField.textField.text else { return }
        
        if isCodeFieldDisabled {
            setCodeFieldDisabledUI()
            return
        }
        
        if codeText.isEmpty {
            changePasswordView.codeTextField.clearError()
        } else if codeText.count != 4 {
            changePasswordView.codeTextField.setError(message: "인증번호가 올바르지 않습니다.")
        } else {
            changePasswordView.codeTextField.clearError()
        }
        
        let isCodeValid = !codeText.isEmpty && codeText.count == 4
        changePasswordView.certificationButton.setButtonState(
            isEnabled: isCodeValid,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400
        )
    }
    
    private func updatePwdChangeBtnState() {
        guard let newPassword = changePasswordView.newPwdTextField.textField.text,
              let confirmPassword = changePasswordView.pwdCheckTextField.textField.text else { return }
        
        let isPasswordsMatch = !newPassword.isEmpty && newPassword == confirmPassword
        
        changePasswordView.changePwdButton.setButtonState(
            isEnabled: isPasswordsMatch,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400
        )
    }
    
    // MARK: - Helper
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func setEmailFieldDisabledUI() {
        changePasswordView.emailTextField.setTextFieldInteraction(enabled: false)
        changePasswordView.emailTextField.textField.isUserInteractionEnabled = false
        changePasswordView.emailTextField.titleLabel.textColor = .gray300
        changePasswordView.emailTextField.textField.textColor = .gray300
        changePasswordView.emailTextField.textField.backgroundColor = .gray100
    }
    
    private func setCodeFieldDisabledUI() {
        changePasswordView.codeTextField.setTextFieldInteraction(enabled: false)
        changePasswordView.codeTextField.titleLabel.textColor = .gray300
        changePasswordView.codeTextField.textField.textColor = .gray300
        changePasswordView.codeTextField.textField.backgroundColor = .gray100
    }
    
    // MARK: - API
    private func handlePasswordChange() {
        guard let email = changePasswordView.emailTextField.textField.text,
              let newPassword = changePasswordView.newPwdTextField.textField.text,
              let passwordCheck = changePasswordView.pwdCheckTextField.textField.text else {
            return
        }
        
        let request = UserPatchRequestDTO(
            isVerified: true,
            email: email,
            password: newPassword,
            passwordCheck: passwordCheck
        )

        userService.patchUserPassword(data: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("비밀번호 변경 성공: \(response.message)")
                    
                    // 성공 메시지 표시
                    let toastImage = UIImage(named: "Style=check") ?? UIImage()
                    Toast.show(
                        image: toastImage,
                        message: "비밀번호 변경이 완료되었습니다.",
                        font: UIFont.heading3SemiBold()
                    )
                    
                    // 이전 화면으로 이동
                    self?.navigationController?.popViewController(animated: true)

                case .failure(let error):
                    print("비밀번호 변경 실패: \(error)")
                    self?.changePasswordView.pwdCheckTextField.setError(message: "비밀번호 변경에 실패했습니다.")
                }
            }
        }
    }

    
    // MARK: - Actions
    @objc private func prevVC() {
        let changePwdErrorVC = ChangePasswordErrorViewController()
        let navController = UINavigationController(rootViewController: changePwdErrorVC)
        navController.modalPresentationStyle = .pageSheet
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    private func updatePasswordMatchState() {
        guard let newPassword = changePasswordView.newPwdTextField.textField.text,
              let confirmPassword = changePasswordView.pwdCheckTextField.textField.text else { return }
        
        if confirmPassword.isEmpty {
            changePasswordView.pwdCheckTextField.clearError()
            return
        }
        
        if newPassword == confirmPassword {
            changePasswordView.newPwdTextField.setSuccess()
            changePasswordView.pwdCheckTextField.setSuccess()
            
            changePasswordView.newPwdTextField.titleLabel.textColor = .gray900
            changePasswordView.pwdCheckTextField.titleLabel.textColor = .gray900
            changePasswordView.newPwdTextField.textField.textColor = .positive400
            changePasswordView.pwdCheckTextField.textField.textColor = .positive400
            
            changePasswordView.pwdCheckTextField.errorLabel.text = "비밀번호가 일치합니다"
            changePasswordView.pwdCheckTextField.errorLabel.textColor = .positive400
            changePasswordView.pwdCheckTextField.errorLabel.isHidden = false
        } else {
            changePasswordView.newPwdTextField.setError(message: "")
            changePasswordView.pwdCheckTextField.setError(message: "비밀번호가 일치하지 않습니다")
            
            changePasswordView.newPwdTextField.titleLabel.textColor = .negative400
            changePasswordView.pwdCheckTextField.titleLabel.textColor = .negative400
            changePasswordView.newPwdTextField.textField.textColor = .negative400
            changePasswordView.pwdCheckTextField.textField.textColor = .negative400
            
            changePasswordView.pwdCheckTextField.errorLabel.isHidden = false
        }
    }
    
    @objc private func sendCodeButtonTapped() {
        guard let emailText = changePasswordView.emailTextField.textField.text,
              !emailText.isEmpty else {
            return
        }
        
        email = emailText
        let request = SendEmailVerifyRequest(email: emailText)
        
        authService.email(type: "PASSWORD", data: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("인증 메일 전송 성공: \(response.message)")
                    
                    self?.isEmailFieldDisabled = true
                    self?.setEmailFieldDisabledUI()
                    
                    let toastImage = UIImage(named: "Style=Mail") ?? UIImage()
                    Toast.show(
                        image: toastImage,
                        message: "인증번호를 발송했어요",
                        font: UIFont.heading3SemiBold()
                    )
                    
                case .failure(let error):
                    print("인증 메일 전송 실패: \(error)")
                    self?.changePasswordView.emailTextField.setError(message: "이메일 전송에 실패했습니다.")
                }
            }
        }
    }
    
    @objc private func certificationButtonTapped() {
        guard let emailText = changePasswordView.emailTextField.textField.text,
              let codeText = changePasswordView.codeTextField.textField.text,
              !codeText.isEmpty else {
            return
        }
        
        let request = EmailVerifyRequest(email: emailText, authCode: codeText)
        
        authService.verification(data: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("인증번호 확인 성공: \(response.message)")
                    
                    self?.isCodeFieldDisabled = true
                    self?.setCodeFieldDisabledUI()
                    
                    let toastImage = UIImage(named: "Style=check") ?? UIImage()
                    Toast.show(
                        image: toastImage,
                        message: "인증번호 인증을 완료했어요",
                        font: UIFont.heading3SemiBold()
                    )
                    
                case .failure(let error):
                    print("인증번호 확인 실패: \(error)")
                    self?.changePasswordView.codeTextField.setError(message: "인증번호가 올바르지 않습니다.")
                }
            }
        }
    }
    
    @objc private func changePwdButtonTapped() {
        handlePasswordChange()
    }
}
