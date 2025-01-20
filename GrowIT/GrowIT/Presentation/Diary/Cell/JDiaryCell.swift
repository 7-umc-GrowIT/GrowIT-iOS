//
//  JDiaryCell.swift
//  GrowIT
//
//  Created by 허준호 on 1/16/25.
//

import UIKit
import Then
import SnapKit

class JDiaryCell: UICollectionViewCell{
    
    static let identifier:String = "JDiaryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dateCell = UILabel().then{
        $0.text = "1"
        $0.font = .subBody1()
        $0.textColor = .grayColor900
    }
    
    private func addComponents(){
        self.addSubview(dateCell)
    }
    
    private func constraints(){
        dateCell.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    
    public func figure(day:Int, isSunday:Bool, isFromCurrentMonth: Bool){
        dateCell.text = "\(day)"
        if(isSunday){
            dateCell.textColor = .negative400
        }else if(!isFromCurrentMonth){
            dateCell.textColor = .gray300
        }else{
            dateCell.textColor = .gray900
        }
    }
}
