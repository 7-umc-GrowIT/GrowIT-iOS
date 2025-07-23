//
//  TermsAgreeTableViewCell.swift
//  GrowIT
//
//  Created by 이수현 on 1/26/25.
//

import UIKit
import SnapKit
import Then

class TermsAgreeTableViewCell: UITableViewCell {
    
    static let identifier = "TermsAgreeTableViewCell"
    
    var onAgreeButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        selectionStyle = .none
        agreeButton.addTarget(self, action: #selector(didTapAgreeButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    let agreeButton = CircleCheckButton(isEnabled: false).then {
        $0.isUserInteractionEnabled = true
    }
    
    private let mandatoryView = MandatoryOptionalView(backgroundColor: .negative50, text: "필수", textColor: .negative400)
    
    let titleLabel = UILabel().then {
        $0.font = .heading3SemiBold()
        $0.textColor = .gray800
    }
    
    let detailButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.backgroundColor = .clear
        $0.tintColor = .gray200
    }
    
    /// 하단 간격용 Spacer
    private let bottomSpacer = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // 내부 요소 배치
        contentView.addSubview(agreeButton)
        agreeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(16)
        }
        
        contentView.addSubview(mandatoryView)
        mandatoryView.snp.makeConstraints { make in
            make.leading.equalTo(agreeButton.snp.trailing).offset(12)
            make.centerY.equalTo(agreeButton)
            make.width.equalTo(37)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(mandatoryView.snp.trailing).offset(6)
            make.centerY.equalTo(mandatoryView)
        }
        
        contentView.addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(mandatoryView)
        }
        
        contentView.addSubview(bottomSpacer)
        bottomSpacer.snp.makeConstraints { make in
            make.top.equalTo(agreeButton.snp.bottom).offset(16)
            make.height.equalTo(12)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configure(title: String, content: String, isAgreed: Bool) {
        titleLabel.text = title
        agreeButton.setSelectedState(isAgreed)
    }
    
    @objc private func didTapAgreeButton() {
        onAgreeButtonTapped?()
    }
}
