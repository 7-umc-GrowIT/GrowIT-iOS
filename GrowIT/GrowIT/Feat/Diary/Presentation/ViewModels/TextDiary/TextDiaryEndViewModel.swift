//
//  TextDiaryEndViewModel.swift
//  GrowIT
//
//  Created by Claude on 2025-06-21.
//

import UIKit
import Combine

class TextDiaryEndViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let nextButtonTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldNavigateBack = false
    @Published var shouldNavigateToHome = false
    
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
                self?.shouldNavigateBack = true
            }
            .store(in: &cancellables)
        
        nextButtonTapped
            .sink { [weak self] in
                self?.shouldNavigateToHome = true
            }
            .store(in: &cancellables)
    }
}