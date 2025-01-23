import Foundation
import Moya

enum SpeechAPI {
    case recognize(audioContent: String, apiKey: String)
}

extension SpeechAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://speech.googleapis.com/v1")!
    }
    
    var path: String {
        switch self {
        case .recognize:
            return "/speech:recognize"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .recognize:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .recognize(let audioContent, let apiKey):
            let parameters: [String: Any] = [
                "config": [
                    "encoding": "LINEAR16",
                    "sampleRateHertz": 16000,
                    "languageCode": "ko-KR"
                ],
                "audio": [
                    "content": audioContent
                ]
            ]
            return .requestCompositeParameters(bodyParameters: parameters, bodyEncoding: JSONEncoding.default, urlParameters: ["key": apiKey])
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
