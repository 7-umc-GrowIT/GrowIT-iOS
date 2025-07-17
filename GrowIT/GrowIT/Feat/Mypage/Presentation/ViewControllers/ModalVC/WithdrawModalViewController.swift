//
//  WithdrawModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 7/16/25.
//

import UIKit

class WithdrawModalViewController: UIViewController {
    //MARK: -Views
    private lazy var withdrawModalView = WithdrawModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = withdrawModalView
    }

}
