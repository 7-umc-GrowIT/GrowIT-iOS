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
    private var isEmailFieldDisabled = false // 이메일 TextField 비활성화 상태
    private var isCodeFieldDisabled = false // 인증번호 TextField 비활성화 상태
    
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
            // 이메일 필드가 이미 비활성화된 상태면 유지
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
        
        // 비밀번호가 일치하고 둘 다 비어 있지 않을 경우 버튼 활성화
        let isPasswordsMatch = !newPassword.isEmpty && newPassword == confirmPassword
        
        // 버튼 상태 업데이트
        changePasswordView.changePwdButton.setButtonState(
            isEnabled: isPasswordsMatch,
            enabledColor: .black,         // 활성화 상태의 배경색
            disabledColor: .gray100,      // 비활성화 상태의 배경색
            enabledTitleColor: .white,    // 활성화 상태의 텍스트 색상
            disabledTitleColor: .gray400  // 비활성화 상태의 텍스트 색상
        )
    }


    
    // MARK: - Helper
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func setEmailFieldDisabledUI() {
        // 이메일 TextField와 관련된 UI를 비활성화 상태로 설정
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
            // 비밀번호 확인 필드가 비어 있으면 초기 상태 유지
            changePasswordView.pwdCheckTextField.clearError()
            return
        }
    
        if newPassword == confirmPassword {
            // 비밀번호 일치
            changePasswordView.newPwdTextField.setSuccess()
            changePasswordView.pwdCheckTextField.setSuccess()
            
            // 라벨 색상 변경
            changePasswordView.newPwdTextField.titleLabel.textColor = .gray900
            changePasswordView.pwdCheckTextField.titleLabel.textColor = .gray900
            changePasswordView.newPwdTextField.textField.textColor = .positive400
            changePasswordView.pwdCheckTextField.textField.textColor = .positive400
            
            changePasswordView.pwdCheckTextField.errorLabel.text = "비밀번호 변경을 완료했습니다"
            changePasswordView.pwdCheckTextField.errorLabel.textColor = .positive400
            changePasswordView.pwdCheckTextField.errorLabel.isHidden = false
        } else {
            // 비밀번호 불일치
            changePasswordView.newPwdTextField.setError(message: "")
            changePasswordView.pwdCheckTextField.setError(message: "비밀번호가 일치하지 않습니다")
            
            // 라벨 색상 유지
            changePasswordView.newPwdTextField.titleLabel.textColor = .negative400
            changePasswordView.pwdCheckTextField.titleLabel.textColor = .negative400
            changePasswordView.newPwdTextField.textField.textColor = .negative400
            changePasswordView.pwdCheckTextField.textField.textColor = .negative400
            
            changePasswordView.pwdCheckTextField.errorLabel.isHidden = false
        }

    }
    
    @objc private func sendCodeButtonTapped() {
        // 이메일 필드 비활성화
        isEmailFieldDisabled = true
        setEmailFieldDisabledUI()
        
        // 버튼 비활성화
        changePasswordView.sendCodeButton.setButtonState(
            isEnabled: false,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray300
        )
        
        // 토스트 메시지 표시
        let toastImage = UIImage(named: "Style=Mail") ?? UIImage()
        Toast.show(
            image: toastImage,
            message: "인증번호를 발송했어요",
            font: UIFont.heading3SemiBold()
        )
    }
    
    @objc private func certificationButtonTapped() {
        
        isCodeFieldDisabled = true
        setCodeFieldDisabledUI()
        
        // 버튼 비활성화
        changePasswordView.certificationButton.setButtonState(
            isEnabled: false,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray300
        )
        
        // 토스트 메시지 표시
        let toastImage = UIImage(named: "Style=check") ?? UIImage()
        Toast.show(
            image: toastImage,
            message: "인증번호 인증을 완료했어요",
            font: UIFont.heading3SemiBold()
        )
    }
    
}
