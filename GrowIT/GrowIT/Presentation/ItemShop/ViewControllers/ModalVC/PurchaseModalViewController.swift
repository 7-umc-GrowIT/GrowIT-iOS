//
//  PurchaseModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/12/25.
//

import UIKit

class PurchaseModalViewController: UIViewController {
    //MARK: - Views
    private lazy var purchaseModalView = PurchaseModalView().then {
        $0.cancleButton.addTarget(self, action: #selector(didTapCancleButton), for: .touchUpInside)
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = purchaseModalView
    }
    
    //MARK: - 기능
    @objc
    private func didTapCancleButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
