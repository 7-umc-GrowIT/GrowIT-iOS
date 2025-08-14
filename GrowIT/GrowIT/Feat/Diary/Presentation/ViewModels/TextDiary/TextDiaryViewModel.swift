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
    let diaryTextChanged = PassthroughSubject<String, Never>()
    let saveButtonEnabledChanged = PassthroughSubject<Bool, Never>()
    
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
    private var currentDiaryText = ""
    private var isSaveButtonEnabled = false
    
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
        
        diaryTextChanged
            .sink { [weak self] text in
                self?.currentDiaryText = text
                print("Diary text changed: \(text.count) characters")
            }
            .store(in: &cancellables)
        
        saveButtonEnabledChanged
            .sink { [weak self] isEnabled in
                self?.isSaveButtonEnabled = isEnabled
                print("Save button enabled state changed: \(isEnabled)")
            }
            .store(in: &cancellables)
    }
    
    private func handleSaveButtonTap() {
        print("handleSaveButtonTap called - isEnabled: \(isSaveButtonEnabled)")
        if !isSaveButtonEnabled {
            toastMessage = "일기를 더 작성해 주세요"
            shouldShowToast = true
        } else {
            shouldNavigateToLoading = true
            callPostTextDiary(userDiary: currentDiaryText, date: selectedDate)
        }
    }
    
    // MARK: - Public method for processing save action
    func processSaveAction(diaryText: String, date: String, isSaveButtonEnabled: Bool) {
        print("processSaveAction called:")
        print("- diaryText: \(diaryText.count) characters")
        print("- date: \(date)")
        print("- isSaveButtonEnabled: \(isSaveButtonEnabled)")
        
        // 직접 검증을 한 번 더 수행
        let isDateValid = date != "날짜를 선택해 주세요" && !date.isEmpty
        let isTextValid = !diaryText.isEmpty &&
                         diaryText != "일기 내용을 입력하세요" &&
                         diaryText.trimmingCharacters(in: .whitespacesAndNewlines).count >= 100
        
        print("- isDateValid: \(isDateValid)")
        print("- isTextValid: \(isTextValid)")
        
        if !isDateValid {
            toastMessage = "날짜를 선택해 주세요"
            shouldShowToast = true
        } else if !isTextValid {
            toastMessage = "일기를 100자 이상 작성해 주세요"
            shouldShowToast = true
        } else {
            print("All validations passed, navigating to loading...")
            shouldNavigateToLoading = true
            callPostTextDiary(userDiary: diaryText, date: date)
        }
    }
    
    private func callPostTextDiary(userDiary: String, date: String) {
        isLoading = true
        let convertedDate = convertDateFormat(from: date)
        UserDefaults.standard.set(convertedDate, forKey: "TextDate")
        
        print("Calling postTextDiary with:")
        print("- userDiary: \(userDiary.count) characters")
        print("- convertedDate: \(convertedDate ?? "nil")")
        
        diaryService.postTextDiary(
            data: DiaryRequestDTO(
                content: userDiary,
                date: convertedDate ?? ""),
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let data):
                        print("Diary saved successfully with ID: \(data.diaryId)")
                        self?.diaryIdForNavigation = data.diaryId
                    case .failure(let error):
                        print("Error saving diary: \(error)")
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
