//
//  CustomChallengeList.swift
//  GrowIT
//
//  Created by 허준호 on 1/23/25.
//

import UIKit
import Then
import SnapKit

class CustomChallengeListCell: UITableViewCell{
    static let identifier: String = "CustomChallengeList"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        addStack()
        addComponent()
        constraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        self.name.text = nil
//        self.time.text = nil
//        self.button.titleLabel?.text = nil
        
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
    
    private lazy var name = UILabel().then{
        $0.text = "좋아하는 책 독서하기"
        $0.textColor = .gray900
        $0.font = .heading3Bold()
        $0.adjustsFontSizeToFitWidth = true
    }
    
    private lazy var clock = UIImageView().then{
        $0.image = UIImage(named: "timeIcon")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var time = UILabel().then{
        $0.text = "1시간"
        $0.textColor = .primary600
        $0.font = .body2Medium()
    }
    
    
    private lazy var button = UIButton().then{
        $0.setTitle("인증 미완료", for: .normal)
        $0.setTitleColor(.negative400, for: .normal)
        //$0.titleLabel?.font = .detail1Medium()
        $0.backgroundColor = .negative50
        $0.layer.cornerRadius = 16
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        
        var configuration = UIButton.Configuration.plain()
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.detail1Medium() // 폰트를 적절하게 설정
            return outgoing
        }
        configuration.contentInsets = .init(top: 7, leading: 16, bottom: 7, trailing: 16)
        $0.configuration = configuration
        $0.clipsToBounds = true
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
        
        [icon, name, timeStack, button].forEach(box.addSubview)
    }
    
    private func constraints(){
        box.snp.makeConstraints{
            $0.horizontalEdges.equalToSuperview()
            //$0.top.equalToSuperview().offset(8)
            $0.height.equalTo(100)
        }
        
        icon.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview().inset(30)
            $0.left.equalToSuperview().offset(24)
            $0.width.height.equalTo(40)
        }
        
        name.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24.5)
            $0.left.equalTo(icon.snp.right).offset(12)
        }
        
        timeStack.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(24.5)
            $0.left.equalTo(icon.snp.right).offset(12)
        }
        
        button.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(24)
//            $0.height.equalTo(32)
//            $0.width.equalTo(85)
        }
    }
    
    public func figure(status: String){
        if(status == "완료"){
            self.button.setTitle("인증 완료", for: .normal)
            self.button.setTitleColor(.positive400, for: .normal)
            self.button.backgroundColor = .positive50
        }else{
            self.button.setTitle("인증 미완료", for: .normal)
            self.button.setTitleColor(.negative400, for: .normal)
            self.button.backgroundColor = .negative50
        }
        
    }
}
