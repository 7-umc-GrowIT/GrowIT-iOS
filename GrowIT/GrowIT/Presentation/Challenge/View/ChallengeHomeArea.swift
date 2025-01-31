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

        addStacdk()
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    private lazy var bg = UIView().then{
        $0.backgroundColor = .red
    }
  
    private lazy var title = makeLabel(title: "오늘의 챌린지 추천", color: .black, font: .heading1Bold())

    private lazy var subTitle = makeLabel(title: "나의 심리 정보를 기반으로 챌린지를 추천해요", color: .gray500, font: .body2Medium())

    private lazy var todayChallengeBox = makeContainer()
        
    
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
        
        $0.setTitle("인증하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .body2Medium()
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.backgroundColor = .black
        
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.body2Medium() // 폰트를 적절하게 설정
            return outgoing
        }
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 16, bottom: 7, trailing: 16)
        
        $0.configuration = configuration
        $0.clipsToBounds = true
    }
    
    private lazy var challengeReportTitle = makeLabel(title: "그로의 챌린지 리포트", color: .black, font: .heading1Bold())
    
    private lazy var challengeReportSubTitle = makeLabel(title: "그로우잇과 얼마나 성장했는지 확인해 보세요!", color: .gray500, font: .body2Medium())
    
    private lazy var creditNumberContainer = makeContainer()
    
    private lazy var creditNumLabel = makeLabel(title: "총 크레딧 수", color: .gray500, font: .body2Medium()).then{
        $0.textAlignment = .center
    }
    
    private lazy var creditNumIcon = UIImageView().then{
        $0.image = UIImage(named: "creditNumIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var creditNum = makeLabel(title: "1200", color: .gray900, font: .heading2Bold())
    
    private lazy var writtenDiaryLabel = makeLabel(title: "작성된 일기 수", color: .gray500, font: .body2Medium()).then{
        $0.textAlignment = .center
    }
    
    private lazy var writtenDiaryIcon = UIImageView().then{
        $0.image = UIImage(named: "challengeListIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var writtenDiaryNumContainer = makeContainer()
    
    private lazy var writtenDiaryNum = makeLabel(title: "15", color: .gray900, font: .heading2Bold())
    
    private lazy var dayPlusLabel = makeLabel(title: "(D+15)", color: .gray400, font: .body2Medium())
    
    // MARK: - Stack
    private lazy var titleStack = makeStack(axis: .vertical, spacing: 4)
    
    private lazy var hashTagStack = makeStack(axis: .horizontal, spacing: 8)
    
    private lazy var todayChallengeTimeStack = makeStack(axis: .horizontal, spacing: 4)
    
    private lazy var challengeReportTitleStack = makeStack(axis: .vertical, spacing: 4)
    
    private lazy var creditNumStack1 = makeStack(axis: .horizontal, spacing: 4)
    
    private lazy var creditNumStack2 = makeStack(axis: .vertical, spacing: 8)
    
    private lazy var writtenDiaryStack1 = makeStack(axis: .horizontal, spacing: 4)
    
    private lazy var writtenDiaryStack2 = makeStack(axis: .vertical, spacing: 8)
    
    private lazy var challengeReportContainerStack = makeStack(axis: .horizontal, spacing: 8).then{
        $0.distribution = .fillEqually
    }
    
    // MARK: - Func
    
    private func makeLabel(title:String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = font
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        return stackView
    }
    
    private func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        return view
    }
    private func makeChallengeHashTagButton(title: String) -> UIButton {
        let button = UIButton()
        
        var configuration = UIButton.Configuration.plain()
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(.primary700, for: .normal)
        //button.titleLabel?.font = .body2SemiBold()
        button.backgroundColor = .primary100
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        button.layer.masksToBounds = true
        
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.body2SemiBold() // 폰트를 적절하게 설정
            return outgoing
        }
        configuration.contentInsets = .init(top: 6, leading: 16, bottom: 6, trailing: 16)
        
        button.configuration = configuration
        return button
    }
    
    // MARK: - addFunction & Constraints
    
    private func addStacdk(){
        [title, subTitle].forEach(titleStack.addArrangedSubview)
        hashTagNames.forEach{
            let button = makeChallengeHashTagButton(title: $0)
            hashTagStack.addArrangedSubview(button)
        }
        [todayChallengeTimeIcon, todayChallengeTimeLabel].forEach(todayChallengeTimeStack.addArrangedSubview)
        [challengeReportTitle, challengeReportSubTitle].forEach(challengeReportTitleStack.addArrangedSubview)
        [creditNumIcon, creditNum].forEach(creditNumStack1.addArrangedSubview)
        [creditNumLabel, creditNumStack1].forEach(creditNumStack2.addArrangedSubview)
        [writtenDiaryIcon, writtenDiaryNum, dayPlusLabel].forEach(writtenDiaryStack1.addArrangedSubview)
        [writtenDiaryLabel, writtenDiaryStack1].forEach(writtenDiaryStack2.addArrangedSubview)
        [creditNumberContainer, writtenDiaryNumContainer].forEach(challengeReportContainerStack.addArrangedSubview)
    }
    
    private func addComponents(){
        [titleStack, hashTagStack, todayChallengeBox, challengeReportTitleStack, challengeReportContainerStack].forEach(self.addSubview)
        
        [challengeListIcon, todayChallengeTitle, todayChallengeTimeStack, todayChallengeVerifyBtn].forEach(todayChallengeBox.addSubview)
        
        creditNumberContainer.addSubview(creditNumStack2)
        writtenDiaryNumContainer.addSubview(writtenDiaryStack2)
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
            $0.verticalEdges.equalToSuperview().inset(30)
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
        
        challengeReportTitleStack.snp.makeConstraints{
            $0.top.equalTo(todayChallengeBox.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
        }
        creditNumIcon.snp.makeConstraints{
            $0.height.width.equalTo(28)
        }
        
        writtenDiaryIcon.snp.makeConstraints{
            $0.height.width.equalTo(28)
        }
        
        creditNumStack2.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        writtenDiaryStack2.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        challengeReportContainerStack.snp.makeConstraints {
            $0.top.equalTo(challengeReportTitleStack.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }

}
