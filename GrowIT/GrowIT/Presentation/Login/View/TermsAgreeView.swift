//
//  TermsAgreeView.swift
//  GrowIT
//
//  Created by 이수현 on 1/26/25.
//

import UIKit

class TermsAgreeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Components
    private let topLabel = UILabel().then {
        let allText = "그로우잇 시작을 위한\n필수 약관에 동의해 주세요"
        $0.text = allText
        $0.font = .subHeading1()
        $0.textColor = .gray900
        $0.numberOfLines = 0
        $0.setPartialTextStyle(text: allText, targetText: "그로우잇", color: .primary500, font: .subHeading1())
    }
    
    private let allAgreeView = UIView().then {
        $0.backgroundColor = .gray50
        $0.layer.cornerRadius = 8
    }
    
    let checkButton = CircleCheckButton(isEnabled: false)
    
    private let allAgreeLabel = UILabel().then {
        $0.text = "약관 모두 동의하기"
        $0.font = .heading3SemiBold()
        $0.textColor = .gray800
    }
    
    private let termsLabel = UILabel().then {
        $0.text = "그로우잇 이용약관"
        $0.font = .detail1Medium()
        $0.textColor = .gray400
    }
    
    let termsTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.register(TermsAgreeTableViewCell.self, forCellReuseIdentifier: TermsAgreeTableViewCell.identifier)
        $0.tag = 0
    }
    
    private let termsLabel2 = UILabel().then {
        $0.text = "그로우잇 이용약관"
        $0.font = .detail1Medium()
        $0.textColor = .gray400
    }
    
    let termsOptTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.register(TermsAgreeOptionalTableViewCell.self, forCellReuseIdentifier: TermsAgreeOptionalTableViewCell.identifier)
        $0.tag = 1
    }
    
    let nextButton = AppButton(title: "다음으로", titleColor: .gray400).then {
        $0.backgroundColor = .gray100
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .white
        addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
        }
        
        addSubview(allAgreeView)
        allAgreeView.snp.makeConstraints { make in
            make.leading.equalTo(topLabel.snp.leading)
            make.centerX.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom).offset(28)
            make.height.equalTo(60)
        }
        
        allAgreeView.addSubview(checkButton)
        checkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        allAgreeView.addSubview(allAgreeLabel)
        allAgreeLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
        
        addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.leading.equalTo(allAgreeView.snp.leading)
            make.top.equalTo(allAgreeView.snp.bottom).offset(16)
        }
        
        addSubview(termsTableView)
        termsTableView.snp.makeConstraints { make in
            make.top.equalTo(termsLabel.snp.bottom).offset(4)
            make.leading.equalTo(termsLabel.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(240)
        }
        
        addSubview(termsLabel2)
        termsLabel2.snp.makeConstraints { make in
            make.leading.equalTo(termsTableView.snp.leading)
            make.top.equalTo(termsTableView.snp.bottom).offset(24)
        }
        
        addSubview(termsOptTableView)
        termsOptTableView.snp.makeConstraints { make in
            make.leading.equalTo(termsLabel2.snp.leading)
            make.top.equalTo(termsLabel2.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(120)
        }
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(termsOptTableView.snp.leading)
            make.top.equalTo(termsOptTableView.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
    }
    
}
