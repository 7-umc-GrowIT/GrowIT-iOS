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
    
    //MARK: - UI Components
    private let rect1 = UIView().then {
        $0.backgroundColor = .primary50
        $0.layer.cornerRadius = 20
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
    
    private let rect2 = UIView().then {
        $0.backgroundColor = .primary50
        $0.layer.cornerRadius = 20
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
    
    private let rect3 = UIView().then {
        $0.backgroundColor = .primary50
        $0.layer.cornerRadius = 20
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
        
        addArrangedSubview(rect1)
        addArrangedSubview(rect2)
        addArrangedSubview(rect3)
        
    }

}
