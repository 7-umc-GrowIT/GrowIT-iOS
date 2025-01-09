//
//  HomeCharacterView.swift
//  GrowIT
//
//  Created by 허준호 on 1/9/25.
//

import UIKit

class HomeCharacterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "homeBg")
        
        addStackView()
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    // 배경 별그림
    private lazy var backgroundStar = UIImageView().then{
        $0.image = UIImage(named: "homeBgStar")
        $0.contentMode = .scaleToFill
    }
    
    // 크레딧 아이콘
    private lazy var creditIcon = makeIcon("credit")
    
    // 크레딧 개수
    private lazy var creditNum = UILabel().then{
        $0.text = "1개"
        $0.font = UIFont.heading2Bold()
        $0.textColor = .white
    }
    
    // 크레딧 컨테이너
    private lazy var creditContainer = makeContainer()
    
    // 친구보기 버튼 아이콘
    private lazy var friendIcon = makeIcon("friend")
    
    // 친구보기 버튼 컨테이너
    private lazy var friendContainer = makeContainer()
    
    // 캐릭터 이미지
    private lazy var homeCharacter = UIImageView().then{
        $0.image = UIImage(named: "homeCharacter")
        $0.contentMode = .scaleAspectFit
    }
    
    // 캐릭터 그림자
    private lazy var characterShadow = UIImageView().then{
        $0.image = UIImage(named: "shadow")
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Stack
    
    // 크레딧 개수 가로 스택
    private lazy var creditBoxStack = makeStackView(axis: .horizontal, spacing: 12)
    
    
    // MARK: - Function
    
    // 스택뷰 생성 함수(스택 방향, 간격)
    private func makeStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    // 아이콘 생성 함수
    private func makeIcon(_ name:String) -> UIImageView{
        let icon = UIImageView()
        icon.image = UIImage(named: name)
        icon.contentMode = .scaleAspectFit
        return icon
    }
    
    // 크레딧 개수 박스, 친구보기 버튼 박스
    // 공통 컨테이너 박스 생성
    private func makeContainer() -> UIView{
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }
    // MARK: - add Function & Constraints
    
    private func addStackView(){
        [creditIcon, creditNum].forEach(creditBoxStack.addArrangedSubview)
    }
    
    private func addComponents(){
        creditContainer.addSubview(creditBoxStack)
        friendContainer.addSubview(friendIcon)
        [backgroundStar, creditContainer, friendContainer, characterShadow, homeCharacter].forEach(self.addSubview)
        
    }
    
    private func constraints(){
        
        backgroundStar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        creditContainer.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(24)
        }
        
        creditBoxStack.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(15)
        }
        
        friendContainer.snp.makeConstraints{
            $0.top.equalToSuperview().offset(24)
            $0.right.equalToSuperview().inset(24)
        }
        
        friendIcon.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
            $0.height.width.equalTo(28)
        }
        
        
        homeCharacter.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        characterShadow.snp.makeConstraints{
            $0.bottom.equalTo(homeCharacter.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
}
