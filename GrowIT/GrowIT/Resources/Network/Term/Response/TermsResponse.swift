//
//  Untitled.swift
//  GrowIT
//
//  Created by 강희정 on 1/30/25.
//

import Foundation

struct TermsResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [Term]
}

struct Term: Codable {
    let title: String
    let content: String
    let type: String
}
