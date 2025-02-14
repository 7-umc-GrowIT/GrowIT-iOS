//
//  DiaryResponse.swift
//  GrowIT
//
//  Created by 이수현 on 1/18/25.
//

import Foundation

struct DiaryTextPostResponseDTO: Decodable {
    let diaryId: Int
    let content: String
    let date: String
}

struct DiaryVoicePostResponseDTO: Decodable {
    let chat: String
}

struct DiaryGetDatesResponseDTO: Decodable {
    let diaryDateList: [DiaryDateDTO]
    let listSize: Int
}

struct DiaryDateDTO: Decodable {
    let diaryId: Int
    let date: String
}

struct DiaryGetAllResponseDTO: Decodable {
    let diaryList: [DiaryDTO]
    let listSize: Int
}

struct DiaryDTO: Decodable {
    let diaryId: Int
    let content: String
    let date: String
}

struct DiaryPatchResponseDTO: Decodable {
    let diaryId: Int
    let content: String
}

struct DiaryDeleteResponseDTO: Decodable {
    let message: String
}
