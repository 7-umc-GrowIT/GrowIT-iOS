//
//  DiaryAllView.swift
//  GrowIT
//
//  Created by 이수현 on 1/24/25.
//

import UIKit

class DiaryAllView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private let dateView = UIView().then {
        $0.backgroundColor = .gray50
    }
    
    private let dayLabel = UILabel().then {
        $0.text = "나의 일기를 모아보세요!"
        $0.font = .body2SemiBold()
        $0.textColor = .primary600
    }
    
    // 추후 드롭다운으로 수정 예정
    private let dateLabel = UILabel().then {
        $0.text = "2025년 1월 6일"
        $0.font = .heading2Bold()
        $0.textColor = .gray900
    }
    
    let dropDownButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        $0.backgroundColor = .clear
        $0.tintColor = .gray500
    }
    
    let diaryCountLabel = UILabel().then {
        var count = 0
        let allText = "작성한 일기 수 \(count)"
        $0.text = allText
        $0.font = .body2Medium()
        $0.textColor = .gray600
        $0.setPartialTextStyle(text: allText, targetText: "\(count)", color: .primary700, font: .body2Medium())
    }
    
    let diaryTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.register(DiaryAllViewTableViewCell.self, forCellReuseIdentifier: DiaryAllViewTableViewCell.identifier)
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(dateView)
        dateView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(109)
        }
        
        dateView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(32)
        }
        
        dateView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(dayLabel)
            make.top.equalTo(dayLabel.snp.bottom).offset(8)
            // make.width.equalTo(160)
        }
        
        addSubview(dropDownButton)
        dropDownButton.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(4)
            make.centerY.equalTo(dateLabel.snp.centerY)
        }
        
        addSubview(diaryCountLabel)
        diaryCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(dateView.snp.bottom).offset(16)
        }
        
        addSubview(diaryTableView)
        diaryTableView.snp.makeConstraints { make in
            make.leading.equalTo(diaryCountLabel.snp.leading)
            make.top.equalTo(diaryCountLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-53)
        }
    }
    
    func updateDiaryCount(_ count: Int) {
        let allText = "작성한 일기 수 \(count)"
        diaryCountLabel.text = allText
        diaryCountLabel.setPartialTextStyle(text: allText, targetText: "\(count)", color: .primary700, font: .body2Medium())
    }
}
