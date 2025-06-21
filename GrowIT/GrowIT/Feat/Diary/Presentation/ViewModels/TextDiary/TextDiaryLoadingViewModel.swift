//
//  TextDiaryLoadingViewModel.swift
//  GrowIT
//
//  Created by Claude on 2025-06-21.
//

import UIKit
import Combine

class TextDiaryLoadingViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let navigationTriggered = PassthroughSubject<Int, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldNavigateToRecommendChallenge = false
    @Published var diaryIdForNavigation: Int?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        navigationTriggered
            .sink { [weak self] diaryId in
                self?.diaryIdForNavigation = diaryId
                self?.shouldNavigateToRecommendChallenge = true
            }
            .store(in: &cancellables)
    }
}