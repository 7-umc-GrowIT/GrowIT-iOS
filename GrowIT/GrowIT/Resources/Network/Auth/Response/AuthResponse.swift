//
//  AuthResponse.swift
//  GrowIT
//
//  Created by 이수현 on 1/26/25.
//

import Foundation

struct VerifyResponse: Decodable {
    let message: String
}

struct LoginResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: TokenData
}

struct TokenData: Decodable {
    let accessToken: String
    let refreshToken: String
}


struct EmailVerifyResponse: Decodable {
    let email: String
    let message: String
    let code: String
    let expiration: String
}

struct SignOutResponse: Decodable {
    let name: String
    let message: String
}

struct ReissueResponse: Decodable {
    let accessToken: String
}

