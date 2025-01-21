//
//  LoginViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/13/25.
//

import UIKit
import Foundation
import SnapKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        
        loginView.emailLoginButton.addTarget(self, action: #selector(emailLoginBtnTap), for: .touchUpInside)

    }
    
    private lazy var loginView = LoginView()
    
    
    //MARK: - Action
    
    // 뒤로 가기 버튼 함수
    @objc func emailLoginBtnTap() {
        let emailLoginVC = EmailLoginViewController()
        self.navigationController?.pushViewController(emailLoginVC, animated: true)
    }

    func navigateToEmailLogin() {
        let emailLoginVC = EmailLoginViewController()
        // EmailLoginViewController를 네비게이션 컨트롤러에서 푸시
        self.navigationController?.pushViewController(emailLoginVC, animated: true)
    }
}


