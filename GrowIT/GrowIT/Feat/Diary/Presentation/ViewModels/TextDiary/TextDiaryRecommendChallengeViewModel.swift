//
//  TextDiaryRecommendChallengeViewModel.swift
//  GrowIT
//
//  Created by Claude on 2025-06-21.
//

import UIKit
import Combine

protocol TextDiaryRecommendChallengeViewModelDelegate: AnyObject {
    func didTapExitButton()
}

class TextDiaryRecommendChallengeViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let saveButtonTapped = PassthroughSubject<Void, Never>()
    let challengeButtonTapped = PassthroughSubject<Int, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldShowErrorModal = false
    @Published var shouldNavigateToEnd = false
    @Published var shouldShowToast = false
    @Published var toastMessage = ""
    @Published var isSaveButtonEnabled = false
    @Published var recommendedChallenges: [RecommendedChallenge] = []
    @Published var emotionKeywords: [EmotionKeyword] = []
    @Published var isLoading = false
    @Published var challengeButtonStates: [Bool] = []
    
    // MARK: - Properties
    weak var delegate: TextDiaryRecommendChallengeViewModelDelegate?
    let diaryId: Int
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let diaryService: DiaryService
    private let challengeService: ChallengeService
    private var buttonCount: Int = 0
    
    // MARK: - Initialization
    init(diaryId: Int, 
         diaryService: DiaryService = DiaryService(),
         challengeService: ChallengeService = ChallengeService()) {
        self.diaryId = diaryId
        self.diaryService = diaryService
        self.challengeService = challengeService
        setupBindings()
        fetchDiaryAnalyze()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        backButtonTapped
            .sink { [weak self] in
                self?.shouldShowErrorModal = true
            }
            .store(in: &cancellables)
        
        saveButtonTapped
            .sink { [weak self] in
                self?.handleSaveButtonTap()
            }
            .store(in: &cancellables)
        
        challengeButtonTapped
            .sink { [weak self] index in
                self?.handleChallengeButtonTap(at: index)
            }
            .store(in: &cancellables)
    }
    
    private func handleChallengeButtonTap(at index: Int) {
        guard index < challengeButtonStates.count else { return }
        
        challengeButtonStates[index].toggle()
        
        if challengeButtonStates[index] {
            buttonCount += 1
        } else {
            buttonCount -= 1
        }
        
        isSaveButtonEnabled = buttonCount > 0
    }
    
    private func handleSaveButtonTap() {
        let selectedChallenges = getSelectedChallenges()
        
        if selectedChallenges.isEmpty {
            toastMessage = "한 개 이상의 챌린지를 선택해 주세요"
            shouldShowToast = true
            return
        }
        
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
    
    private func fetchDiaryAnalyze() {
        isLoading = true
        diaryService.postVoiceDiaryAnalyze(
            diaryId: diaryId,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let data):
                        print(data)
                        self?.recommendedChallenges = data.recommendedChallenges
                        self?.emotionKeywords = data.emotionKeywords
                        self?.challengeButtonStates = Array(repeating: false, count: data.recommendedChallenges.count)
                    case .failure(let error):
                        print(error)
                    }
                }
            })
    }
    
    private func getSelectedChallenges() -> [ChallengeSelectRequestDTO] {
        let date = UserDefaults.standard.string(forKey: "TextDate") ?? ""
        return recommendedChallenges.enumerated().compactMap { index, challenge in
            guard index < challengeButtonStates.count, challengeButtonStates[index] else { return nil }
            return ChallengeSelectRequestDTO(challengeIds: [challenge.id], dtype: challenge.type, date: date)
        }
    }
    
    func handleExitButtonTap() {
        delegate?.didTapExitButton()
    }
}