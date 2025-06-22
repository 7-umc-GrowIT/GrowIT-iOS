//
//  VoiceDiaryEntryViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-22.
//

import UIKit
import Combine

class VoiceDiaryEntryViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let recordButtonTapped = PassthroughSubject<Void, Never>()
    let helpLabelTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldNavigateBack = false
    @Published var shouldNavigateToDateSelect = false
    @Published var shouldPresentTip = false
    
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
        
        recordButtonTapped
            .sink { [weak self] in
                self?.shouldNavigateToDateSelect = true
            }
            .store(in: &cancellables)
        
        helpLabelTapped
            .sink { [weak self] in
                self?.shouldPresentTip = true
            }
            .store(in: &cancellables)
    }
}