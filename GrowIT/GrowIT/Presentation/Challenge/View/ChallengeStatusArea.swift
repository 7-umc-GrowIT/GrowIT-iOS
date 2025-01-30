//
//  ChallengStatusArea.swift
//  GrowIT
//
//  Created by 허준호 on 1/22/25.
//

import UIKit
import Then
import SnapKit

class ChallengeStatusArea: UIView {
    
    let challengeStatusCateogry : [String] = ["전체", "완료", "랜덤 챌린지", "데일리 챌린지"]
    
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
    private lazy var challengeAllBtn = makeButton(title: "전체")
    
    private lazy var challengeFinishBtn = makeButton(title: "완료")
    
    private lazy var challengeRandomBtn = makeButton(title: "랜덤 챌린지")
    
    private lazy var challengeDailyBtn = makeButton(title: "데일리 챌린지")
    
    public lazy var challengeStatusBtnGroup = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        $0.minimumInteritemSpacing = 8
        $0.scrollDirection = .horizontal
    }).then{
        $0.backgroundColor = .clear
        $0.register(ChallengeStatusBtnGroupCell.self, forCellWithReuseIdentifier: ChallengeStatusBtnGroupCell.identifier)
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var challengeStatusLabel = makeLabel(title: "챌린지 현황", color: .gray800, font: .body2Medium())
    
    
    public lazy var challengeStatusNum = makeLabel(title: "4", color: .primary700, font: .body2SemiBold())
    
    public lazy var challengeAllList = UITableView(frame: .zero).then{
        $0.register(CustomChallengeListCell.self, forCellReuseIdentifier: CustomChallengeListCell.identifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    // MARK: - Func
    private lazy var challengeStatusBtnStack = makeStack(axis: .horizontal, spacing: 8)
    
    private lazy var challengeStatusLabelStack = makeStack(axis: .horizontal, spacing: 4)
    
    // MARK: - Func
    
    private func makeLabel(title:String, color: UIColor, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = font
        return label
    }
    
    private func makeButton(title:String) -> UIButton{
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.gray300, for: .normal)
        button.titleLabel?.font = .heading3SemiBold()
        button.titleLabel?.numberOfLines = 1
        button.layer.cornerRadius = 6
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        
        return button
    }
    
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .fillProportionally
        return stackView
    }
    
    public func statusBtnTapped(){
        
    }
    
    // MARK: - addFunc & Constraints
    
    private func addStack(){
        [challengeAllBtn, challengeFinishBtn, challengeRandomBtn, challengeDailyBtn].forEach(challengeStatusBtnStack.addArrangedSubview)
        
        [challengeStatusLabel, challengeStatusNum].forEach(challengeStatusLabelStack.addArrangedSubview)
    }
    
    private func addComponents(){
        [challengeStatusBtnGroup, challengeStatusLabelStack, challengeAllList].forEach(self.addSubview)
    }
    
    private func constraints(){
        
        challengeStatusBtnGroup.snp.makeConstraints{
            $0.top.equalToSuperview().offset(28)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(40)
            $0.right.greaterThanOrEqualToSuperview()
        }
        
        challengeStatusLabelStack.snp.makeConstraints{
            $0.top.equalTo(challengeStatusBtnGroup.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(24)
        }
        
        challengeAllList.snp.makeConstraints{
            $0.top.equalTo(challengeStatusLabelStack.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(65)
        }
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let flowLayout = challengeStatusBtnGroup.collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpacing = flowLayout.minimumInteritemSpacing * CGFloat(challengeStatusCateogry.count - 1)
            let itemWidth = (challengeStatusBtnGroup.bounds.width - totalSpacing) / CGFloat(challengeStatusCateogry.count)
            flowLayout.itemSize = CGSize(width: itemWidth, height: 40)
        }
    }
}
