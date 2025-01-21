//
//  ChallengHomeNavbar.swift
//  GrowIT
//
//  Created by 허준호 on 1/20/25.
//

import UIKit
import Then
import SnapKit

class ChallengeHomeArea: UIView {
    
    let hashTagNames : [String] = ["즐거운", "차분한", "새로운"]
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    private lazy var title = makeLabel(title: "오늘의 챌린지 추천", color: .black, font: .heading1Bold())

    private lazy var subTitle = makeLabel(title: "나의 심리 정보를 기반으로 챌린지를 추천해요", color: .gray500, font: .body2Medium())

    private lazy var todayChallengeBox = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
    }
    
    private lazy var challengeListIcon = UIImageView().then{
        $0.image = UIImage(named: "challengeListIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var todayChallengeTitle = makeLabel(title: "좋아하는 책 독서하기", color: .gray900, font: .heading3Bold())
    
    private lazy var todayChallengeTimeIcon = UIImageView().then{
        $0.image = UIImage(named: "timeIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var todayChallengeTimeLabel = makeLabel(title: "1시간", color: .primary600, font: .body2Medium())
    
    private lazy var todayChallengeVerifyBtn = UIButton().then{
        var configuration = UIButton.Configuration.plain()
        
//        $0.setTitle("인증하기", for: .normal)
//        $0.setTitleColor(.white, for: .normal)
//        $0.titleLabel?.font = .detail1Medium()
//        $0.layer.cornerRadius = 12
//        $0.clipsToBounds = true
//        $0.backgroundColor = .black
        var attributeContainer: AttributeContainer = {
            var container = AttributeContainer()
            container.font = .detail1Medium()
            container.foregroundColor = .white
            return container
        }()
        
        configuration.attributedTitle = AttributedString("인증하기", attributes: attributeContainer)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 16, bottom: 7, trailing: 16)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
        
        $0.configuration = configuration
        $0.clipsToBounds = true
    }
    
    // MARK: - Stack
    private lazy var titleStack = makeStack(axis: .vertical, spacing: 4)
    
    private lazy var hashTagStack = makeStack(axis: .horizontal, spacing: 8)
    
    private lazy var todayChallengeTimeStack = makeStack(axis: .horizontal, spacing: 4)
    
    //private lazy var todayChallengeContent = makeStack(axis: .vertical, spacing: 8)
    // MARK: - Func
    
    private func makeLabel(title:String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = font
        return label
    }
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        return stackView
    }
    
    private func makeChallengeHashTagButton(title: String) -> UIButton {
        let button = UIButton()
        
        let configuration = UIButton.Configuration.plain()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.primary700, for: .normal)
        button.titleLabel?.font = .body2SemiBold()
        button.backgroundColor = .primary100
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        button.layer.masksToBounds = true
        
        //configuration.contentInsets = .init(top: 6, leading: 16, bottom: 6, trailing: 16)
        
        button.configuration = configuration
        return button
    }
    
    // MARK: - addFunction & Constraints
    
    private func addComponents(){
        [titleStack, hashTagStack, todayChallengeBox].forEach(self.addSubview)
        [title, subTitle].forEach(titleStack.addArrangedSubview)
        hashTagNames.forEach{
            let button = makeChallengeHashTagButton(title: $0)
            hashTagStack.addArrangedSubview(button)
        }
        [challengeListIcon, todayChallengeTitle, todayChallengeTimeStack, todayChallengeVerifyBtn].forEach(todayChallengeBox.addSubview)
        [todayChallengeTimeIcon, todayChallengeTimeLabel].forEach(todayChallengeTimeStack.addArrangedSubview)
        //[todayChallengeTitle, todayChallengeTimeStack].forEach(todayChallengeContent.addArrangedSubview)
    }
    
    private func constraints(){
        
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.left.equalToSuperview().offset(24)
        }
        
        hashTagStack.snp.makeConstraints{
            $0.top.equalTo(titleStack.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(24)
        }
        
        todayChallengeBox.snp.makeConstraints{
            $0.top.equalTo(hashTagStack.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        challengeListIcon.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(32)
            $0.left.equalToSuperview().offset(24)
            $0.width.height.equalTo(40)
        }
        
        todayChallengeTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24.5)
            $0.left.equalTo(challengeListIcon.snp.right).offset(12)
        }
        
        todayChallengeTimeStack.snp.makeConstraints{
            $0.top.equalTo(todayChallengeTitle.snp.bottom).offset(8)
            $0.left.equalTo(challengeListIcon.snp.right).offset(12)
        }
        
        todayChallengeVerifyBtn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
//            $0.width.equalTo(todayChallengeBox.snp.width).multipliedBy(0.2)
//            $0.height.equalTo(todayChallengeBox.snp.height).multipliedBy(0.73)
        }
    }

}
