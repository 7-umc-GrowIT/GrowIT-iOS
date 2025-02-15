//
//  AuthPlugin.swift
//  GrowIT
//
//  Created by 이수현 on 2/15/25.
//

import Foundation
import Moya

/// 모든 API 요청에 자동으로 Authorization 헤더를 추가하는 Moya 플러그인
final class AuthPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        // 로그인/회원가입 API는 토큰을 추가하지 않음
        if let authTarget = target as? AuthorizationEndpoints {
            switch authTarget {
            case .postEmailLogin, .postEmailSignUp, .postKakaoLogin, .postSendEmailVerification:
                return request
            default:
                break
            }
        }
        
        // 저장된 AccessToken 가져오기
        if let accessToken = TokenManager.shared.getAccessToken(), !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            print("✅ 헤더에 AccessToken 추가됨: \(accessToken)")
        } else {
            print("⚠️ 저장된 AccessToken 없음")
        }
        
        return request
    }
}
