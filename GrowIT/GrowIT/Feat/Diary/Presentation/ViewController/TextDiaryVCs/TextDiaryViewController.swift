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
        let userDiary = textDiaryView.diaryTextField.text ?? ""
        let date = textDiaryView.dateLabel.text ?? ""
        let isEnabled = textDiaryView.saveButton.isEnabled
        
        viewModel.processSaveAction(diaryText: userDiary, date: date, isSaveButtonEnabled: isEnabled)
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
