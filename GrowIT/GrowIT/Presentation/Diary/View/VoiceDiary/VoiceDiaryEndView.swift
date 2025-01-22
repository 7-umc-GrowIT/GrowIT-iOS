//
//  TextDiaryEndView.swift
//  GrowIT
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class VoiceDiaryEndView: UIView {

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
    private let endLabel = UILabel().then {
        $0.text = "일기 작성을 완료했어요\n크레딧을 지급할게요!"
        $0.font = .subTitle1()
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    let nextButton = AppButton(title: "지금 바로 챌린지하러 가기", titleColor: .white).then {
        $0.setButtonState(isEnabled: true, enabledColor: .primary400, disabledColor: .gray100, enabledTitleColor: .black, disabledTitleColor: .gray400)
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        backgroundColor = .white
        addSubview(endLabel)
        endLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
