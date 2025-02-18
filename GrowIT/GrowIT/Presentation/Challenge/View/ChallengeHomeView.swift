//
//  ChallengHomeView.swift
//  GrowIT
//
//  Created by 허준호 on 1/20/25.
//

import UIKit
import Then
import SnapKit

class ChallengeHomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    private lazy var titleLabel = UILabel().then{
        $0.text = "챌린지"
        $0.textColor = .grayColor900
        $0.font = .title1Bold()
    }
    
    private lazy var settingBtn = UIImageView().then {
        $0.image = UIImage(named: "setting")
        $0.contentMode = .scaleAspectFit
    }
    
    public lazy var challengeHomeBtn = makeButton(title: "홈")
    
    public lazy var challengeStatusBtn = makeButton(title: "챌린지 현황")
    
    public lazy var challengeSegmentUnderline = UIView().then{
        $0.backgroundColor = .primary600
        $0.layer.shouldRasterize = false
        $0.clipsToBounds = true
    }
    
    private lazy var divideLine = UIView().then{
        $0.backgroundColor = .black.withAlphaComponent(0.1)
    }
    
    // MARK: - Stack
    private lazy var challengeHomeNavbar = makeStack(axis: .horizontal, spacing: 0)
    
    private lazy var segmentBtnStack = makeStack(axis: .horizontal, spacing:24)
    
    // MARK: - Func
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    private func makeButton(title:String) -> UIButton {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = .heading2SemiBold()
        return button
    }
    
    
    // MARK: - Property
    private func addComponents(){
        [challengeHomeNavbar, segmentBtnStack, challengeSegmentUnderline, divideLine].forEach(self.addSubview)
        [titleLabel, settingBtn].forEach(challengeHomeNavbar.addArrangedSubview)
        [challengeHomeBtn, challengeStatusBtn].forEach(segmentBtnStack.addArrangedSubview)
    }
    
    private func constraints(){
        
        challengeHomeNavbar.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalToSuperview().multipliedBy(0.07)
        }
        
        segmentBtnStack.snp.makeConstraints {
            $0.top.equalTo(challengeHomeNavbar.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(24)
        }
        
        challengeSegmentUnderline.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.width.equalTo(3)
            $0.top.equalTo(segmentBtnStack.snp.bottom)
            $0.left.equalTo(segmentBtnStack.snp.left)
        }
        
        divideLine.snp.makeConstraints{
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(challengeSegmentUnderline.snp.bottom)
        }
    }
    
    func updateUnderlinePosition(button: UIButton, animated: Bool) {
        let titleLabel = button.titleLabel!
        titleLabel.sizeToFit() // titleLabel의 크기를 콘텐츠에 맞게 조정
        
        challengeSegmentUnderline.snp.remakeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(15)
            $0.height.equalTo(2)
            $0.centerX.equalTo(titleLabel.snp.centerX)
            $0.width.equalTo(titleLabel.snp.width)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded() // 애니메이션 효과 추가
                self.challengeSegmentUnderline.setNeedsDisplay()
            }
        } else {
            self.layoutIfNeeded() // 애니메이션 없이 레이아웃 업데이트
            self.challengeSegmentUnderline.setNeedsDisplay()
        }
    }
    
}
