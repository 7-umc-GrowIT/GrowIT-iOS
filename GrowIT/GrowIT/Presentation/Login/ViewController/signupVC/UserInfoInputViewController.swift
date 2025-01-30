//
//  UserInfoInputViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/25/25.
//

import UIKit
import SnapKit

class UserInfoInputViewController: UIViewController {
    
    // MARK: - Properties
    private let userInfoView = UserInfoInputView()
    private let navigationBarManager = NavigationManager()
    
    let authService = AuthService()
    
    // 이전 화면에서 전달받을 데이터
    var email: String = ""
    var isVerified: Bool = false
    var agreeTerms: [UserTermDTO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        nextButtonState()
    }
    
    // MARK: - SetupView
    private func setupView() {
        self.view = userInfoView
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
    
    // MARK: - Setup Actions
    private func setupActions() {
        
        userInfoView.passwordTextField.textField.isSecureTextEntry = true
        userInfoView.passwordCheckTextField.textField.isSecureTextEntry = true
        
        // 비밀번호 확인 필드에서만 액션 설정
        userInfoView.passwordCheckTextField.textField.addTarget(
            self, action: #selector(passwordCheckFieldDidChange), for: .editingChanged
        )
        
        userInfoView.nextButton.addTarget(self, action: #selector(nextButtonTap), for: .touchUpInside)
    }
    
    // MARK: - Update Button States
    private func nextButtonState() {
        guard let password = userInfoView.passwordTextField.textField.text,
              let confirmPassword = userInfoView.passwordCheckTextField.textField.text
        else { return }
        
        // 비밀번호가 일치하고 둘 다 비어 있지 않을 경우 버튼 활성화
        let isPasswordsMatch = !password.isEmpty && password == confirmPassword
        
        // 버튼 상태 업데이트
        userInfoView.nextButton.setButtonState(
            isEnabled: isPasswordsMatch,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400
        )
    }
    
    // MARK: - Actions
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func passwordCheckFieldDidChange() {
        guard let password = userInfoView.passwordTextField.textField.text,
              let confirmPassword = userInfoView.passwordCheckTextField.textField.text
        else { return }

        if confirmPassword.isEmpty {
            // 비밀번호 확인 필드가 비어 있으면 초기 상태 유지
            userInfoView.passwordCheckTextField.clearError()
            return
        }
        
        if password == confirmPassword {
            // 비밀번호가 일치
            [userInfoView.passwordTextField, userInfoView.passwordCheckTextField].forEach {
                $0.setSuccess()
                $0.titleLabel.textColor = .gray900
                $0.textField.textColor = .positive400
            }
            userInfoView.passwordCheckTextField.errorLabel.text = "비밀번호가 일치합니다"
            userInfoView.passwordCheckTextField.errorLabel.textColor = .positive400
            userInfoView.passwordCheckTextField.errorLabel.isHidden = false
        } else {
            // 비밀번호가 일치하지 않음
            userInfoView.passwordCheckTextField.setError(message: "비밀번호가 일치하지 않습니다")
            userInfoView.passwordCheckTextField.titleLabel.textColor = .negative400
            userInfoView.passwordCheckTextField.textField.textColor = .negative400
        }
        
        // 버튼 상태 업데이트
        nextButtonState()
    }
    
    @objc func nextButtonTap() {
        print("🚀 [DEBUG] 다음 버튼 눌림")
        guard let name = userInfoView.nameTextField.textField.text, !name.isEmpty else {
            print("이름을 입력하세요")
            return
        }
        guard let password = userInfoView.passwordTextField.textField.text, !password.isEmpty else {
            print("비밀번호를 입력하세요")
            return
        }
        
        let signUpRequest = EmailSignUpRequest(
            isVerified: isVerified,
            email: email,
            name: name,
            password: password,
            userTerms: agreeTerms
        )
        
        authService.users(data: signUpRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("회원 가입 성공 액세스 토큰: \(response.result.accessToken)")
                    
                    UserDefaults.standard.set(response.result.accessToken, forKey: "accessToken")
                    self.moveToLoginScreen()
                    
                case .failure(let error):
                    print("회원가입 실패: \(error)")
                }
            }
        }
    }
    
    func moveToLoginScreen() {
        let signUpCompleteVC = SignUpCompleteViewController()
        self.navigationController?.pushViewController(signUpCompleteVC, animated: true)
    }
}
