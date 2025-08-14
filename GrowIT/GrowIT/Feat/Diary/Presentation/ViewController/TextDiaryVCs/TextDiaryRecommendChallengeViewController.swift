//
//  TextDiaryRecommendChallengeViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit
import Combine

class TextDiaryRecommendChallengeViewController: UIViewController, VoiceDiaryErrorDelegate {
    
    //MARK: - Properties
    let textDiaryRecommendChallengeView = TextDiaryRecommendChallengeView()
    let navigationBarManager = NavigationManager()
    private let viewModel: TextDiaryRecommendChallengeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    let diaryId: Int
    
    private var challengeViews: [ChallengeItemView] {
        return textDiaryRecommendChallengeView.challengeStackView.challengeViews
    }
    
    init(diaryId: Int) {
        self.diaryId = diaryId
        self.viewModel = TextDiaryRecommendChallengeViewModel(diaryId: diaryId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupUI()
        setupNavigationBar()
        setupActions()
        bindViewModel()
        viewModel.delegate = self
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
        view.addSubview(textDiaryRecommendChallengeView)
        textDiaryRecommendChallengeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setup Actions
    private func setupActions() {
        challengeViews.forEach { challengeView in
            challengeView.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
        textDiaryRecommendChallengeView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.$shouldShowErrorModal
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.showErrorModal()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldNavigateToEnd
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    let nextVC = TextDiaryEndViewController()
                    nextVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowToast
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow {
                    CustomToast(containerWidth: 314).show(
                        image: UIImage(named: "toast_Icon") ?? UIImage(),
                        message: self?.viewModel.toastMessage ?? "",
                        font: .heading3SemiBold()
                    )
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isSaveButtonEnabled
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.textDiaryRecommendChallengeView.saveButton.setButtonState(
                    isEnabled: isEnabled,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        viewModel.$recommendedChallenges
            .receive(on: DispatchQueue.main)
            .sink { [weak self] challenges in
                self?.textDiaryRecommendChallengeView.updateChallenges(challenges)
            }
            .store(in: &cancellables)
        
        viewModel.$emotionKeywords
            .receive(on: DispatchQueue.main)
            .sink { [weak self] keywords in
                self?.textDiaryRecommendChallengeView.updateEmo(emotionKeywords: keywords)
            }
            .store(in: &cancellables)
        
        viewModel.$challengeButtonStates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] states in
                self?.updateChallengeButtonStates(states)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }
    
    @objc func saveButtonTapped() {
        viewModel.saveButtonTapped.send()
    }
    
    @objc func buttonTapped(_ sender: CircleCheckButton) {
        guard let index = challengeViews.firstIndex(where: { $0.button == sender }) else { return }
        viewModel.challengeButtonTapped.send(index)
    }
    
    private func showErrorModal() {
        let prevVC = TextDiaryErrorViewController()
        prevVC.delegate = self
        prevVC.diaryId = diaryId
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    private func updateChallengeButtonStates(_ states: [Bool]) {
        for (index, state) in states.enumerated() {
            if index < challengeViews.count {
                let challengeView = challengeViews[index]
                if state != challengeView.button.isSelectedState() {
                    challengeView.button.toggleState()
                }
            }
        }
    }
    
//    func didTapExitButton() {
//        navigationController?.popToRootViewController(animated: true)
//    }
}

extension TextDiaryRecommendChallengeViewController: TextDiaryRecommendChallengeViewModelDelegate {
    func didTapExitButton() {
        navigationController?.popToRootViewController(animated: true)
    }
}
