//
//  Constants.swift
//  GrowIT
//
//  Created by 이수현 on 1/19/25.
//

import Foundation

struct Constants {

    public struct API {
        static let baseURL = "http://13.124.160.115:8080"
        static let diaryURL = "\(baseURL)/diaries"

        static let GroURL = baseURL + "/characters"
        static let itemURL = baseURL + "/items"
        static let imageURL = baseURL + "/"

        static let authURL = "\(baseURL)/auth"
        static let challengeURL = "\(baseURL)/challenges"
        static let s3URL = "\(baseURL)/s3"
    }
}
