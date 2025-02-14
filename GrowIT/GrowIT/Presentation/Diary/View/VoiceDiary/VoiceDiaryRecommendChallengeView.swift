//
//  VoiceDiaryRecommendChallengeView.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiaryRecommendChallengeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 그라데이션 적용
        setGradient(color1: .gray700, color2: .gray900)
    }
    
    //MARK: - UI Components
    private let recommendLabel = UILabel().then {
        $0.text = "현재 감정에 맞는\n챌린지를 추천할게요"
        $0.numberOfLines = 0
        $0.font = .subTitle1()
        $0.textColor = .white
    }
    
    private let emoLabel = UILabel().then {
        $0.text = "오늘의 감정 키워드"
        $0.font = .body1Medium()
        $0.textColor = .gray100
    }
    
    private let emoStackView = EmoStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .equalSpacing
        $0.backgroundColor = .clear
        $0.configure(rectColor: UIColor(hex: "0B0B11")!.withAlphaComponent(0.5), titleColor: .primary200)
    }
    
    let challengeStackView = VoiceDiaryhallengeStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
        $0.distribution = .equalSpacing
        $0.backgroundColor = .clear
        $0.configure(rectColor: .black, textColor: .white, clockColor: .primary400)
    }
    
    let saveButton = AppButton(title: "챌린지 저장하기").then {
        $0.setButtonState(isEnabled: false, enabledColor: .primary400, disabledColor: .gray700, enabledTitleColor: .black, disabledTitleColor: .gray400)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "선택한 챌린지만 보관함으로 이동해요"
        $0.font = .body2Medium()
        $0.textColor = .gray400
    }
    
    private let toolTip = ToolTipView()
    
    //MARK: - Setup UI
    private func setupUI() {
        addSubview(recommendLabel)
        recommendLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
        }
        
        addSubview(emoLabel)
        emoLabel.snp.makeConstraints { make in
            make.leading.equalTo(recommendLabel.snp.leading)
            make.top.equalTo(recommendLabel.snp.bottom).offset(28)
        }
        
        addSubview(emoStackView)
        emoStackView.snp.makeConstraints { make in
            make.leading.equalTo(emoLabel.snp.leading)
            make.top.equalTo(emoLabel.snp.bottom).offset(8)
        }
        
        addSubview(toolTip)
        toolTip.snp.makeConstraints { make in
            make.top.equalTo(emoStackView.snp.bottom).offset(24)
            make.height.equalTo(47)
            make.centerX.equalToSuperview()
        }
        
        addSubview(challengeStackView)
        challengeStackView.snp.makeConstraints { make in
            make.leading.equalTo(emoStackView.snp.leading)
            make.top.equalTo(toolTip.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(challengeStackView.snp.bottom).offset(58)
            make.leading.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(saveButton.snp.bottom).offset(8)
        }
    }
    
    
    
}
