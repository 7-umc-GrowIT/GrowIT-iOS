//
//  VoiceDiaryRecommendChallengeViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-22.
//

import UIKit
import Combine

class VoiceDiaryRecommendChallengeViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let saveButtonTapped = PassthroughSubject<Void, Never>()
    let challengeButtonTapped = PassthroughSubject<Bool, Never>()
    let viewWillAppear = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldPresentRecommendError = false
    @Published var shouldNavigateToEnd = false
    @Published var shouldShowChallengeSelectionToast = false
    @Published var isSaveButtonEnabled = false
    @Published var emotionKeywords: [EmotionKeyword] = []
    @Published var recommendedChallenges: [RecommendedChallenge] = []
    @Published var isLoading = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let challengeService: ChallengeService
    private let diaryId: Int
    private var buttonCount = 0
    
    // MARK: - Initialization
    init(challengeService: ChallengeService = ChallengeService(), diaryId: Int, recommendedChallenges: [RecommendedChallenge], emotionKeywords: [EmotionKeyword]) {
        self.challengeService = challengeService
        self.diaryId = diaryId
        self.recommendedChallenges = recommendedChallenges
        self.emotionKeywords = emotionKeywords
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        backButtonTapped
            .sink { [weak self] in
                self?.shouldPresentRecommendError = true
            }
            .store(in: &cancellables)
        
        saveButtonTapped
            .sink { [weak self] in
                self?.handleSaveButtonTap()
            }
            .store(in: &cancellables)
        
        challengeButtonTapped
            .sink { [weak self] isSelected in
                self?.handleChallengeButtonTap(isSelected: isSelected)
            }
            .store(in: &cancellables)
    }
    
    private func handleChallengeButtonTap(isSelected: Bool) {
        if isSelected {
            buttonCount += 1
        } else {
            buttonCount -= 1
        }
        isSaveButtonEnabled = buttonCount > 0
    }
    
    private func handleSaveButtonTap() {
        if buttonCount == 0 {
            shouldShowChallengeSelectionToast = true
            return
        }
        
        // This method would be called by the ViewController with selected challenges
        // as the ViewModel doesn't have direct access to UI elements
    }
    
    // MARK: - Public Methods
    func postSelectedChallenges(_ selectedChallenges: [ChallengeSelectRequestDTO]) {
        isLoading = true
        challengeService.postSelectedChallenge(data: selectedChallenges) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let response):
                    print("챌린지 선택 성공: \(response)")
                    self?.shouldNavigateToEnd = true
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func getDiaryId() -> Int {
        return diaryId
    }
    
    func createSelectedChallenges(from challengeViews: [VoiceChallengeItemView]) -> [ChallengeSelectRequestDTO] {
        let date = UserDefaults.standard.string(forKey: "VoiceDate") ?? ""
        return challengeViews.enumerated().compactMap { index, challengeView in
            guard index < recommendedChallenges.count, challengeView.button.isSelectedState() else { return nil }
            let challenge = recommendedChallenges[index]
            return ChallengeSelectRequestDTO(challengeIds: [challenge.id], dtype: challenge.type, date: date)
        }
    }
}