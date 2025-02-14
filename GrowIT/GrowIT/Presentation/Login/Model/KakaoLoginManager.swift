//
//  KakaoLoginManager.swift
//  GrowIT
//
//  Created by 강희정 on 1/30/25.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

final class KakaoLoginManager {
    static let shared = KakaoLoginManager()
    
    // private init으로 외부에서 인스턴스 생성 방지
    private init() {}
    
    // completion handler를 인스턴스 프로퍼티로 유지
    private var completionHandler: ((Result<String, Error>) -> Void)?
    
    // OAuth 설정
    private let clientId = "ad38f7a54ae0b83d104d8fcb239aebea"
    private let redirectUri = "kakaoad38f7a54ae0b83d104d8fcb239aebea://oauth"
    
    func loginWithKakao(completion: @escaping (Result<String, Error>) -> Void) {
        // 완료 핸들러 저장
        print("🟡 이전 completionHandler: \(String(describing: self.completionHandler))")
        self.completionHandler = completion
        print("🟡 설정된 completionHandler: \(String(describing: self.completionHandler))")
        print("🟡 KakaoLoginManager: loginWithKakao 호출됨")
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            print("🟡 KakaoLoginManager: 카카오톡 로그인 시도")
            // 카카오톡 설치되어 있는 경우
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ 카카오톡 로그인 실패: \(error.localizedDescription)")
                    self.completionHandler?(.failure(error))
                    self.completionHandler = nil
                    return
                }
                
                print("✅ KakaoLoginManager: 카카오톡 로그인 성공! 인가 코드 요청 시작")
                
                // 인증 코드 요청 URL 생성
                let authCodeURL = "https://kauth.kakao.com/oauth/authorize?client_id=\(self.clientId)&redirect_uri=\(self.redirectUri)&response_type=code"
                
                // 웹뷰나 Safari로 인증 코드 요청
                if let url = URL(string: authCodeURL) {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url)
                    }
                }
            }
        } else {
            // 카카오톡 미설치: 웹 로그인
            print("🟡 KakaoLoginManager: 카카오 계정 로그인 시도")
            
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ 카카오 계정 로그인 실패: \(error.localizedDescription)")
                    self.completionHandler?(.failure(error))
                    self.completionHandler = nil
                    return
                }
                
                print("✅ KakaoLoginManager: 카카오 계정 로그인 성공! 인가 코드 요청 시작")
                            
                // 인증 코드 요청 URL 생성
                let authCodeURL = "https://kauth.kakao.com/oauth/authorize?client_id=\(self.clientId)&redirect_uri=\(self.redirectUri)&response_type=code"
                
                if let url = URL(string: authCodeURL) {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    // Redirect URI로부터 인가 코드를 받아오는 메서드
    func handleAuthorizationCode(from url: URL) {
        print("🟡 handleAuthorizationCode 시작시 completionHandler: \(String(describing: self.completionHandler))")
        print("🟡 KakaoLoginManager: handleAuthorizationCode 실행됨")
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
            print("❌ KakaoLoginManager: 인가 코드 획득 실패")
            self.completionHandler?(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get authorization code"])))
            self.completionHandler = nil
            return
        }

        print("✅ KakaoLoginManager: 인가 코드 획득: \(code)")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                print("❌ KakaoLoginManager: self가 nil, completionHandler 실행 안 됨")
                return
            }
            
            print("✅ KakaoLoginManager: completionHandler 실행됨 (인가 코드: \(code))")
            
            if let handler = self.completionHandler {
                print("✅ KakaoLoginManager: completionHandler가 존재함, handleKakaoLogin 호출 예정")
                handler(.success(code))  // 🚀 여기에서 handleKakaoLogin 호출됨
                print("✅ KakaoLoginManager: handleKakaoLogin 호출됨!")
            } else {
                print("❌ KakaoLoginManager: completionHandler가 nil이라 handleKakaoLogin 호출 안 됨")
            }

            self.completionHandler = nil
        }
    }
}
