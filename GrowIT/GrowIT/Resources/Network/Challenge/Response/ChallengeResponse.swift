//
//  ChallengeResponse.swift
//  GrowIT
//
//  Created by 허준호 on 1/29/25.
//

// 단일 챌린지 조회 응답 DTO
struct ChallengeDTO {
    let challengeId: Int
    let title: String
    let certificationImage: String
    let thoughts: String
    let time: Int
    let certificationDate: Bool
}

// 챌린지 현황 조회 응답 DTO
struct ChallengeStatusResponseDTO{
    let userChallenges: [UserChallenge]
}

struct UserChallenge{
    let id: Int
    let title: String
    let dtype: String
    let time: Int
    let completed: Bool
}
