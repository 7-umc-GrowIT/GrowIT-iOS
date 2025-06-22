//
//  TextDiaryViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-21.
//

import UIKit
import Combine

class TextDiaryViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let saveButtonTapped = PassthroughSubject<Void, Never>()
    let calendarButtonTapped = PassthroughSubject<UIButton, Never>()
    let dateSelected = PassthroughSubject<String, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldShowToast = false
    @Published var toastMessage = ""
    @Published var selectedDate = ""
    @Published var isLoading = false
    @Published var shouldNavigateToLoading = false
    @Published var shouldNavigateBack = false
    @Published var shouldShowCalendar = false
    @Published var calendarSender: UIButton?
    @Published var diaryIdForNavigation: Int?
    
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
        backButtonTapped
            .sink { [weak self] in
                self?.shouldNavigateBack = true
            }
            .store(in: &cancellables)
        
        saveButtonTapped
            .sink { [weak self] in
                self?.handleSaveButtonTap()
            }
            .store(in: &cancellables)
        
        calendarButtonTapped
            .sink { [weak self] sender in
                self?.calendarSender = sender
                self?.shouldShowCalendar = true
            }
            .store(in: &cancellables)
        
        dateSelected
            .sink { [weak self] date in
                self?.selectedDate = date
            }
            .store(in: &cancellables)
    }
    
    private func handleSaveButtonTap() {
        // This will be called by the ViewController with diary text and date
    }
    
    func processSaveAction(diaryText: String, date: String, isSaveButtonEnabled: Bool) {
        if !isSaveButtonEnabled {
            toastMessage = "일기를 더 작성해 주세요"
            shouldShowToast = true
        } else {
            shouldNavigateToLoading = true
            callPostTextDiary(userDiary: diaryText, date: date)
        }
    }
    
    private func callPostTextDiary(userDiary: String, date: String) {
        isLoading = true
        let convertedDate = convertDateFormat(from: date)
        UserDefaults.standard.set(convertedDate, forKey: "TextDate")
        
        diaryService.postTextDiary(
            data: DiaryRequestDTO(
                content: userDiary,
                date: convertedDate ?? ""),
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let data):
                        self?.diaryIdForNavigation = data.diaryId
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        )
    }
    
    private func convertDateFormat(from originalDate: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy년 M월 d일"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"

        if let date = inputFormatter.date(from: originalDate) {
            return outputFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
