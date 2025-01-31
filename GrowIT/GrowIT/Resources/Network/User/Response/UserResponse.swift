//
//  UserResponse.swift
//  GrowIT
//
//  Created by 오현민 on 1/31/25.
//

import Foundation

struct UserPostResponseDTO: Decodable {
    let currentCredit, totalCredit: Int
    let status, paidAt: String
}

struct UserPatchResponseDTO: Decodable {

}

struct UserGetCreditResponseDTO: Decodable {
    let currentCredit: Int
}

struct UserGetTotalCreditResponseDTO: Decodable {
    let totalCredit: Int
}
