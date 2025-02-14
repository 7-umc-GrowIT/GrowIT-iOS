//
//  CustomChallengeList.swift
//  GrowIT
//
//  Created by 허준호 on 1/23/25.
//

import UIKit
import Then
import SnapKit

class CustomChallengeListCell: UICollectionViewCell{
    static let identifier: String = "CustomChallengeList"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        addStack()
        addComponent()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    private lazy var box = UIView().then{
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        $0.layer.masksToBounds = true
        
    }
    
    private lazy var icon = UIImageView().then{
        $0.image = UIImage(named: "challengeListIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    public lazy var name = UILabel().then{
        $0.text = ""
        $0.textColor = .gray900
        $0.font = .heading3Bold()
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.adjustsFontSizeToFitWidth = true
        $0.minimumScaleFactor = 0.5
    }
    
    private lazy var clock = UIImageView().then{
        $0.image = UIImage(named: "timeIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var time = UILabel().then{
        $0.text = ""
        $0.textColor = .primary600
        $0.font = .body2Medium()
    }
    
    
    private lazy var buttonContainer = UIView().then{
        $0.backgroundColor = .negative50
        $0.layer.cornerRadius = 16
    }
    
    private lazy var buttonLabel = UILabel().then{
        $0.text = ""
        $0.textColor = .negative400
        $0.font = .detail1Medium()
        $0.adjustsFontSizeToFitWidth = true
    }

    // MARK: - Stack
    private lazy var timeStack = makeStack(axis: .horizontal, spacing: 4)
    
    
    // MARK: - Func
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .fillProportionally
        return stackView
    }
    
    // MARK: - addFunc & Constraints
    
    private func addStack(){
        [clock, time].forEach(timeStack.addArrangedSubview)
    }
    
    private func addComponent(){
        [box].forEach(self.addSubview)
        
        [icon, name, timeStack, buttonContainer].forEach(box.addSubview)
        buttonContainer.addSubview(buttonLabel)
    }
    
    private func constraints(){
        box.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview()
            //$0.top.equalToSuperview().offset(8)
            //$0.height.equalTo(100)
        }
        
        icon.snp.makeConstraints{
            //$0.top.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.width.height.equalTo(40)
        }
        
        name.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24.5)
            $0.left.equalTo(icon.snp.right).offset(12)
            //$0.right.equalTo(buttonContainer.snp.left).inset(15)
            //$0.bottom.equalTo(timeStack.snp.top).inset(8)
            $0.width.equalToSuperview().multipliedBy(0.5)
            //$0.height.greaterThanOrEqualToSuperview().multipliedBy(0.22)
        }
        
        timeStack.snp.makeConstraints{
            $0.top.equalTo(name.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(24.5)
            $0.left.equalTo(icon.snp.right).offset(12)
        }
        
        buttonContainer.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
            $0.width.equalToSuperview().multipliedBy(0.222)
            $0.height.equalToSuperview().multipliedBy(0.32)
        }
        
        buttonLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.623)
        }
        
    }
    
    public func figure(challenge: UserChallenge){
        self.name.text = challenge.title
        self.time.text = challenge.time.formattedTime
       
        var width: CGFloat = 0.0
        var textWidth: CGFloat = 0.0
        
        if(challenge.completed){
            self.buttonLabel.text = "인증 완료"
            self.buttonLabel.textColor = .positive400
            self.buttonContainer.backgroundColor = .positive50
            width = 0.196
            textWidth = 0.573
        }else{
            self.buttonLabel.text = "인증 미완료"
            self.buttonLabel.textColor = .negative400
            self.buttonContainer.backgroundColor = .negative50
            width = 0.222
            textWidth = 0.623
        }
        
        buttonContainer.snp.remakeConstraints{
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
            $0.width.equalToSuperview().multipliedBy(width)
            $0.height.equalToSuperview().multipliedBy(0.32)
        }
        
        buttonLabel.snp.remakeConstraints{
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(textWidth)
        }
    }
}
