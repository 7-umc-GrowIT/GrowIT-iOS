//
//  ItemListModalView.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit

class ItemListModalView: UIView {
    
    private lazy var itemSegmentedControl = ItemTabSegmentedControl(items: [
        UIImage(named: "GrowIT_Background_Off")!.withRenderingMode(.alwaysOriginal),
        UIImage(named: "GrowIT_Object_Off")!.withRenderingMode(.alwaysOriginal),
        UIImage(named: "GrowIT_FlowerPot_Off")!.withRenderingMode(.alwaysOriginal),
        UIImage(named: "GrowIT_Accessories_Off")!.withRenderingMode(.alwaysOriginal)
    ]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 40
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
        self.addSubview(itemSegmentedControl)
    }
    
    //MARK: - 레이아웃설정
    private func setConstraints() {
        itemSegmentedControl.snp.makeConstraints {
            $0.left.equalToSuperview().offset(30)
            $0.right.equalToSuperview().inset(30)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(92)
        }
    }
    
    
}
