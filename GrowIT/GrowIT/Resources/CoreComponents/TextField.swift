//
//  TextField.swift
//  GrowIT
//
//  Created by 강희정 on 1/14/25.
//

import UIKit
import SnapKit

class CustomTextField: UIView {

    // MARK: - Properties
    let textField = UITextField()
    let titleLabel = UILabel()
    let errorLabel = UILabel()
    let clearButton = UIButton() // clear 버튼
    
    // 테두리
    let defaultBorderColor = UIColor.gray300.cgColor
    let activeBorderColor = UIColor.primary500.cgColor
    let errorBorderColor = UIColor.negative400.cgColor
    let successBorderColor = UIColor.positive400.cgColor
    
    // 배경
    let errorBackgroundColor = UIColor.negative50
    let defaultBackgroundColor = UIColor.white
    let successBackgroundColor = UIColor.positive50

    var validationRule: ((String) -> Bool)?
    var successCondition: (() -> Bool)? // 성공 조건 설정
    var onClearButtonTapped: (() -> Void)?
    
    private var errorLabelTopConstraint: Constraint?

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addTargets()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        addTargets()
    }

    // MARK: - Setup UI
    private func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(textField)
        self.addSubview(errorLabel)
        self.addSubview(clearButton)

        // Title Label 설정
        titleLabel.font = UIFont.heading3Bold()
        titleLabel.textColor = UIColor.black
        titleLabel.text = ""
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Text Field 설정
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = defaultBorderColor
        textField.backgroundColor = defaultBackgroundColor
        textField.font = UIFont.body1Medium()
        textField.textAlignment = .left
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        textField.leftViewMode = .always
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Clear Button 설정
        clearButton.setImage(UIImage(named: "State=Default"), for: .normal)
        clearButton.isHidden = true
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)

        // Error Label 설정
        errorLabel.font = UIFont.detail2Regular()
        errorLabel.textColor = UIColor.negative400
        errorLabel.text = ""
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        setupConstraints()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        textField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        clearButton.snp.makeConstraints {
            $0.centerY.equalTo(textField)
            $0.trailing.equalTo(textField.snp.trailing).offset(-12)
            $0.height.equalTo(24)
        }

        errorLabel.snp.makeConstraints {
            errorLabelTopConstraint = $0.top.equalTo(textField.snp.bottom).offset(0).constraint
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    


    private func addTargets() {
        textField.addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(validateText), for: .editingChanged)
        textField.addTarget(self, action: #selector(toggleClearButtonVisibility), for: .editingChanged)
    }

    // MARK: - Public Methods
    func setTitleLabel(_ text: String) {
        titleLabel.text = text
    }

    func setPlaceholder(_ text: String) {
        textField.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.gray300]
        )
    }

    func setValidationRule(_ rule: @escaping (String) -> Bool) {
        self.validationRule = rule
    }
    
    func setSuccessConditiona(_ condition: @escaping () -> Bool) {
        self.successCondition = condition
    }

    func setError(message: String) {
        textField.layer.borderColor = errorBorderColor
        textField.backgroundColor = errorBackgroundColor
        errorLabel.text = message
        errorLabel.isHidden = false
        errorLabelTopConstraint?.update(offset: 4)
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
        titleLabel.textColor = UIColor.negative400
        clearButton.setImage(UIImage(named: "State=Error"), for: .normal)
    }

    func clearError() {
        textField.layer.borderColor = defaultBorderColor
        textField.backgroundColor = defaultBackgroundColor
        errorLabel.text = ""
        errorLabel.isHidden = true
        errorLabelTopConstraint?.update(offset: 0)

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
        titleLabel.textColor = UIColor.black
        clearButton.setImage(UIImage(named: "State=Default"), for: .normal)
    }
    
    func setSuccess() {
        textField.layer.borderColor = successBorderColor
        textField.backgroundColor = successBackgroundColor
    }

    func clearSuccess() {
        textField.layer.borderColor = defaultBorderColor
        textField.backgroundColor = defaultBackgroundColor
    }

    // MARK: - Private Methods
    @objc private func handleEditingDidBegin() {
        textField.layer.borderColor = activeBorderColor
        titleLabel.textColor = UIColor.gray900
    }

    @objc private func handleEditingDidEnd() {
        validateText()
        checkSuccessCondition()
    }

    @objc private func validateText() {
        guard let text = textField.text, let validationRule = validationRule else { return }
        if validationRule(text) {
            clearError()
        } else {
            setError(message: "올바르지 않은 형식입니다")
        }
    }
    
    @objc private func checkSuccessCondition() {
        guard let successCondition = successCondition else { return }
        if successCondition() {
            setSuccess()
        } else {
            clearSuccess()
        }
    }
    
    @objc private func clearTextField() {
        textField.text = ""
        toggleClearButtonVisibility()
        clearError()
        clearSuccess()
        onClearButtonTapped?()
    }
    
    @objc private func toggleClearButtonVisibility() {
        clearButton.isHidden = textField.text?.isEmpty ?? true
    }
}

