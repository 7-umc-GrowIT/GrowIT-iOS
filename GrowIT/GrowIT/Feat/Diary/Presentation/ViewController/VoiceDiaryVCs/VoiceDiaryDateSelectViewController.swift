//
//  VoiceDiaryDateSelectViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import Combine

class VoiceDiaryDateSelectViewController: UIViewController, JDiaryCalendarControllerDelegate {
    
    // MARK: Properties
    let voiceDiaryDateSelectView = VoiceDiaryDateSelectView()
    let navigationBarManager = NavigationManager()
    let calVC = JDiaryCalendarController(isDropDown: true)
    
    private let viewModel = VoiceDiaryDateSelectViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupUI()
        setupNavigationBar()
        setupActions()
        setupDelegate()
        bindViewModel()
    }
    
    // MARK: Setup Navigation Bar
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .white
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "",
            textColor: .black
        )
    }
    
    // MARK: Setup UI
    private func setupUI() {
        view.addSubview(voiceDiaryDateSelectView)
        voiceDiaryDateSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(calVC.view)
        addChild(calVC)
        calVC.configureTheme(isDarkMode: true)
        calVC.didMove(toParent: self)
        calVC.view.snp.makeConstraints { make in
            make.top.equalTo(voiceDiaryDateSelectView.dateView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.Screen.ScreenHeight * (Constants.Screen.CalenderRatio))
        }
        calVC.view.isHidden = true
    }
    
    private func updateDateSelectionUI(isValid: Bool) {
        let v = voiceDiaryDateSelectView
        if isValid {
            v.dateLabel.textColor = .gray300
            v.dateView.layer.borderColor = UIColor.clear.cgColor
            v.toggleButton.tintColor = .gray500
            v.dateSelectLabel.textColor = .white
            v.warningLabel.isHidden = true
        } else {
            v.dateLabel.textColor = .negative100
            v.dateView.layer.borderColor = UIColor.negative100.cgColor
            v.toggleButton.tintColor = .negative100
            v.dateSelectLabel.textColor = .negative100
            v.warningLabel.isHidden = false
        }
        
       
    }
    
    // MARK: Setup Delegate
    private func setupDelegate() {
        calVC.delegate = self
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        voiceDiaryDateSelectView.startButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        voiceDiaryDateSelectView.helpLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
        
        voiceDiaryDateSelectView.dateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleTapped)))
    }
    
    
    // MARK: ViewModel Binding
    private func bindViewModel() {
        viewModel.$shouldNavigateBack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldNavigateToRecord
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    let nextVC = VoiceDiaryRecordViewController()
                    nextVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldPresentTip
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldPresent in
                if shouldPresent {
                    let nextVC = VoiceDiaryTipViewController()
                    nextVC.modalPresentationStyle = .pageSheet
                    self?.presentPageSheet(viewController: nextVC, detentFraction: 0.37)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldToggleCalendar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldToggle in
                if shouldToggle {
                    let isVisible = self?.viewModel.getCalendarVisibility() ?? false
                    self?.calVC.view.isHidden = !isVisible
                }
            }
            .store(in: &cancellables)
        
        viewModel.$selectedDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                if !date.isEmpty {
                    self?.voiceDiaryDateSelectView.updateDateLabel(date)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isDateValid
            .combineLatest(viewModel.$shouldShowWarning)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid, shouldShowWarning in
                self?.updateDateSelectionUI(isValid: isValid)
            }
            .store(in: &cancellables)
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }
    
    @objc func nextVC() {
        viewModel.startButtonTapped.send()
    }
    
    @objc func labelTapped() {
        viewModel.helpLabelTapped.send()
    }
    
    @objc func toggleTapped() {
        viewModel.toggleTapped.send()
    }
    
    func didSelectDate(_ date: String) {
        viewModel.dateSelected.send(date)
    }
}
