//
//  ChallengeViewModel.swift
//  GrowIT
//
//  Created by 허준호 on 6/5/25.
//

import Combine
import Foundation

final class ChallengeHomeViewModel {
    // Input
    @Published var refreshTrigger = false

    // Output
    @Published private(set) var todayChallenges: [RecommendedChallengeDTO] = []
    @Published private(set) var challengeKeywords: [String] = []
    @Published private(set) var challengeReport: ChallengeReportDTO?
    @Published private(set) var isEmptyChallenge = false
    @Published private(set) var isEmptyTodayChallenge = false
    @Published private(set) var errorMessage: String?

    private let getChallengeHomeUseCase: GetChallengeHomeUseCase
    private var cancellables = Set<AnyCancellable>()

    init(getChallengeHomeUseCase: GetChallengeHomeUseCase) {
        self.getChallengeHomeUseCase = getChallengeHomeUseCase
        bind()
    }

    private func bind() {
        $refreshTrigger
            .filter { $0 }
            .flatMap { [unowned self] _ in
                self.getChallengeHomeUseCase.execute()
                    .catch { [weak self] error -> Empty<ChallengeHomeResponseDTO, Never> in
                        self?.errorMessage = error.localizedDescription
                        return .init()
                    }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }

                self.challengeKeywords = data.challengeKeywords
                self.challengeReport = data.challengeReport

                if data.challengeKeywords.isEmpty {
                    self.isEmptyChallenge = true
                }

                if data.recommendedChallenges.isEmpty {
                    self.isEmptyTodayChallenge = true
                } else {
                    self.todayChallenges = data.recommendedChallenges
                }
            }
            .store(in: &cancellables)
    }

    func refresh() {
        refreshTrigger = true
    }
}
