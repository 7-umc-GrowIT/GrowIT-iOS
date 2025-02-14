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
    let kakaoLoginManager = KakaoLoginManager()
    
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
        navigationController?.pushViewController(emailLoginVC, animated: true)
    }
    
    func navigateToEmailLogin() {
        let emailLoginVC = EmailLoginViewController()
        // EmailLoginViewController를 네비게이션 컨트롤러에서 푸시
        self.navigationController?.pushViewController(emailLoginVC, animated: true)
    }
    
    
    @objc func kakaoLoginTapped() {
        kakaoLoginManager.getKakaoAuthorizationCode { authCode in
            guard let authCode = authCode else {
                print("❌ 카카오 로그인 실패: 인가 코드 없음")
                return
            }

            // ✅ 카카오 인가 코드 -> 서버로 전송
            AuthService().loginKakao(code: authCode) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("✅ 백엔드 로그인 성공! 서버 액세스 토큰: \(response.result.accessToken)")

                        // ✅ 사용자 정보 저장
                        self.handleLoginSuccess(
                            accessToken: response.result.accessToken,
                            refreshToken: response.result.refreshToken
                        )

                    case .failure(let error):
                        print("❌ 카카오 로그인 실패: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    
    private func handleLoginSuccess(accessToken: String, refreshToken: String) {
        print("✅ 로그인 성공! 사용자 정보 저장 중...")

        // ✅ UserDefaults에 액세스 토큰 & 리프레시 토큰 저장
        UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
        UserDefaults.standard.setValue(refreshToken, forKey: "refreshToken")
        UserDefaults.standard.synchronize()

        print("🔒 저장 완료! accessToken: \(accessToken), refreshToken: \(refreshToken)")

        // ✅ 로그인 후 메인 화면으로 이동
        navigateToMainScreen()
    }
    
    
    private func checkUserLoginStatus() {
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            print("✅ 기존 로그인 정보 확인됨! accessToken: \(accessToken)")

            // ✅ 자동 로그인 처리
            navigateToMainScreen()
        } else {
            print("🔓 로그인 정보 없음. 로그인 화면 유지")
        }
    }
    
    private func navigateToMainScreen() {
        let HomeVC = HomeViewController()
        self.navigationController?.pushViewController(HomeVC, animated: true)
    }

    
}
