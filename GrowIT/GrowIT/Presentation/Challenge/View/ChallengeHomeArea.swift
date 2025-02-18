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
    
    private lazy var keywords : [String] = []

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
        
    public lazy var todayChallengeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
        $0.scrollDirection = .horizontal
        //$0.itemSize = CGSize(width: 382, height: 100)
        
    }).then{
        $0.register(TodayChallengeCollectionViewCell.self, forCellWithReuseIdentifier: TodayChallengeCollectionViewCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.isPagingEnabled = true
    }
    private lazy var emptyChallengeIcon = UIImageView().then{
        $0.image = UIImage(named: "diary")
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private lazy var emptyChallengeLabel = makeLabel(title: "오늘의 일기를 작성하고 챌린지를 진행해 보세요!", color: .gray400, font: .detail1Medium()).then{
        $0.isHidden = true
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
    
    private lazy var creditNum = makeLabel(title: "", color: .gray900, font: .heading2Bold())
    
    private lazy var writtenDiaryLabel = makeLabel(title: "작성된 일기 수", color: .gray500, font: .body2Medium()).then{
        $0.textAlignment = .center
    }
    
    private lazy var writtenDiaryIcon = UIImageView().then{
        $0.image = UIImage(named: "challengeListIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var writtenDiaryNumContainer = makeContainer()
    
    private lazy var writtenDiaryNum = makeLabel(title: "", color: .gray900, font: .heading2Bold())
    
    private lazy var diaryDatesLabel = makeLabel(title: "", color: .gray400, font: .body2Medium())
    
    // MARK: - Stack
    public lazy var titleStack = makeStack(axis: .vertical, spacing: 4)
    
    public lazy var hashTagStack = makeStack(axis: .horizontal, spacing: 8)
    
    
    public lazy var challengeReportTitleStack = makeStack(axis: .vertical, spacing: 4)
    
    private lazy var creditNumStack1 = makeStack(axis: .horizontal, spacing: 4)
    
    private lazy var creditNumStack2 = makeStack(axis: .vertical, spacing: 8)
    
    private lazy var writtenDiaryStack1 = makeStack(axis: .horizontal, spacing: 4)
    
    private lazy var writtenDiaryStack2 = makeStack(axis: .vertical, spacing: 8)
    
    private lazy var emptyChallengeStack = makeStack(axis: .vertical, spacing: 16)
    
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
        button.setTitleColor(.primary700, for: .disabled)
        //button.titleLabel?.font = .body2SemiBold()
        button.backgroundColor = .primary100
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        button.layer.masksToBounds = true
        button.isEnabled = false
        
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.body2SemiBold()// 폰트를 적절하게 설정
            return outgoing
        }
        configuration.contentInsets = .init(top: 6, leading: 16, bottom: 6, trailing: 16)
        
        button.configuration = configuration
        return button
    }
    
    public func setupChallengeKeywords(_ values: [String]){
        keywords = values
        
        hashTagStack.arrangedSubviews.forEach { $0.removeFromSuperview() }  // 기존 버튼 제거
        keywords.forEach { keyword in
            let button = makeChallengeHashTagButton(title: keyword)
            hashTagStack.addArrangedSubview(button)  // 새 버튼 추가
        }
    }
    
    public func setupChallengeReport(report: ChallengeReportDTO){
        creditNum.text = "\(report.totalCredits)"
        writtenDiaryNum.text = "\(report.totalDiaries)"
        diaryDatesLabel.text = "(\(report.diaryDate))"
        
    }
    
    public func setEmptyChallenge(){
        todayChallengeCollectionView.isHidden = true
        emptyChallengeIcon.isHidden = false
        emptyChallengeLabel.isHidden = false
        
        challengeReportTitle.snp.updateConstraints{
            $0.top.equalTo(emptyChallengeLabel.snp.bottom).offset(34)
        }
    }
    
    public func showChallenge(){
        todayChallengeCollectionView.isHidden = false
        emptyChallengeIcon.isHidden = true
        emptyChallengeLabel.isHidden = true
    }
    // MARK: - addFunction & Constraints
    
    private func addStacdk(){
        [title, subTitle].forEach(titleStack.addArrangedSubview)
        keywords.forEach{
            let button = makeChallengeHashTagButton(title: $0)
            hashTagStack.addArrangedSubview(button)
        }
        [challengeReportTitle, challengeReportSubTitle].forEach(challengeReportTitleStack.addArrangedSubview)
        [creditNumIcon, creditNum].forEach(creditNumStack1.addArrangedSubview)
        [creditNumLabel, creditNumStack1].forEach(creditNumStack2.addArrangedSubview)
        [writtenDiaryIcon, writtenDiaryNum, diaryDatesLabel].forEach(writtenDiaryStack1.addArrangedSubview)
        [writtenDiaryLabel, writtenDiaryStack1].forEach(writtenDiaryStack2.addArrangedSubview)
        [creditNumberContainer, writtenDiaryNumContainer].forEach(challengeReportContainerStack.addArrangedSubview)
        [emptyChallengeIcon, emptyChallengeLabel].forEach(emptyChallengeStack.addArrangedSubview)
    }
    
    private func addComponents(){
        [titleStack, hashTagStack, todayChallengeCollectionView, emptyChallengeIcon, emptyChallengeLabel, challengeReportTitleStack, challengeReportContainerStack].forEach(self.addSubview)
        
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
        
        todayChallengeCollectionView.snp.makeConstraints{
            $0.top.equalTo(hashTagStack.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            //$0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(100)
            $0.width.equalToSuperview().multipliedBy(0.88)
            //$0.width.equalTo(382)
        }
        
        emptyChallengeIcon.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(53)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(40)
        }
        
        emptyChallengeLabel.snp.makeConstraints{
            $0.top.equalTo(emptyChallengeIcon.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
//        emptyChallengeStack.snp.makeConstraints{
//            $0.top.equalTo(titleStack.snp.bottom).offset(53)
//            $0.centerX.equalToSuperview()
//        }
        
        challengeReportTitleStack.snp.makeConstraints{
            $0.top.equalTo(todayChallengeCollectionView.snp.bottom).offset(32)
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
