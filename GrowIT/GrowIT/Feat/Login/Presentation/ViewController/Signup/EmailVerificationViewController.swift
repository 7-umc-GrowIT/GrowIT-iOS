//
//  EmailVerificationViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/25/25.
//

import UIKit
import Combine

class EmailVerificationViewController: UIViewController {
    
    private let emailVerificationView = EmailVerificationView()
    private let navigationBarManager = NavigationManager()
    private let viewModel = EmailVerificationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var agreeTerms: [UserTermDTO] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        setupActions()
        setupKeyboardDismiss()
    }
    
    private func setupView() {
        self.view = emailVerificationView
        navigationBarManager.setTitle(to: navigationItem, title: "회원가입", textColor: .gray900, font: .heading1Bold())
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(prevVC))
    }
    
    private func bindViewModel() {
        // 이메일 입력 → ViewModel.email
        emailVerificationView.emailTextField.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        
        // 인증번호 입력 → ViewModel.code
        emailVerificationView.codeTextField.textField.addTarget(self, action: #selector(codeChanged), for: .editingChanged)
        
        // 버튼 상태 바인딩
        viewModel.$isSendButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                self?.emailVerificationView.sendCodeButton.setButtonState(
                    isEnabled: enabled,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        viewModel.$isVerifyButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                self?.emailVerificationView.certificationButton.setButtonState(
                    isEnabled: enabled,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        viewModel.$isNextButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] enabled in
                self?.emailVerificationView.nextButton.setButtonState(
                    isEnabled: enabled,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        // 상태 변화 처리
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .codeSent:
                    self?.showToast("인증번호를 발송했어요")
                case .verified:
                    self?.showToast("이메일 인증 완료")
                case .failure(let error):
                    self?.showToast("오류: \(error)")
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        emailVerificationView.sendCodeButton.addTarget(self, action: #selector(sendCodeTapped), for: .touchUpInside)
        emailVerificationView.certificationButton.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        emailVerificationView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    private func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailVerificationView.emailTextField.textField.text ?? ""
    }
    
    @objc private func codeChanged() {
        viewModel.code = emailVerificationView.codeTextField.textField.text ?? ""
    }
    
    @objc private func sendCodeTapped() {
        viewModel.sendCode()
    }
    
    @objc private func verifyTapped() {
        viewModel.verifyCode()
    }
    
    @objc private func nextTapped() {
        let userInfoVC = UserInfoInputViewController()
        userInfoVC.email = viewModel.email
        userInfoVC.isVerified = true
        userInfoVC.agreeTerms = agreeTerms
        navigationController?.pushViewController(userInfoVC, animated: true)
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
