//
//  EmailVerificationViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/25/25.
//

import UIKit
import Foundation

class EmailVerificationViewController: UIViewController {
    
    // MARK: - Properties
    private let emailVerificationView = EmailVerificationView()
    private let navigationBarManager = NavigationManager()
    private var isEmailFieldDisabled = false
    private var isCodeFieldDisabled = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
    }
    
    // MARK: - Setup View
    private func setupView() {
        self.view = emailVerificationView
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
        
        emailVerificationView.nextButton.addTarget(self, action: #selector(
            nextButtonTap), for: .touchUpInside)
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        // TextField 이벤트 설정
        emailVerificationView.emailTextField.textField.addTarget(
            self, action: #selector(textFieldsDidChange), for: .editingChanged
        )
        emailVerificationView.codeTextField.textField.addTarget(
            self, action: #selector(textFieldsDidChange), for: .editingChanged
        )
        
        // 버튼 이벤트 설정
        emailVerificationView.sendCodeButton.addTarget(
            self, action: #selector(sendCodeButtonTapped), for: .touchUpInside
        )
        emailVerificationView.certificationButton.addTarget(
            self, action: #selector(certificationButtonTapped), for: .touchUpInside
        )
    }
    
    // MARK: - TextField Change Handler
    @objc private func textFieldsDidChange() {
        updateSendCodeButtonState()
        updateCertificationButtonState()
    }
    
    // MARK: - Update Button States
    private func updateSendCodeButtonState() {
        guard let emailText = emailVerificationView.emailTextField.textField.text else { return }
        
        // 이메일 필드와 인증번호 필드 모두 활성화 상태 유지
        emailVerificationView.emailTextField.setTextFieldInteraction(enabled: true)
        emailVerificationView.codeTextField.setTextFieldInteraction(enabled: true)
        
        
        if emailText.isEmpty {
            emailVerificationView.emailTextField.clearError()
        } else if isValidEmail(emailText) {
            emailVerificationView.emailTextField.clearError()
        } else {
            emailVerificationView.emailTextField.setError(message: "올바르지 않은 이메일 형식입니다.")
        }
        
        let isEmailValid = isValidEmail(emailText)
        emailVerificationView.sendCodeButton.setButtonState(
            isEnabled: isEmailValid,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400
        )
    }
    
    
    private func updateCertificationButtonState() {
        guard let codeText = emailVerificationView.codeTextField.textField.text else { return }
        if isCodeFieldDisabled {
            setCodeFieldDisabledUI()
            return
        }
        
        if codeText.isEmpty {
            emailVerificationView.codeTextField.clearError()
        } else if codeText.count != 4 {
            emailVerificationView.codeTextField.setError(message: "인증번호가 올바르지 않습니다.")
        } else {
            emailVerificationView.codeTextField.clearError()
        }
        
        let isCodeValid = !codeText.isEmpty && codeText.count == 4
        emailVerificationView.certificationButton.setButtonState(
            isEnabled: isCodeValid,
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
    
    private func setCodeFieldDisabledUI() {
        emailVerificationView.codeTextField.setTextFieldInteraction(enabled: false)
        emailVerificationView.codeTextField.titleLabel.textColor = .gray300
        emailVerificationView.codeTextField.textField.textColor = .gray300
        emailVerificationView.codeTextField.textField.backgroundColor = .gray100
        
    }
    
    // MARK: - Actions
    @objc private func prevVC() {
        let emailErrorVC = EmailVerificationErrorViewController()
        let navController = UINavigationController(rootViewController: emailErrorVC)
        navController.modalPresentationStyle = .pageSheet
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    @objc private func sendCodeButtonTapped() {
        isEmailFieldDisabled = true
        
        // 토스트 메시지 표시
        let toastImage = UIImage(named: "Style=Mail") ?? UIImage()
        Toast.show(
            image: toastImage,
            message: "인증번호를 발송했어요",
            font: UIFont.heading3SemiBold(),
            in: self.view
        )
    }
    
    @objc private func certificationButtonTapped() {
        // 1. 인증번호 필드 비활성화
        isCodeFieldDisabled = true
        setCodeFieldDisabledUI()
        
        // 2. 이메일 필드를 Success 상태로 변경
        emailVerificationView.emailTextField.setTextFieldInteraction(enabled: false)
        emailVerificationView.emailTextField.setSuccess()
        
        // 3. 성공 메시지 표시
        emailVerificationView.emailTextField.errorLabel.text = "이메일 인증이 완료되었습니다."
        emailVerificationView.emailTextField.errorLabel.textColor = UIColor.positive400 // 성공 색상
        emailVerificationView.emailTextField.errorLabel.isHidden = false
        emailVerificationView.emailTextField.errorLabelTopConstraint?.update(offset: 4)
        
        // 4. 인증하기 버튼 비활성화
        emailVerificationView.certificationButton.setButtonState(
            isEnabled: false,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray300
        )
        
        emailVerificationView.sendCodeButton.setButtonState(
            isEnabled: false,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray300
        )
        
        // 5. 토스트 메시지 표시
        let toastImage = UIImage(named: "Style=check") ?? UIImage()
        Toast.show(
            image: toastImage,
            message: "인증번호 인증을 완료했어요",
            font: UIFont.heading3SemiBold(),
            in: self.view
        )
        
        // 버튼 상태 업데이트
        emailVerificationView.nextButton.setButtonState(
            isEnabled: true,
            enabledColor: .black,         // 활성화 상태의 배경색
            disabledColor: .gray100,      // 비활성화 상태의 배경색
            enabledTitleColor: .white,    // 활성화 상태의 텍스트 색상
            disabledTitleColor: .gray400  // 비활성화 상태의 텍스트 색상
        )
        
        
    }
    
    @objc func nextButtonTap() {
        let userInfoVC = UserInfoInputViewController()
        self.navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
}
