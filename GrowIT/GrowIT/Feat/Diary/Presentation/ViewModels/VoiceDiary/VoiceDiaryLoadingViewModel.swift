//
//  VoiceDiaryLoadingViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-22.
//

import UIKit
import Combine

class VoiceDiaryLoadingViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let navigationDataReceived = PassthroughSubject<(String, Int, String), Never>()
    
    // MARK: - Output Publishers
    @Published var shouldNavigateToSummary = false
    @Published var diaryContent = ""
    @Published var diaryId = 0
    @Published var date = ""
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        backButtonTapped
            .sink { [weak self] in
                // No action needed as per original implementation
            }
            .store(in: &cancellables)
        
        navigationDataReceived
            .sink { [weak self] content, diaryId, date in
                self?.diaryContent = content
                self?.diaryId = diaryId
                self?.date = date
                self?.shouldNavigateToSummary = true
            }
            .store(in: &cancellables)
    }
}