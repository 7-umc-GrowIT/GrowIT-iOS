//
//  KakaoLoginManager+Combine.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Combine

extension KakaoLoginManager {
    func loginWithKakaoPublisher() -> AnyPublisher<String, Error> {
        Future<String, Error> { promise in
            self.loginWithKakao { result in
                switch result {
                case .success(let code):
                    promise(.success(code))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
