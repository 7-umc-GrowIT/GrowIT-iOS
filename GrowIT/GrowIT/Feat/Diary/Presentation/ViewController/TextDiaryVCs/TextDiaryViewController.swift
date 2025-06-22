//
//  TextDiaryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit
import EzPopup
import Combine

class TextDiaryViewController: UIViewController, JDiaryCalendarControllerDelegate {
    
    //MARK: - Properties
    let navigationBarManager = NavigationManager()
    let textDiaryView = TextDiaryView()
    private let viewModel = TextDiaryViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    let calVC = JDiaryCalendarController(isDropDown: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
        bindViewModel()
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "직접 일기 작성하기",
            textColor: .black
        )
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(textDiaryView)
        textDiaryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setup Button actions
    private func setupActions() {
        textDiaryView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        textDiaryView.dropDownButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        
        // TextView 변경 감지를 Combine으로 통합
        NotificationCenter.default.publisher(
            for: UITextView.textDidChangeNotification,
            object: textDiaryView.diaryTextField
        )
        .compactMap { ($0.object as? UITextView)?.text }
        .sink { [weak self] text in
            self?.viewModel.diaryTextChanged.send(text)
            self?.updateButtonState() // 버튼 상태 즉시 업데이트
        }
        .store(in: &cancellables)
    }
    
    // 버튼 상태 업데이트 메서드
    private func updateButtonState() {
        let isDateSelected = textDiaryView.dateLabel.text != "날짜를 선택해 주세요"
        let diaryText = textDiaryView.diaryTextField.text ?? ""
        let isTextValid = !diaryText.isEmpty &&
                         diaryText != "일기 내용을 입력하세요" &&
                         diaryText.trimmingCharacters(in: .whitespacesAndNewlines).count >= 100
        
        let isButtonEnabled = isDateSelected && isTextValid
        
        // View에서 버튼 상태 업데이트
        textDiaryView.updateSaveButtonState(isEnabled: isButtonEnabled)
        
        // ViewModel에 상태 전달
        viewModel.saveButtonEnabledChanged.send(isButtonEnabled)
    }
    
    //MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.$shouldNavigateBack
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowToast
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow {
                    CustomToast(containerWidth: 232).show(
                        image: UIImage(named: "toast_Icon") ?? UIImage(),
                        message: self?.viewModel.toastMessage ?? "",
                        font: .heading3SemiBold()
                    )
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowCalendar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.showCalendar()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldNavigateToLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    self?.navigateToLoading()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$selectedDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                if !date.isEmpty {
                    self?.textDiaryView.updateDateLabel(date)
                    self?.updateButtonState() // 날짜 선택 후 버튼 상태 업데이트
                }
            }
            .store(in: &cancellables)
        
        viewModel.$diaryIdForNavigation
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] diaryId in
                self?.navigateToNextScreen(with: diaryId)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }
    
    @objc func saveButtonTapped() {
        let diaryText = textDiaryView.diaryTextField.text == "일기 내용을 입력하세요" ? "" : (textDiaryView.diaryTextField.text ?? "")
        let selectedDate = textDiaryView.dateLabel.text ?? ""
        
        // 직접 처리하여 확실하게 저장되도록 함
        viewModel.processSaveAction(
            diaryText: diaryText,
            date: selectedDate,
            isSaveButtonEnabled: textDiaryView.saveButton.isEnabled
        )
    }
    
    @objc func calendarButtonTapped(_ sender: UIButton) {
        viewModel.calendarButtonTapped.send(sender)
    }
    
    private func showCalendar() {
        let calVC = JDiaryCalendarController(isDropDown: true)
        calVC.configureTheme(isDarkMode: false)
        calVC.delegate = self
        calVC.view.backgroundColor = .clear
        let popupVC = PopupViewController(contentController: calVC, popupWidth: 382, popupHeight: 370)
        present(popupVC, animated: true)
    }
    
    private func navigateToLoading() {
        let nextVC = TextDiaryLoadingViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func navigateToNextScreen(with diaryId: Int) {
        if let loadingVC = navigationController?.topViewController as? TextDiaryLoadingViewController {
            loadingVC.navigateToNextScreen(with: diaryId)
        }
    }
    
    func didSelectDate(_ date: String) {
        viewModel.dateSelected.send(date)
        
        if let presentedVC = self.presentedViewController {
            presentedVC.dismiss(animated: true)
        }
    }
}
