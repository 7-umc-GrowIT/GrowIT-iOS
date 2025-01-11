//
//  AppButton.swift
//  GrowIT
//
//  Created by 이수현 on 1/11/25.
//

import UIKit
import SnapKit

class AppButton: UIButton {

    init(
        title: String = "",
        titleColor: UIColor = .black,
        isEnabled: Bool = true
    ) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = isEnabled ? UIColor.primary400 : UIColor.primary50
        
        self.titleLabel?.font = UIFont.heading2Bold()
        self.layer.cornerRadius = 16
        
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, titleColor: UIColor, isEnabled: Bool) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = isEnabled ? UIColor.primary400 : UIColor.primary50
    }
    
    func isEnabled(isEnabled: Bool){
        self.backgroundColor = isEnabled ? UIColor.primary400 : UIColor.primary50
    }
}