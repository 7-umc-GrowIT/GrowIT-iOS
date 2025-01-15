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
    var showCredit: Bool = true {
        didSet {
            updateUI()
        }
    }
    var title: String = "구매하기" {
        didSet {
            updateUI()
        }
    }
    var credit: String = "0" {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Init
    init(showCredit: Bool = true, title: String = "구매하기", credit: String = "0") {
        self.showCredit = showCredit
        self.title = title
        self.credit = credit
        super.init(frame: .zero)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var creditIcon = UIImageView().then {
        $0.image = UIImage(named: "GrowIT_Credit_Glow")
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.snp.makeConstraints {
            $0.width.equalTo(23)
            $0.height.equalTo(24)
        }
    }
    
    private lazy var creditLabel = UILabel().then {
        $0.textColor = UIColor.primaryColor400!
        $0.font = UIFont.heading2Bold()
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var purchaseLabel = UILabel().then {
        $0.text = title
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
        if showCredit {
            buttonContentView.addArrangedSubViews([creditIcon, creditLabel])
            buttonContentView.setCustomSpacing(10, after: creditLabel)
        }
        buttonContentView.addArrangedSubview(purchaseLabel)
        
        
        
        self.addSubview(buttonContentView)
        buttonContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        //버튼 설정
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        self.configuration = config
        self.layer.cornerRadius = 16
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // 버튼과 서브뷰 터치 설정
        self.isUserInteractionEnabled = true
        buttonContentView.isUserInteractionEnabled = false
        creditIcon.isUserInteractionEnabled = false
        creditLabel.isUserInteractionEnabled = false
        purchaseLabel.isUserInteractionEnabled = false
        
        updateUI()
    }
    
    // MARK: - UI 업데이트
    func updateUI() {
        creditLabel.text = "\(credit)"
        purchaseLabel.text = title
        
        if showCredit {
            creditIcon.isHidden = false
            creditLabel.isHidden = false
        } else {
            creditIcon.isHidden = true
            creditLabel.isHidden = true
        }
    }
}
