//
//  GroSelectBackgroundView.swift
//  GrowIT
//
//  Created by 오현민 on 1/7/25.
//

import UIKit
import Then

class GroView: UIView {
    private lazy var backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "GrowIT_Background_Star")
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Todo: 애니메이션 추가
    private lazy var groImageView = UIImageView().then {
        $0.image = UIImage(named: "GrowIT_Gro")
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 캐릭터 확대/축소 버튼
    private lazy var zoomButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = UIImage(named: "GrowIT_ZoomIn") // Todo: 추후 상태 분기처리
        
        $0.configuration = config
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var eraseButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.baseBackgroundColor = .clear
        config.image = UIImage(named: "GrowIT_Erase")
        
        $0.configuration = config
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    
    public var purchaseButton = PurchaseButton()
    
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
        buttonStackView.addArrangedSubViews([zoomButton, eraseButton])
        self.addSubviews([backgroundImageView, groImageView, buttonStackView, purchaseButton])
    }
    
    //MARK: - 레이아웃 설정
    private func setConstraints() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        groImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(purchaseButton.snp.top).offset(-24)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        zoomButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        eraseButton.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        purchaseButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(60)
        }
        
    }
}
