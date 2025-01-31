//
//  ChangePasswordView.swift
//  GrowIT
//
//  Created by 강희정 on 1/17/25.
//

import UIKit
import SnapKit
import Then

class ChangePasswordView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)has not been implemented")
    }
                   
    // MARK: - UI Components
    
    public lazy var emailTextField = CustomTextField().then {
        $0.setTitleLabel("이메일")
        $0.setPlaceholder("이메일을 입력해 주세요")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public lazy var emailLabel = UILabel().then {
        $0.text = "가입 시 사용했던 이메일을 입력해 주세요"
        $0.textColor = .gray500
        $0.textAlignment = .left
        $0.font = UIFont.detail2Regular()
    }
    
    public lazy var sendCodeButton = AppButton(
        title: "인증번호 발송",
        titleColor: .gray400,
        isEnabled: true
    ).then {
        // 초기 상태 설정
        $0.setButtonState(isEnabled: true, enabledColor: .gray100, disabledColor: .black, enabledTitleColor: .gray100, disabledTitleColor: .black)
        
        $0.titleLabel?.font = UIFont.body1Medium()
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray400.cgColor
    }
    
    public lazy var codeTextField = CustomTextField().then {
        $0.setTitleLabel("인증번호")
        $0.setPlaceholder("인증번호를 입력해 주세요")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public lazy var certificationButton = AppButton(
        title: "인증하기",
        titleColor: .gray400,
        isEnabled: true
    ).then {
        // 초기 상태 설정
        $0.setButtonState(isEnabled: true, enabledColor: .gray100, disabledColor: .black, enabledTitleColor: .gray100, disabledTitleColor: .black)
        
        $0.titleLabel?.font = UIFont.body1Medium()
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.gray400.cgColor
    }
    
    public lazy var newPwdTextField = CustomTextField().then {
        $0.setTitleLabel("새로운 비밀번호")
        $0.setPlaceholder("새로운 비밀번호를 입력해 주세요")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public lazy var pwdCheckTextField = CustomTextField().then {
        $0.setTitleLabel("비밀번호 확인")
        $0.setPlaceholder("비밀번호를 한 번 더 입력해 주세요")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public lazy var changePwdButton = AppButton(
        title: "비밀번호 변경하기",
        titleColor: .gray400,
        isEnabled: true
    ).then {
        // 초기 상태 설정
        $0.setButtonState(isEnabled: true, enabledColor: .gray100, disabledColor: .black, enabledTitleColor: .gray100, disabledTitleColor: .black)
    }
    
    // MARK: - add Function & Constraints
    
    private func addComponents() {
        [emailTextField, emailLabel, sendCodeButton,
         codeTextField, certificationButton, newPwdTextField,
         pwdCheckTextField, changePwdButton]
            .forEach(self.addSubview)
    }
    
    private func constraints() {
        
    }
}
