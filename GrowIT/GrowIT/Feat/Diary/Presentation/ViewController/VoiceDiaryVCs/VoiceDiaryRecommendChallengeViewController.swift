//
//  VoiceDiaryRecommendChallengeViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import Combine

class VoiceDiaryRecommendChallengeViewController: UIViewController, VoiceDiaryErrorDelegate {
    
    // MARK: Properties
    let voiceDiaryRecommendChallengeView = VoiceDiaryRecommendChallengeView()
    let navigationBarManager = NavigationManager()
    
    var diaryId = 0
    var recommendedChallenges: [RecommendedChallenge] = []
    var emotionKeywords: [EmotionKeyword] = []
    
    private var viewModel: VoiceDiaryRecommendChallengeViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private var challengeViews: [VoiceChallengeItemView] {
        return voiceDiaryRecommendChallengeView.challengeStackView.challengeViews
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = false
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupNavigationBar()
        setupActions()
        setupBindings()
        
        voiceDiaryRecommendChallengeView.updateChallenges(recommendedChallenges)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        viewModel.viewWillAppear.send()
    }
    
    private func setupViewModel() {
        viewModel = VoiceDiaryRecommendChallengeViewModel(
            diaryId: diaryId,
            recommendedChallenges: recommendedChallenges,
            emotionKeywords: emotionKeywords
        )
    }
    
    //MARK: - Setup Navigation Bar
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
        view.addSubview(voiceDiaryRecommendChallengeView)
        voiceDiaryRecommendChallengeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setup Actions
    private func setupActions() {
        challengeViews.forEach { challengeView in
            challengeView.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        
        voiceDiaryRecommendChallengeView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    // MARK: Setup Bindings
    private func setupBindings() {
        viewModel.$shouldPresentRecommendError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldPresent in
                if shouldPresent {
                    self?.presentRecommendError()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldNavigateToEnd
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    self?.navigateToEnd()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowChallengeSelectionToast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.showChallengeSelectionToast()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isSaveButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.voiceDiaryRecommendChallengeView.saveButton.setButtonState(
                    isEnabled: isEnabled,
                    enabledColor: .primary400,
                    disabledColor: .gray700,
                    enabledTitleColor: .black,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        viewModel.$emotionKeywords
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keywords in
                self?.voiceDiaryRecommendChallengeView.updateEmo(emotionKeywords: keywords)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }
    
    @objc func nextVC() {
        viewModel.saveButtonTapped.send()
        let selectedChallenges = viewModel.createSelectedChallenges(from: challengeViews)
        if !selectedChallenges.isEmpty {
            viewModel.postSelectedChallenges(selectedChallenges)
        }
    }
    
    @objc func buttonTapped(_ sender: CircleCheckButton) {
        viewModel.challengeButtonTapped.send(sender.isSelectedState())
    }
    
    // MARK: - Private Navigation Methods
    private func presentRecommendError() {
        let prevVC = VoiceDiaryRecommendErrorViewController()
        prevVC.delegate = self
        prevVC.diaryId = diaryId
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    private func navigateToEnd() {
        let nextVC = VoiceDiaryEndViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func showChallengeSelectionToast() {
        CustomToast(containerWidth: 314).show(
            image: UIImage(named: "toast_Icon") ?? UIImage(),
            message: "한 개 이상의 챌린지를 선택해 주세요",
            font: .heading3SemiBold()
        )
    }
    
    func didTapExitButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}
