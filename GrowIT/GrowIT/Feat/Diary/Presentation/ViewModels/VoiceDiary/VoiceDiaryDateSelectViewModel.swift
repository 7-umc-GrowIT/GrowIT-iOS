//
//  VoiceDiaryDateSelectViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-22.
//

import UIKit
import Combine

class VoiceDiaryDateSelectViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let startButtonTapped = PassthroughSubject<Void, Never>()
    let helpLabelTapped = PassthroughSubject<Void, Never>()
    let toggleTapped = PassthroughSubject<Void, Never>()
    let dateSelected = PassthroughSubject<String, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldNavigateBack = false
    @Published var shouldNavigateToRecord = false
    @Published var shouldPresentTip = false
    @Published var shouldToggleCalendar = false
    @Published var selectedDate = ""
    @Published var isDateValid = true
    @Published var shouldShowWarning = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var isCalendarVisible = false
    
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
        
        startButtonTapped
            .sink { [weak self] in
                self?.handleStartButtonTap()
            }
            .store(in: &cancellables)
        
        helpLabelTapped
            .sink { [weak self] in
                self?.shouldPresentTip = true
            }
            .store(in: &cancellables)
        
        toggleTapped
            .sink { [weak self] in
                self?.isCalendarVisible.toggle()
                self?.shouldToggleCalendar = true
            }
            .store(in: &cancellables)
        
        dateSelected
            .sink { [weak self] date in
                self?.handleDateSelection(date)
            }
            .store(in: &cancellables)
    }
    
    private func handleStartButtonTap() {
        if selectedDate.isEmpty || selectedDate == "일기 날짜를 선택해 주세요" {
            isDateValid = false
            shouldShowWarning = true
        } else {
            isDateValid = true
            shouldShowWarning = false
            shouldNavigateToRecord = true
        }
    }
    
    private func handleDateSelection(_ date: String) {
        selectedDate = date
        UserDefaults.standard.set(date, forKey: "VoiceDate")
        isCalendarVisible = false
        shouldToggleCalendar = true
        isDateValid = true
        shouldShowWarning = false
    }
    
    // MARK: - Public Methods
    func getCalendarVisibility() -> Bool {
        return isCalendarVisible
    }
}