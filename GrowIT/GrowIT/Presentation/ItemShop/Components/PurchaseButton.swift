//
//  PurchaseButton.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import Foundation
import UIKit
import SnapKit

class PurchaseButton: UIButton {
    // MARK: - Properties
    var showCredit: Bool = true {
        didSet { updateUI() }
    }
    var title: String = "구매하기" {
        didSet { updateUI() }
    }
    var credit: String = "0" {
        didSet { updateUI() }
    }

    // MARK: - UI Components
    private lazy var creditIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "GrowIT_Credit_Glow")
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 23, height: 24))
        }
        return imageView
    }()

    private lazy var creditLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primaryColor400!
        label.font = UIFont.heading2Bold()
        label.textAlignment = .center
        return label
    }()

    private lazy var purchaseLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.heading2Bold()
        label.textAlignment = .center
        return label
    }()

    private lazy var buttonContentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()

    // MARK: - init
    init(showCredit: Bool = true, title: String = "구매하기", credit: String = "0") {
        self.showCredit = showCredit
        self.title = title
        self.credit = credit
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    private func configure() {
        // Add subviews
        if showCredit {
            buttonContentView.addArrangedSubview(creditIcon)
            buttonContentView.addArrangedSubview(creditLabel)
            buttonContentView.setCustomSpacing(10, after: creditLabel)
        }
        buttonContentView.addArrangedSubview(purchaseLabel)
        addSubview(buttonContentView)

        // Layout
        buttonContentView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // Button configuration
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .black
        self.configuration = config

        layer.cornerRadius = 16
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false

        // 버튼 터치인식 설정
        isUserInteractionEnabled = true
        [buttonContentView, creditIcon, creditLabel, purchaseLabel].forEach {
            $0.isUserInteractionEnabled = false
        }

        updateUI()
    }

    // MARK: - UI Update
    private func updateUI() {
        creditLabel.text = credit
        purchaseLabel.text = title

        let shouldShowCredit = showCredit
        creditIcon.isHidden = !shouldShowCredit
        creditLabel.isHidden = !shouldShowCredit
    }
}
