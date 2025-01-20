//
//  DiaryResponse.swift
//  GrowIT
//
//  Created by 이수현 on 1/18/25.
//

import Foundation

struct DiaryPostResponseDTO: Decodable {
    let diaryId: Int
    let content: String
    let createdAt: String
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
    let totalPage: Int
    let totalElements: Int
    let isFirst: Bool
    let isLast: Bool
}

struct DiaryDTO: Decodable {
    let content: String
    let date: String
}
