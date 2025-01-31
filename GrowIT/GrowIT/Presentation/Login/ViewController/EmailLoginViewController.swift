//
//  EmailLoginViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/13/25.
//

import UIKit
import Foundation
import SnapKit

class EmailLoginViewController: UIViewController {
    
    //MARK: - Properties
    let emailLoginView = EmailLoginView()
    let navigationBarManager = NavigationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        loadCheckBoxState()
        updateLoginButtonState()
    }
    
    // MARK: - Setup View
    private func setupView() {
        self.view = emailLoginView
        self.navigationController?.isNavigationBarHidden = false
        
        // 네비게이션 타이틀 설정
        navigationBarManager.setTitle(
            to: self.navigationItem,
            title: "이메일로 로그인",
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
        emailLoginView.emailSaveButton.addTarget(self, action: #selector(toggleCheckBox), for: .touchUpInside)
        
        emailLoginView.emailTextField.textField.addTarget(
            self, action: #selector(textFieldsDidChange), for: .editingChanged
        )
        emailLoginView.pwdTextField.textField.addTarget(
            self, action: #selector(textFieldsDidChange), for: .editingChanged
        )
    }
    
    //MARK: - Text Fields Change Handler
   @objc private func textFieldsDidChange() {
       updateLoginButtonState()
   }
   
   private func updateLoginButtonState() {
       let isEmailValid = emailLoginView.emailTextField.validationRule?(emailLoginView.emailTextField.textField.text ?? "") ?? false
       let isPasswordValid = !(emailLoginView.pwdTextField.textField.text ?? "").isEmpty
       
       let isFormValid = isEmailValid && isPasswordValid
       
       emailLoginView.loginButton.setButtonState(
           isEnabled: isFormValid,
           enabledColor: .black, // 활성화 상태에서 검정색 배경
           disabledColor: .gray100, // 비활성화 상태의 배경색
           enabledTitleColor: .black,
           disabledTitleColor: .gray100
           
       )

       // 버튼 텍스트 색상 업데이트
       let textColor: UIColor = isFormValid ? .white : .gray400
       emailLoginView.loginButton.setTitleColor(textColor, for: .normal)
   }
    
    // MARK: - @objc methods
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func toggleCheckBox() {
        let isChecked = !emailLoginView.emailSaveButton.isSelected
        emailLoginView.emailSaveButton.isSelected = isChecked
        
        // 아이디 저장 상태를 UserDefaults에 저장
        UserDefaults.standard.set(isChecked, forKey: "isCheckBoxChecked")
    }
    
    // MARK: - Load State
    private func loadCheckBoxState() {
        let isChecked = UserDefaults.standard.bool(forKey: "isCheckBoxChecked")
        emailLoginView.emailSaveButton.isSelected = isChecked
    }
}

