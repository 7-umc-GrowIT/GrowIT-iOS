//
//  GroSetNameView.swift
//  GrowIT
//
//  Created by 오현민 on 1/7/25.
//

import UIKit

class GroSetNameView: UIView {
    private lazy var backgroundImage = UIImageView().then {
        $0.image = UIImage() /// 수정
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var shapeIcon = UIImageView().then {
        $0.image = UIImage() /// 수정
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    private lazy var subtitleLabel = UILabel().then {
//        
//    }
//    
//    private lazy var titleLabel = UILabel().then {
//        
//    }
//    
//    private lazy var nickNameLabel = UILabel().then {
//        
//    }
//    
//    private lazy var nickNameTextField = UITextField().then {
//        
//    }
//    
//    private lazy var groImageView = UIImageView().then {
//        
//    }
//    
//    private lazy var startButton = UIButton().then {
//        
//    }
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 컴포넌트 추가
    private func setView() {
       
    }
    
    //MARK: - 레이아웃 설정
    private func setConstraints() {
        
    }
}
