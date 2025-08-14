//
//  VoiceDiaryLoadingViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import Combine

class VoiceDiaryLoadingViewController: UIViewController {

    //MARK: - Properties
    let voiceDiaryLoadingView = VoiceDiaryLoadingView()
    let navigationBarManager = NavigationManager()
    
    private var diaryContent: String?
    weak var delegate: VoiceDiaryRecordDelegate?
    
    private let viewModel = VoiceDiaryLoadingViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
    }
    
    // MARK: Setup Navigation Bar
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .clear
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "",
            textColor: .black
        )
    }

    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(voiceDiaryLoadingView)
        voiceDiaryLoadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.$shouldNavigateToSummary
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    let nextVC = VoiceDiarySummaryViewController(
                        diaryContent: self?.viewModel.diaryContent ?? "",
                        diaryId: self?.viewModel.diaryId ?? 0,
                        date: self?.viewModel.date ?? ""
                    )
                    nextVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }

    func navigateToNextScreen(with content: String, diaryId: Int, date: String) {
        self.diaryContent = content
        viewModel.navigationDataReceived.send((content, diaryId, date))
    }
}
