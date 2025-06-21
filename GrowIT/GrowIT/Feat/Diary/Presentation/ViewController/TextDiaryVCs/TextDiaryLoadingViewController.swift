//
//  TextDiaryLoadingViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit
import Combine

class TextDiaryLoadingViewController: UIViewController {
    
    //MARK: - Properties
    let textDiaryLoadingView = TextDiaryLoadingView()
    private let viewModel = TextDiaryLoadingViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
        bindViewModel()
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(textDiaryLoadingView)
        textDiaryLoadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.$shouldNavigateToRecommendChallenge
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate, let diaryId = self?.viewModel.diaryIdForNavigation {
                    let nextVC = TextDiaryRecommendChallengeViewController(diaryId: diaryId)
                    nextVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    func navigateToNextScreen(with diaryId: Int) {
        viewModel.navigationTriggered.send(diaryId)
    }
}
