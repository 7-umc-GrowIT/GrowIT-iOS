//
//  PurchaseButton.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import Foundation
import UIKit
import SnapKit


class PurchaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var creditIcon = UIImageView().then {
        $0.image = UIImage(named: "GrowIT_Credit_Glow")
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var creditLabel = UILabel().then {
        $0.text = "120"
        $0.textColor = UIColor.primaryColor400!
        $0.font = UIFont.heading2Bold()
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var purchaseLabel = UILabel().then {
        $0.text = "구매하기"
        $0.textColor = UIColor.white
        $0.font = UIFont.heading2Bold()
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var buttonContentView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 5
        $0.distribution = .fill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private func configure() {
        creditIcon.snp.makeConstraints {
            $0.width.equalTo(23)
            $0.height.equalTo(24)
        }
        
        buttonContentView.addArrangedSubViews([creditIcon, creditLabel, purchaseLabel])
        buttonContentView.setCustomSpacing(10, after: creditLabel)
        
        //버튼 설정
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        
        self.addSubview(buttonContentView)
        buttonContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.configuration = config
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
