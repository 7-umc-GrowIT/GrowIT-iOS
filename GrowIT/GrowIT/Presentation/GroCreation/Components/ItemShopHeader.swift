//
//  ItemShopHeader.swift
//  GrowIT
//
//  Created by 오현민 on 1/7/25.
//

import UIKit

class ItemShopHeader: UIView {
    private lazy var headerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalCentering
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var backButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = UIImage(named: "GrowIT_Back")
        
        $0.configuration = config
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var myItemButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = UIImage(named: "GrowIT_MyItem")
        
        $0.configuration = config
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var creditView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 16
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var creditIcon = UIImageView().then {
        $0.image = UIImage(named: "GrowIT_Credit_Glow_2")
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var creditLabel = UILabel().then {
        $0.text = "1200"
        $0.textColor = UIColor.white
        $0.font = UIFont.heading2Bold()
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 컴포넌트 추가
    private func setView() {
        creditView.addSubviews([creditIcon, creditLabel])
        headerStackView.addArrangedSubViews([backButton, creditView, myItemButton])
        self.addSubview(headerStackView)
    }
    
    //MARK: - 레이아웃 설정
    private func setConstraints() {
        creditIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
        }
        
        creditLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        myItemButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        creditView.snp.makeConstraints {
            $0.width.equalTo(117)
            $0.height.equalTo(48)
        }
        
        headerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
