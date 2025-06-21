//
//  TextDiaryErrorViewModel.swift
//  GrowIT
//
//  Created by Claude on 2025-06-21.
//

import UIKit
import Combine

protocol TextDiaryErrorViewModelDelegate: AnyObject {
    func didTapExitButton()
}

class TextDiaryErrorViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let continueButtonTapped = PassthroughSubject<Void, Never>()
    let exitButtonTapped = PassthroughSubject<Void, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldDismiss = false
    @Published var shouldDismissAndExit = false
    @Published var isLoading = false
    
    // MARK: - Properties
    weak var delegate: TextDiaryErrorViewModelDelegate?
    var diaryId: Int = 0
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let diaryService: DiaryService
    
    // MARK: - Initialization
    init(diaryService: DiaryService = DiaryService()) {
        self.diaryService = diaryService
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        continueButtonTapped
            .sink { [weak self] in
                self?.shouldDismiss = true
            }
            .store(in: &cancellables)
        
        exitButtonTapped
            .sink { [weak self] in
                self?.handleExitButtonTap()
            }
            .store(in: &cancellables)
    }
    
    private func handleExitButtonTap() {
        callDeleteDiary()
    }
    
    private func callDeleteDiary() {
        isLoading = true
        diaryService.deleteDiary(
            diaryId: diaryId,
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let data):
                        print("Success: \(data)")
                        self?.shouldDismissAndExit = true
                    case .failure(let error):
                        print("Error: \(error)")
                        self?.shouldDismissAndExit = true
                    }
                }
            })
    }
}