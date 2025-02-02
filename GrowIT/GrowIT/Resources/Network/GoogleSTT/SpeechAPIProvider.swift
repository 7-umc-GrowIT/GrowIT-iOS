import Foundation
import Moya

class SpeechAPIProvider {
    private let provider = MoyaProvider<SpeechAPI>()
    // private let apiKey: String = "AIzaSyArKR4aSUzQaK504AlT1WXtyWfuWK0S2LQ" // 하드코딩된 API Key
    private let apiKey: String = Bundle.main.googleSpeechAPIKey

    func recognize(audioContent: String, completion: @escaping (Result<String, Error>) -> Void) {
        provider.request(.recognize(audioContent: audioContent, apiKey: apiKey)) { result in
            switch result {
            case .success(let response):
                do {
                    // JSON 응답 파싱
                    if let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any],
                       let results = json["results"] as? [[String: Any]],
                       let firstResult = results.first,
                       let alternatives = firstResult["alternatives"] as? [[String: Any]],
                       let transcript = alternatives.first?["transcript"] as? String {
                        completion(.success(transcript)) // 텍스트 변환 결과 반환
                    } else {
                        completion(.failure(NSError(domain: "SpeechAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "API 응답 형식 오류"])))
                    }
                } catch {
                    completion(.failure(error)) // 파싱 실패
                }
            case .failure(let error):
                completion(.failure(error)) // 네트워크 요청 실패
            }
        }
    }
}

extension Bundle {
    var googleSpeechAPIKey: String {
        return object(forInfoDictionaryKey: "Google_Speech_API_Key") as? String ?? ""
    }
}
