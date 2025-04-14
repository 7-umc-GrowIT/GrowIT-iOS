//
//  ChallengeCompleteView.swift
//  GrowIT
//
//  Created by 허준호 on 1/27/25.
//

import UIKit
import Then
import SnapKit

class ChallengeCompleteView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addStack()
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Property
    
    private lazy var grabberIcon = makeIcon(name: "grabberIcon")
    
    private lazy var scrollView = UIScrollView(frame: self.bounds).then{
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.contentOffset = CGPoint(x: 0, y: 0)
        $0.contentSize = contentView.bounds.size
    }
    
    private lazy var contentView = UIView().then{
        $0.backgroundColor = .clear
    }
    private lazy var titleIcon = makeIcon(name: "challengeCompleteIcon")
    
    private lazy var title = makeLabel(title: "챌린지 인증완료!", color: .primary600, font: .heading1Bold()).then{
        $0.textAlignment = .left
    }
    
    private lazy var challengeLabel = makeLabel(title: "어떤 챌린지인가요?", color: .gray900, font: .heading3Bold())
    
    private lazy var challengeContainer = makeContainer(radius: 20)
    
    private lazy var challengeIcon = makeIcon(name: "challengeListIcon")
    
    private lazy var challengeName = makeLabel(title: "", color: .gray900, font: .heading3Bold())
    
    private lazy var clockIcon = makeIcon(name: "timeIcon")
    
    private lazy var challengeTime = makeLabel(title: "", color: .primary600, font: .body2Medium())
    
    private lazy var challengeVerifyDate = makeLabel(title: "", color: .gray500, font: .body2Medium()).then{
        $0.textAlignment = .right
    }
    
    private lazy var imageLabel = makeLabel(title: "챌린지 인증샷", color: .gray900, font: .heading3Bold())
    
    public lazy var imageContainer = UIImageView().then{
        $0.image = UIImage()
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var reviewLabel = makeLabel(title: "챌린지 한줄소감", color: .gray900, font: .heading3Bold())
    
    public lazy var reviewContainer = UITextView().then{
        $0.text = ""
        $0.textColor = .gray900
        $0.font = .body1Medium()
        $0.backgroundColor = .white
        $0.isScrollEnabled = false
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        $0.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        $0.returnKeyType = .done
        $0.setLineSpacing(spacing: 8, font: .body1Medium(), color: .gray900)
    }
    
    private lazy var reviewHintText = makeLabel(title: "챌린지 한줄소감을 50자 이상 적어 주세요", color: .gray500, font: .detail2Regular())
    
    public lazy var challengeExitButton = makeButton(title: "나가기", textColor: .gray400, bgColor: .gray100)
    
    public lazy var challengeUpdateButton = AppButton(title: "수정하기", titleColor: .gray400, isEnabled: false,  icon: "").then{
        $0.backgroundColor = .gray100
    }
    
    
    // MARK: - Stack
    private lazy var titleStack = makeStack(axis: .vertical, spacing: 8)
    
    private lazy var challengeStack = makeStack(axis: .vertical, spacing: 8)
    
    public lazy var imageStack = makeStack(axis: .vertical, spacing: 8)
    
    private lazy var reviewStack = makeStack(axis: .vertical, spacing: 8)
    
    private lazy var buttonStack = makeStack(axis: .horizontal, spacing: 8).then{
        $0.distribution = .fillEqually
    }
    
    private lazy var challengeCompleteStack = makeStack(axis: .vertical, spacing: 0)
    
    // MARK: - Func
    
    private func makeIcon(name: String) -> UIImageView {
        let icon = UIImageView()
        icon.image = UIImage(named: name)
        icon.contentMode = .scaleAspectFit
        return icon
    }
    
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
    
    private func makeContainer(radius: Double) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.borderWidth = 1
        return view
    }
    
    private func makeButton(title:String, textColor: UIColor, bgColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = .heading2Bold()
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 16
        return button
    }
    
    public func setupChallenge(challenge: ChallengeDTO){
        challengeName.text = challenge.title
        challengeTime.text = challenge.time.formattedTime
        reviewContainer.text = challenge.thoughts
        reviewContainer.setLineSpacing(spacing: 4, font: .body1Medium(), color: .gray900)
        var dateList : [String] = []
        let fullDate = challenge.certificationDate.split(separator: "T")[0]
        fullDate.split(separator: "-").forEach { (element) in
            dateList.append(String(element))
        }
        
        challengeVerifyDate.text = dateList[0] + "년 " + dateList[1] + "월 " + dateList[2] + "일 인증"
    }
    
    public func updateImage(image: UIImage){
        imageContainer.image = image
        imageContainer.contentMode = .scaleAspectFill
    }
    
    public func setUpdateBtnActivate(_ activate: Bool){
        challengeUpdateButton.setButtonState(isEnabled: activate, enabledColor: .black, disabledColor: .gray100, enabledTitleColor: .white, disabledTitleColor: .gray400)
        self.layoutIfNeeded()
    }
    
    public func validateTextView(errorMessage: String, textColor: UIColor, bgColor:UIColor, borderColor: UIColor, hintColor: UIColor){
        reviewHintText.text = errorMessage
        reviewHintText.textColor = hintColor
        reviewLabel.textColor = textColor
        reviewContainer.textColor = textColor
        reviewContainer.backgroundColor = bgColor
        reviewContainer.layer.borderColor = borderColor.cgColor
    }
    
    // MARK: - addFunc & Constraints
    
    private func addStack(){
        [challengeLabel, challengeContainer, challengeVerifyDate].forEach(challengeStack.addArrangedSubview)
        [imageLabel, imageContainer].forEach(imageStack.addArrangedSubview)
        [reviewLabel, reviewContainer].forEach(reviewStack.addArrangedSubview)
        [challengeExitButton, challengeUpdateButton].forEach(buttonStack.addArrangedSubview)
        [titleIcon, title, challengeStack, imageStack, reviewStack, reviewHintText, buttonStack].forEach(challengeCompleteStack.addArrangedSubview)
    }
    
    private func addComponents(){
        self.addSubview(scrollView)
        [grabberIcon, titleIcon, title, challengeStack, imageStack, reviewStack, reviewHintText, buttonStack].forEach(contentView.addSubview)
        scrollView.addSubview(contentView)
        [challengeIcon, challengeName, clockIcon, challengeTime].forEach(challengeContainer.addSubview)
    }
    
    private func constraints(){
        
        
        
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
            
        }
        
        grabberIcon.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4)
            $0.width.equalTo(80)
        }
        
        titleIcon.snp.makeConstraints{
            $0.top.equalTo(grabberIcon.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.width.height.equalTo(28)
        }
        
        
        title.snp.makeConstraints{
            $0.top.equalTo(titleIcon.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
        }
        
        challengeIcon.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview().inset(30)
            $0.left.equalToSuperview().offset(24)
            $0.width.height.equalTo(40)
        }
        
        challengeName.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24.5)
            $0.left.equalTo(challengeIcon.snp.right).offset(12)
        }
        
        clockIcon.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(24.5)
            $0.left.equalTo(challengeIcon.snp.right).offset(12)
            $0.width.height.equalTo(16)
        }
        
        challengeTime.snp.makeConstraints{
            $0.top.equalTo(clockIcon.snp.top)
            $0.left.equalTo(clockIcon.snp.right).offset(4)
        }
        
        challengeStack.snp.makeConstraints{
            $0.top.equalTo(title.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        imageContainer.snp.makeConstraints{
            $0.width.height.equalTo(140)
        }
        
        imageStack.snp.makeConstraints{
            $0.top.equalTo(challengeStack.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(24)
        }
        
        reviewContainer.snp.makeConstraints{
            $0.height.equalTo(140)
        }
        
        reviewStack.snp.makeConstraints{
            $0.top.equalTo(imageStack.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        reviewHintText.snp.makeConstraints {
            $0.left.equalToSuperview().offset(24)
            $0.top.equalTo(reviewStack.snp.bottom).offset(4)
        }
        
        buttonStack.snp.makeConstraints{
            $0.top.equalTo(reviewHintText.snp.bottom).offset(40)
            //$0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
}
