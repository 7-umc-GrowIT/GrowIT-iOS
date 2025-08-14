//
//  VoiceDiaryFixViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import Combine

class VoiceDiaryFixViewController: UIViewController {
    
    // MARK: Properties
    let text: String
    let voiceDiaryFixView = VoiceDiaryFixView()
    
    var diaryId = 0
    var recommendedChallenges: [RecommendedChallenge] = []
    var emotionKeywords: [EmotionKeyword] = []
    
    private var viewModel: VoiceDiaryFixViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupDelegate()
        setupActions()
        setupBindings()
    }
    
    private func setupViewModel() {
        viewModel = VoiceDiaryFixViewModel(
            originalText: text,
            diaryId: diaryId,
            recommendedChallenges: recommendedChallenges,
            emotionKeywords: emotionKeywords
        )
    }
    
    // MARK: Setup UI
    private func setupUI() {
        view.addSubview(voiceDiaryFixView)
        voiceDiaryFixView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        voiceDiaryFixView.configure(text: text)
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        voiceDiaryFixView.cancelButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        voiceDiaryFixView.fixButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    // MARK: Setup Delegate
    private func setupDelegate() {
        voiceDiaryFixView.textView.delegate = self
    }
    
    // MARK: Setup Bindings
    private func setupBindings() {
        viewModel.$shouldDismiss
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldDismiss in
                if shouldDismiss {
                    self?.dismiss(animated: true, completion: nil)
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
        
        viewModel.$isTextTooShort
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isTooShort in
                self?.voiceDiaryFixView.lessThanHundred(isEnabled: isTooShort)
            }
            .store(in: &cancellables)
        
        viewModel.$isFixButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.voiceDiaryFixView.fixButton.setButtonState(
                    isEnabled: isEnabled,
                    enabledColor: .primary400,
                    disabledColor: .gray700,
                    enabledTitleColor: .black,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        viewModel.cancelButtonTapped.send()
    }
    
    @objc func nextVC() {
        viewModel.fixButtonTapped.send()
    }
    
    // MARK: - Private Navigation Methods
    private func navigateToRecommendChallenge() {
        if let presentingVC = presentingViewController as? UINavigationController {
            dismiss(animated: true) {
                let nextVC = VoiceDiaryRecommendChallengeViewController()
                nextVC.diaryId = self.viewModel.getDiaryId()
                nextVC.recommendedChallenges = self.viewModel.getRecommendedChallenges()
                nextVC.emotionKeywords = self.viewModel.getEmotionKeywords()
                presentingVC.pushViewController(nextVC, animated: true)
            }
        }
    }
}

extension VoiceDiaryFixViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        viewModel.textChanged.send(textView.text)
    }
}
