//
//  ChallengeDataSource.swift
//  GrowIT
//
//  Created by 허준호 on 6/4/25.
//

import Foundation
import Combine

protocol ChallengeDataSource {
    func fetchChallengeHome() -> AnyPublisher<ChallengeHomeResponseDTO, Error>
}

final class ChallengeDataSourceImpl: ChallengeDataSource {
    func fetchChallengeHome() -> AnyPublisher<ChallengeHomeResponseDTO, Error> {
        // 기존 completion 기반 API를 Combine으로 래핑
        Future { promise in
            ChallengeService().fetchChallengeHome { result in
                switch result {
                case .success(let data):
                    promise(.success(data))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

final class MockChallengeDataSourceImpl: ChallengeDataSource {
    func fetchChallengeHome() -> AnyPublisher<ChallengeHomeResponseDTO, Error> {
        let mockData = ChallengeHomeResponseDTO(
            challengeKeywords: ["운동", "공부", "습관"],
            recommendedChallenges: [
                RecommendedChallengeDTO(
                    id: 1,
                    title: "30분 독서하기",
                    content: "30분 독서",
                    dtype: "DAILY",
                    time: 30,
                    completed: false
                ),
                RecommendedChallengeDTO(
                    id: 2,
                    title: "아침 스트레칭",
                    content: "10분 스트레칭",
                    dtype: "DAILY",
                    time: 10,
                    completed: true
                )
            ],
            challengeReport: ChallengeReportDTO(
                totalCredits: 500,
                totalDiaries: 10,
                diaryDate: "+10"
            )
        )
        
        return Just(mockData)
            .setFailureType(to: Error.self)
            .delay(for: .milliseconds(300), scheduler: DispatchQueue.main) // 네트워크 시뮬레이션용
            .eraseToAnyPublisher()
    }
}
