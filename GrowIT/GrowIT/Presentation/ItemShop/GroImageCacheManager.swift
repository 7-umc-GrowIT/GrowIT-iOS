//
//  GroImageCacheManager.swift
//  GrowIT
//
//  Created by 오현민 on 2/18/25.
//

import UIKit

final class GroImageCacheManager {
    static let shared = GroImageCacheManager()
    private init() {}

    private var isFetching = false  // 중복 요청 방지
    var cachedGroData: GroGetResponseDTO?

    // 1. 캐시 데이터 반환 (없으면 서버 요청)
    func fetchGroImage(completion: @escaping (GroGetResponseDTO?) -> Void) {
        // 캐시가 있으면 바로 반환
        if let cachedData = cachedGroData {
            completion(cachedData)
            return
        }

        // 중복 요청 방지
        guard !isFetching else { return }
        isFetching = true

        // 서버에서 데이터 요청
        let groService = GroService()
        groService.getGroImage { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false

            switch result {
            case .success(let data):
                self.cachedGroData = data
                completion(data)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // 2. 강제 갱신 메서드
    func refreshGroImage(completion: @escaping (GroGetResponseDTO?) -> Void) {
        cachedGroData = nil
        fetchGroImage(completion: completion)
    }

    // 3. 캐시 초기화 메서드
    func clearCache() {
        cachedGroData = nil
    }
}
