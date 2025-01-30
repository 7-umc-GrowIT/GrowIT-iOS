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
    
    let authService = AuthService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
        
        loginView.emailLoginButton.addTarget(self, action: #selector(emailLoginBtnTap), for: .touchUpInside)
        loginView.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginTapped), for: .touchUpInside)

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
    
    @objc func kakaoLoginTapped() {
        KakaoLoginManager.shared.loginWithKakao { accessToken, error in
            if let error = error {
                print("카카오 로그인 실패: \(error)")
                return
            }
            
            guard let accessToken = accessToken else {
                print("카카오 액세스 토큰 없음")
                return
            }
            
            print("카카오 로그인 성공 액세스 토큰: \(accessToken)")
            
            // 백엔드 API로 카카오 로그인 요청
            self.authService.loginKakao(code: accessToken) { result in
                switch result {
                case .success(let response):
                    print("백엔드 로그인 성공 서버에서 받은 액세스 토큰: \(response.result.accessToken)")
                    UserDefaults.standard.set(response.result.accessToken, forKey: "accessToken")
                    
                case .failure(let error):
                    print("백엔드 로그인 실패:\(error)")
                }
            }
        }
    }
}


