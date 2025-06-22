//
//  VoiceDiaryFixViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-22.
//

import UIKit
import Combine

class VoiceDiaryFixViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let cancelButtonTapped = PassthroughSubject<Void, Never>()
    let fixButtonTapped = PassthroughSubject<Void, Never>()
    let textChanged = PassthroughSubject<String, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldDismiss = false
    @Published var shouldNavigateToRecommendChallenge = false
    @Published var isTextTooShort = false
    @Published var isFixButtonEnabled = false
    @Published var textLength = 0
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let originalText: String
    private let diaryId: Int
    private let recommendedChallenges: [RecommendedChallenge]
    private let emotionKeywords: [EmotionKeyword]
    
    // MARK: - Initialization
    init(originalText: String, diaryId: Int, recommendedChallenges: [RecommendedChallenge], emotionKeywords: [EmotionKeyword]) {
        self.originalText = originalText
        self.diaryId = diaryId
        self.recommendedChallenges = recommendedChallenges
        self.emotionKeywords = emotionKeywords
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        cancelButtonTapped
            .sink { [weak self] in
                self?.shouldDismiss = true
            }
            .store(in: &cancellables)
        
        fixButtonTapped
            .sink { [weak self] in
                self?.shouldNavigateToRecommendChallenge = true
            }
            .store(in: &cancellables)
        
        textChanged
            .sink { [weak self] text in
                self?.handleTextChange(text)
            }
            .store(in: &cancellables)
    }
    
    private func handleTextChange(_ text: String) {
        textLength = text.count
        isTextTooShort = textLength < 100
        
        if isTextTooShort {
            isFixButtonEnabled = false
        } else {
            isFixButtonEnabled = text != originalText
        }
    }
    
    // MARK: - Public Methods
    func getOriginalText() -> String {
        return originalText
    }
    
    func getDiaryId() -> Int {
        return diaryId
    }
    
    func getRecommendedChallenges() -> [RecommendedChallenge] {
        return recommendedChallenges
    }
    
    func getEmotionKeywords() -> [EmotionKeyword] {
        return emotionKeywords
    }
}