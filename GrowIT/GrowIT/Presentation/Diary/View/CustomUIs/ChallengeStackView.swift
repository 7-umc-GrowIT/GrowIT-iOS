//
//  ChallengeStackView.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit
import SnapKit

class ChallengeStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 그라데이션 적용
        rect1.setGradient(color1: .white, color2: .primary50)
        rect2.setGradient(color1: .white, color2: .primary50)
        rect3.setGradient(color1: .white, color2: .primary50)
    }
    
    //MARK: - UI Components
    private let rect1 = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#0000001A")?.cgColor
    }
    
    private let icon1 = UIImageView().then {
        $0.image = UIImage(named: "bath")
        $0.backgroundColor = .clear
    }
    
    private let label1 = UILabel().then {
        $0.text = "반신욕 즐겨보기"
        $0.font = .heading3Bold()
        $0.textColor = .gray900
    }
    
    let button1 = CircleCheckButton(isEnabled: false)
    
    private let clockIcon1 = UIImageView().then {
        $0.image = UIImage(named: "clock")
        $0.backgroundColor = .clear
    }
    
    private let clockLabel1 = UILabel().then {
        $0.text = "1시간"
        $0.font = .body2Medium()
        $0.textColor = .primary600
    }
    
    private let rect2 = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#0000001A")?.cgColor
    }
    
    private let icon2 = UIImageView().then {
        $0.image = UIImage(named: "bath")
        $0.backgroundColor = .clear
    }
    
    private let label2 = UILabel().then {
        $0.text = "반신욕 즐겨보기"
        $0.font = .heading3Bold()
        $0.textColor = .gray900
    }
    
    let button2 = CircleCheckButton(isEnabled: false)
    
    private let clockIcon2 = UIImageView().then {
        $0.image = UIImage(named: "clock")
        $0.backgroundColor = .clear
    }
    
    private let clockLabel2 = UILabel().then {
        $0.text = "1시간"
        $0.font = .body2Medium()
        $0.textColor = .primary600
    }
    
    private let rect3 = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hex: "#0000001A")?.cgColor
    }
    
    private let icon3 = UIImageView().then {
        $0.image = UIImage(named: "bath")
        $0.backgroundColor = .clear
    }
    
    private let label3 = UILabel().then {
        $0.text = "반신욕 즐겨보기"
        $0.font = .heading3Bold()
        $0.textColor = .gray900
    }
    
    let button3 = CircleCheckButton(isEnabled: false)
    
    private let clockIcon3 = UIImageView().then {
        $0.image = UIImage(named: "clock")
        $0.backgroundColor = .clear
    }
    
    private let clockLabel3 = UILabel().then {
        $0.text = "1시간"
        $0.font = .body2Medium()
        $0.textColor = .primary600
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        rect1.addSubview(icon1)
        icon1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        rect1.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.leading.equalTo(icon1.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(24.5)
        }
        
        rect1.addSubview(clockIcon1)
        clockIcon1.snp.makeConstraints { make in
            make.leading.equalTo(label1.snp.leading)
            make.top.equalTo(label1.snp.bottom).offset(10.5)
            make.width.height.equalTo(16)
        }
        
        rect1.addSubview(clockLabel1)
        clockLabel1.snp.makeConstraints { make in
            make.top.equalTo(clockIcon1.snp.top).offset(-2.5)
            make.centerY.equalTo(clockIcon1.snp.centerY)
            make.leading.equalTo(clockIcon1.snp.trailing).offset(4)
        }
        
        rect1.addSubview(button1)
        button1.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        rect2.addSubview(icon2)
        icon2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        rect2.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.leading.equalTo(icon2.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(24.5)
        }
        
        rect2.addSubview(clockIcon2)
        clockIcon2.snp.makeConstraints { make in
            make.leading.equalTo(label2.snp.leading)
            make.top.equalTo(label2.snp.bottom).offset(10.5)
            make.width.height.equalTo(16)
        }
        
        rect2.addSubview(clockLabel2)
        clockLabel2.snp.makeConstraints { make in
            make.top.equalTo(clockIcon2.snp.top).offset(-2.5)
            make.centerY.equalTo(clockIcon2.snp.centerY)
            make.leading.equalTo(clockIcon2.snp.trailing).offset(4)
        }
        
        rect2.addSubview(button2)
        button2.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        rect3.addSubview(icon3)
        icon3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        
        rect3.addSubview(label3)
        label3.snp.makeConstraints { make in
            make.leading.equalTo(icon3.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(24.5)
        }
        
        rect3.addSubview(clockIcon3)
        clockIcon3.snp.makeConstraints { make in
            make.leading.equalTo(label3.snp.leading)
            make.top.equalTo(label3.snp.bottom).offset(10.5)
            make.width.height.equalTo(16)
        }
        
        rect3.addSubview(clockLabel3)
        clockLabel3.snp.makeConstraints { make in
            make.top.equalTo(clockIcon3.snp.top).offset(-2.5)
            make.centerY.equalTo(clockIcon3.snp.centerY)
            make.leading.equalTo(clockIcon3.snp.trailing).offset(4)
        }
        
        rect3.addSubview(button3)
        button3.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
        
        addArrangedSubview(rect1)
        addArrangedSubview(rect2)
        addArrangedSubview(rect3)
        
    }
    
}
