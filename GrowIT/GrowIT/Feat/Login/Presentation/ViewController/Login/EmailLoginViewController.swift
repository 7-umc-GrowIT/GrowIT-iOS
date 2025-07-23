//
//  EmailLoginViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/13/25.
//

import UIKit
import Combine

class EmailLoginViewController: UIViewController {
    
    private let emailLoginView = EmailLoginView()
    private let viewModel = EmailLoginViewModel()
    private let navigationBarManager = NavigationManager()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        setupActions()
        loadCheckBoxState()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupView() {
        self.view = emailLoginView
        navigationBarManager.setTitle(to: navigationItem, title: "이메일로 로그인", textColor: .gray900, font: .heading1Bold())
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(prevVC))
    }
    
    private func bindViewModel() {
        // 이메일 & 비밀번호 입력 → ViewModel 바인딩
        emailLoginView.emailTextField.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        emailLoginView.pwdTextField.textField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        
        // 폼 유효성 → 로그인 버튼 상태 변경
        viewModel.$isFormValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.emailLoginView.loginButton.setButtonState(
                    isEnabled: isValid,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        // 로그인 상태 → 화면 이동 / 에러 처리
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle:
                    break
                case .loading:
                    break
                case .success:
                    self?.moveToNextScreen()
                case .failure:
                    self?.emailLoginView.pwdTextField.setError(message: "비밀번호가 일치하지 않습니다.")
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        emailLoginView.emailSaveButton.addTarget(self, action: #selector(toggleCheckBox), for: .touchUpInside)
        emailLoginView.loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        emailLoginView.changePwdButton.addTarget(self, action: #selector(changePwdBtnTap), for: .touchUpInside)
        emailLoginView.singUpButton.addTarget(self, action: #selector(signUpBtnTap), for: .touchUpInside)
        emailLoginView.findEmailButton.addTarget(self, action: #selector(findEmailBtnTap), for: .touchUpInside)
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailLoginView.emailTextField.textField.text ?? ""
    }
    
    @objc private func passwordChanged() {
        viewModel.password = emailLoginView.pwdTextField.textField.text ?? ""
    }
    
    @objc private func loginTapped() {
        viewModel.login()
    }
    
    @objc private func toggleCheckBox() {
        let isChecked = !emailLoginView.emailSaveButton.isSelected
        emailLoginView.emailSaveButton.isSelected = isChecked
        UserDefaults.standard.set(isChecked, forKey: "isCheckBoxChecked")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func loadCheckBoxState() {
        emailLoginView.emailSaveButton.isSelected = UserDefaults.standard.bool(forKey: "isCheckBoxChecked")
    }
    
    private func moveToNextScreen() {
        let homeVC = CustomTabBarController(initialIndex: 1)
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func changePwdBtnTap() {
        navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
    }
    
    @objc func signUpBtnTap() {
        navigationController?.pushViewController(TermsAgreeViewController(), animated: true)
    }
    
    @objc func findEmailBtnTap() {
        navigationController?.pushViewController(FindEmailViewController(), animated: true)
    }
}
