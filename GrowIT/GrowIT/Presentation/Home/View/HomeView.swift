//
//  HomeView.swift
//  GrowIT
//
//  Created by 허준호 on 1/7/25.
//

import UIKit
import Then
import SnapKit

class HomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Property
    
    // 상단 네비게이션 바
    private lazy var topNavBar = HomeTopNavbarView()

    
    // 하단 캐릭터 영역
    private lazy var characterArea = HomeCharacterView()
    
    // MARK: - Function
    
    
    // MARK: - add Function & Constraints
    
    private func addComponents(){
        [characterArea, topNavBar].forEach(self.addSubview)
    }
    
    private func constraints(){
        
        
        
        characterArea.snp.makeConstraints{
            //$0.top.equalTo(topNavBar.snp.bottom).offset(0)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.bottom.equalToSuperview()
            //$0.horizontalEdges.equalToSuperview()
        }
        
        topNavBar.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
    }

}
