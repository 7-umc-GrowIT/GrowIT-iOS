//
//  KakaoLoginManager.swift
//  GrowIT
//
//  Created by 강희정 on 1/30/25.
//

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class KakaoLoginManager {
    
    func getKakaoAuthorizationCode(completion: @escaping (String?) -> Void) {
           if UserApi.isKakaoTalkLoginAvailable() {
               // ✅ 카카오톡 앱으로 로그인 시도
               UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                   if let error = error {
                       print("❌ 카카오 로그인 실패: \(error.localizedDescription)")
                       completion(nil)
                   } else if let oauthToken = oauthToken {
                       print("✅ 카카오 로그인 성공! 인가 코드: \(oauthToken.accessToken)")
                       completion(oauthToken.accessToken)  // ✅ 인가 코드 대신 accessToken 사용 가능
                   } else {
                       print("❌ 카카오 로그인 실패: 응답 없음")
                       completion(nil)
                   }
               }
           } else {
               // ✅ 카카오톡이 없으면 웹 로그인 시도
               UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                   if let error = error {
                       print("❌ 카카오 웹 로그인 실패: \(error.localizedDescription)")
                       completion(nil)
                   } else if let oauthToken = oauthToken {
                       print("✅ 카카오 웹 로그인 성공! 인가 코드: \(oauthToken.accessToken)")
                       completion(oauthToken.accessToken)  // ✅ 인가 코드 대신 accessToken 사용 가능
                   } else {
                       print("❌ 카카오 로그인 실패: 응답 없음")
                       completion(nil)
                   }
               }
           }
       }
}
