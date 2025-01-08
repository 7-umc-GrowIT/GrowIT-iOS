//
//  ItemListModalView.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit

class ItemListModalView: UIView {
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 9
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 컴포넌트추가
    private func setView() {
       
    }
    
    //MARK: - 레이아웃설정
    private func setConstraints() {
        
    }
}
