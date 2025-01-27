//
//  DiaryEndpoint.swift
//  GrowIT
//
//  Created by 이수현 on 1/18/25.
//

import Foundation
import Moya

enum DiaryEndpoint {
    // Get
    case getDiaryID(diaryId: Int)
    case getAllDiary(year: Int, month: Int)
    case getDiaryDates(year: Int, month: Int)
    
    // Post
    case postVoiceDiary(data: DiaryRequestDTO)
    case postTextDiary(Data: DiaryRequestDTO)
    
    // Delete
    case deleteDiary(diaryId: Int)
    
    // Put
}

extension DiaryEndpoint: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.diaryURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case.postTextDiary:
            return "/text"
        case.postVoiceDiary:
            return "/voice"
        case.deleteDiary(let diaryId), .getDiaryID(let diaryId):
            return "/\(diaryId)"
        case.getDiaryDates:
            return "/dates"
        default:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postTextDiary, .postVoiceDiary:
            return .post
        case .deleteDiary:
            return .delete
        default :
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .postTextDiary(let data), .postVoiceDiary(let data):
            return .requestJSONEncodable(data)
        case .deleteDiary(_):
            return  .requestPlain
        case .getDiaryID(_):
            return .requestPlain
        case .getDiaryDates(let year, let month):
            return .requestParameters(
                parameters: ["year": year, "month": month],
                encoding: URLEncoding.queryString)
        case .getAllDiary(let year, let month):
            return .requestParameters(
                parameters: ["year": year, "month": month],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
}
