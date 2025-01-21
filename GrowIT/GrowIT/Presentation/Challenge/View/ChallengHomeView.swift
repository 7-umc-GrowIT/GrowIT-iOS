//
//  ChallengHomeView.swift
//  GrowIT
//
//  Created by 허준호 on 1/20/25.
//

import UIKit
import Then
import SnapKit

class ChallengHomeView: UIView {
    
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
    
    // MARK: - Stack
    private lazy var challengeHomeNavbar = makeStack(axis: .horizontal, spacing: 0)
    
    // MARK: - Func
    private func makeStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    
    // MARK: - Property
    private func addComponents(){
        [challengeHomeNavbar].forEach(self.addSubview)
    }
    
    private func constraints(){
        
        challengeHomeNavbar.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalToSuperview().multipliedBy(0.07)
        }
    }
    
}
