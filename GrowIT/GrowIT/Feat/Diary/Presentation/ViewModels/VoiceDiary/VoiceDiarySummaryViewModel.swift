//
//  VoiceDiarySummaryViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-22.
//

import UIKit
import Combine

class VoiceDiarySummaryViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let saveButtonTapped = PassthroughSubject<Void, Never>()
    let descriptionLabelTapped = PassthroughSubject<Void, Never>()
    let viewWillAppear = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldPresentSummaryError = false
    @Published var shouldNavigateToRecommendChallenge = false
    @Published var shouldPresentFix = false
    @Published var emotionKeywords: [EmotionKeyword] = []
    @Published var recommendedChallenges: [RecommendedChallenge] = []
    @Published var isLoading = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let diaryService: DiaryService
    private let diaryId: Int
    private let diaryContent: String
    
    // MARK: - Initialization
    init(diaryService: DiaryService = DiaryService(), diaryId: Int, diaryContent: String) {
        self.diaryService = diaryService
        self.diaryId = diaryId
        self.diaryContent = diaryContent
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        backButtonTapped
            .sink { [weak self] in
                self?.shouldPresentSummaryError = true
            }
            .store(in: &cancellables)
        
        saveButtonTapped
            .sink { [weak self] in
                self?.shouldNavigateToRecommendChallenge = true
            }
            .store(in: &cancellables)
        
        descriptionLabelTapped
            .sink { [weak self] in
                self?.shouldPresentFix = true
            }
            .store(in: &cancellables)
        
        viewWillAppear
            .sink { [weak self] in
                self?.fetchDiaryAnalyze()
            }
            .store(in: &cancellables)
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
                        self?.emotionKeywords = data.emotionKeywords
                        self?.recommendedChallenges = data.recommendedChallenges
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            })
    }
    
    // MARK: - Public Methods
    func getDiaryId() -> Int {
        return diaryId
    }
    
    func getDiaryContent() -> String {
        return diaryContent
    }
}