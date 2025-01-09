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
        $0.contentMode = .scaleAspectFit
    }
    
    // 트로피 개수 박스
 
    
    // MARK: - Functioin
    
    
    
    // MARK: - add Function & Constraints
    
    private func addComponents(){
        [backgroundStar].forEach(self.addSubview)
    }
    
    private func constraints(){
        
        backgroundStar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
