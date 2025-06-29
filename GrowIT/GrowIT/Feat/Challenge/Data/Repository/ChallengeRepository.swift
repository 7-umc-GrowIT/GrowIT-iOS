//
//  ChallengeRepositoryImpl.swift
//  GrowIT
//
//  Created by 허준호 on 6/5/25.
//

import Combine

protocol ChallengeRepository {
    func fetchChallengeHome() -> AnyPublisher<ChallengeHomeResponseDTO, Error>
}

final class ChallengeRepositoryImpl: ChallengeRepository {
    private let dataSource: ChallengeDataSource

    init(dataSource: ChallengeDataSource) {
        self.dataSource = dataSource
    }

    func fetchChallengeHome() -> AnyPublisher<ChallengeHomeResponseDTO, Error> {
        return dataSource.fetchChallengeHome()
    }
}
