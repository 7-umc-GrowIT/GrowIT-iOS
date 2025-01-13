//
//  EmoStackView.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit

class EmoStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup UI
    private let rect1 = UIView().then {
        $0.backgroundColor = .primary100
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
    
    private let label1 = UILabel().then {
        $0.text = "즐거운"
        $0.font = .body2SemiBold()
        $0.textColor = .primary700
    }
    
    private let rect2 = UIView().then {
        $0.backgroundColor = .primary100
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
    
    private let label2 = UILabel().then {
        $0.text = "즐거운"
        $0.font = .body2SemiBold()
        $0.textColor = .primary700
    }
    
    private let rect3 = UIView().then {
        $0.backgroundColor = .primary100
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
    
    private let label3 = UILabel().then {
        $0.text = "즐거운"
        $0.font = .body2SemiBold()
        $0.textColor = .primary700
    }
    
    private func setupUI() {
        rect1.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(6)
            make.centerX.centerY.equalToSuperview()
        }
        
        rect2.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(6)
            make.centerX.centerY.equalToSuperview()
        }
        
        rect3.addSubview(label3)
        label3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(6)
            make.centerX.centerY.equalToSuperview()
        }
        
        addArrangedSubview(rect1)
        addArrangedSubview(rect2)
        addArrangedSubview(rect3)
    }
    
}
