//
//  VoiceDiarySummaryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import Combine

class VoiceDiarySummaryViewController: UIViewController, VoiceDiaryErrorDelegate {
    
    // MARK: Properties
    let voiceDiarySummaryView = VoiceDiarySummaryView()
    let navigationBarManager = NavigationManager()
    let diaryContent: String
    let diaryId: Int
    let date: String
    
    private var viewModel: VoiceDiarySummaryViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    init(diaryContent: String, diaryId: Int, date: String) {
        self.diaryContent = diaryContent
        self.diaryId = diaryId
        self.date = date
        super.init(nibName: nil, bundle: nil)
        self.viewModel = VoiceDiarySummaryViewModel(diaryId: diaryId, diaryContent: diaryContent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.send()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupActions()
        setupBindings()
        
        voiceDiarySummaryView.configure(text: diaryContent)
        voiceDiarySummaryView.updateDate(with: date)
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
        view.addSubview(voiceDiarySummaryView)
        voiceDiarySummaryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        voiceDiarySummaryView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        let labelAction = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        voiceDiarySummaryView.descriptionLabel.addGestureRecognizer(labelAction)
    }
    
    // MARK: Setup Bindings
    private func setupBindings() {
        viewModel.$shouldPresentSummaryError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldPresent in
                if shouldPresent {
                    self?.presentSummaryError()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldNavigateToRecommendChallenge
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    self?.navigateToRecommendChallenge()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldPresentFix
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldPresent in
                if shouldPresent {
                    self?.presentFix()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$emotionKeywords
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keywords in
                self?.voiceDiarySummaryView.updateEmo(emotionKeywords: keywords)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }
    
    @objc func nextVC() {
        viewModel.saveButtonTapped.send()
    }
    
    @objc func labelTapped() {
        viewModel.descriptionLabelTapped.send()
    }
    
    // MARK: - Private Navigation Methods
    private func presentSummaryError() {
        let prevVC = VoiceDiarySummaryErrorViewController()
        prevVC.delegate = self
        prevVC.diaryId = diaryId
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    private func navigateToRecommendChallenge() {
        let nextVC = VoiceDiaryRecommendChallengeViewController()
        nextVC.diaryId = diaryId
        nextVC.recommendedChallenges = viewModel.recommendedChallenges
        nextVC.emotionKeywords = viewModel.emotionKeywords
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func presentFix() {
        let nextVC = VoiceDiaryFixViewController(text: diaryContent)
        nextVC.diaryId = diaryId
        nextVC.emotionKeywords = viewModel.emotionKeywords
        nextVC.recommendedChallenges = viewModel.recommendedChallenges
        let navController = UINavigationController(rootViewController: nextVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.6)
    }
    
    func didTapExitButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}
