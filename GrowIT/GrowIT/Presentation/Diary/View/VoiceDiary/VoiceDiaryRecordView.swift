//
//  VoiceDiaryRecordView.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiaryRecordView: UIView {

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
    
    // MARK: UI Components
    private let label1 = UILabel().then {
        $0.text = "편하게 말해보세요\n당신의 이야기를 듣고 있어요"
        $0.font = .subTitle1()
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private let label2 = UILabel().then {
        $0.text = "대화가 끝났다면 버튼을 눌러주세요"
        $0.font = .heading3SemiBold()
        $0.textColor = .gray100
    }
    
    let endButton = AppButton(title: "대화 마무리하기", titleColor: .black).then {
        $0.backgroundColor = .primary400
    }
    
    let helpLabel = UILabel().then {
        $0.text = "문제가 발생했어요"
        $0.font = .body2Medium()
        $0.textColor = .gray400
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .gray700
        addSubview(label1)
        label1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
        }
        
        addSubview(label2)
        label2.snp.makeConstraints { make in
            make.leading.equalTo(label1.snp.leading)
            make.top.equalTo(label1.snp.bottom).offset(12)
        }
        
        addSubview(endButton)
        endButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-84)
        }
        
        addSubview(helpLabel)
        helpLabel.snp.makeConstraints { make in
            make.top.equalTo(endButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
