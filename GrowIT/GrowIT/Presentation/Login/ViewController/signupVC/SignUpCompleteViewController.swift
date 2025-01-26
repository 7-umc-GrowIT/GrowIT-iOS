//
//  SignUpCompleteViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/26/25.
//

import UIKit

class SignUpCompleteViewController: UIViewController {
    
    // MARK: - Properties
    private let signUpCompleteView = SignUpCompleteView()
    private let navigationBarManager = NavigationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - setupView
    private func setupView() {
        self.view = signUpCompleteView
        self.navigationController?.isNavigationBarHidden = false
        
        navigationBarManager.setTitle(
            to: self.navigationItem,
            title: "회원가입",
            textColor: .gray900,
            font: .heading1Bold()
        )
        
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    // MARK: - Actions
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    

}
