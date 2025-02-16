//
//  ChallengeEndpoint.swift
//  GrowIT
//
//  Created by 허준호 on 1/29/25.
//

import Foundation
import Moya

enum ChallengeEndpoint {
    // Get
    case getChallengeById(challengeId: Int)
    case getAllChallenges(dtype: String, completed: Bool)
    case getSummaryChallenge
    
    // Post
    case postSelectChallenge(data: ChallengeSelectRequestListDTO)
    case postProveChallenge(challengeId: Int, data: ChallengeRequestDTO)
    
    // Delete
    case deleteChallengeById(challengeId: Int)
    
    // Put
    case patchChallengeById(challengeId: Int, data: ChallengeRequestDTO)
}

extension ChallengeEndpoint: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.challengeURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case.getChallengeById(let challengeId):
            return "/\(challengeId)"
        case.getSummaryChallenge:
            return "/summary"
        case.postSelectChallenge(let challengeId):
            return "/\(challengeId)/select"
        case.postProveChallenge(let challengeId, _):
            return "/\(challengeId)/prove"
        case.deleteChallengeById(let challengeId):
            return "/\(challengeId)"
        case.patchChallengeById(let challengeId, _):
            return "/\(challengeId)"
        default:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSelectChallenge, .postProveChallenge:
            return .post
        case .deleteChallengeById:
            return .delete
        case .patchChallengeById:
            return .patch
        default :
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .postSelectChallenge(let data):
            return .requestJSONEncodable(data)
        case .deleteChallengeById(_), .getChallengeById(_), .getSummaryChallenge:
            return .requestPlain
        case .postProveChallenge(_, let data), .patchChallengeById(_, let data):
            return .requestJSONEncodable(data)
        case .getAllChallenges(dtype: let dtype, completed: let completed):
            return .requestParameters(
                parameters: ["dtype": dtype, "completed": completed],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJsc29vb0BnLmNvbSIsInJvbGVzIjoiVVNFUiIsInVzZXJJZCI6NzYsImV4cCI6MTczOTY3Njk3M30.6UqaSxBfaNQWPdGWGksENfdEx7Yjo9B6MKDB5eN3Rck"
        ]
    }
    
    
}
