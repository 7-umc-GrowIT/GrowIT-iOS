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
    
    static let shared = KakaoLoginManager()
    
    private init() {}
    
    func loginWithKakao(completion: @escaping (String?, Error?) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { OAuthToken, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(OAuthToken?.accessToken, nil)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    completion(oauthToken?.accessToken, nil)
                }
            }
        }
    }
}
