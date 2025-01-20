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
    
    private lazy var subtitleLabel = UILabel().then {
        $0.text = "마지막 단계예요"
        $0.font = UIFont.body1Medium()
        $0.textColor = UIColor.grayColor500
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "당신의 그로 이름을 알려 주세요"
        $0.font = UIFont.subHeading2()
        $0.textColor = UIColor.grayColor900
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont.heading3Bold()
        $0.textColor = UIColor.grayColor900
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var nickNameTextField = UITextField().then {
        // core 가져오기
        $0.placeholder = "닉네임을 입력해주세요"
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var groImageView = UIImageView().then {
        $0.image = UIImage(named: "GrowIT_Gro")
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var startButton = UIButton().then {
        // 만들어야함
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
        addSubviews([shapeIcon, subtitleLabel, titleLabel, nickNameLabel, nickNameTextField, groImageView, startButton])
    }
    
    //MARK: - 레이아웃 설정
    private func setConstraints() {
        shapeIcon.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.top.equalTo(safeAreaLayoutGuide).offset(60)
            $0.leading.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(shapeIcon.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
         
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel)
            $0.leading.equalToSuperview().inset(24)
        }
         
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
        }
         
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(24)
        }
         
        groImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(164)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(width: 778, height: 584))
        }
         
        startButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(60)
        }
        
        
    }
}
