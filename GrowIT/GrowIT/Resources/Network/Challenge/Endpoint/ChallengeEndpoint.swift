//
//  ChallengeEndpoint.swift
//  GrowIT
//
//  Created by 허준호 on 1/29/25.
//

//
//  DiaryEndpoint.swift
//  GrowIT
//
//  Created by 이수현 on 1/18/25.
//

import Foundation
import Moya

enum ChallengeEndpoint {
    // Get
    case getChallengeById(challengeId: Int)
    case getAllChallenges(status: String, completed: Bool)
    case getSummaryChallenge
    
    // Post
    case postSaveChallenge(challengeId: Int)
    case postProveChallenge(challengeId: Int)
    
    // Delete
    case deleteChallengeById(challengeId: Int)
    
    // Put
    case patchChallengeById(challengeId: Int)
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
        case.getAllChallenges(status: let status, completed: let completed):
            return ""
        case.getSummaryChallenge:
            return "/summary"
        case.postSaveChallenge(let challengeId):
            return "/\(challengeId)/select"
        case.postProveChallenge(let challengeId):
            return "/\(challengeId)/prove"
        case.deleteChallengeById(let challengeId):
            return "/\(challengeId)"
        case.patchChallengeById(let challengeId):
            return "/\(challengeId)"
        default:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSaveChallenge, .postProveChallenge:
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
        case .postSaveChallenge(_), .postProveChallenge(_), .patchChallengeById(_), .deleteChallengeById(_), .getChallengeById(_), .getSummaryChallenge:
            return .requestPlain
        case .getAllChallenges(status: let status, completed: let completed):
            return .requestParameters(
                parameters: ["status": status, "completed": completed],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [ "Content-type": "application/json" ]
    }
    
    
}
