//
//  VoiceDiaryEndViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-22.
//

import UIKit
import Combine

class VoiceDiaryEndViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let nextButtonTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldNavigateToTabBar = false
    
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
        
        nextButtonTapped
            .sink { [weak self] in
                self?.shouldNavigateToTabBar = true
            }
            .store(in: &cancellables)
    }
}