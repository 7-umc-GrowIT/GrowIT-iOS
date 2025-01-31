//
//  PurchaseModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/12/25.
//

import UIKit

class PurchaseModalViewController: UIViewController {
    private let isShortage: Bool
    private let credit: Int
    
    //MARK: - Views
    private lazy var purchaseModalView = PurchaseModalView().then {
        $0.cancleButton.addTarget(self, action: #selector(didTapCancleButton), for: .touchUpInside)
        $0.purchaseButton.updateCredit(credit)
    }
    
    private lazy var shortageModalView = ShortageModalView().then {
        $0.confirmButton.addTarget(self, action: #selector(didTapCancleButton), for: .touchUpInside)
    }
    
    //MARK: - init
    init(isShortage: Bool, credit: Int) {
        self.isShortage = isShortage
        self.credit = credit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = isShortage ? shortageModalView : purchaseModalView
    }
    
    //MARK: - 기능
    @objc
    private func didTapCancleButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
