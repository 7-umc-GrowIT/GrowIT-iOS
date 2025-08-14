//
//  VoiceDiaryEndViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import Combine

class VoiceDiaryEndViewController: UIViewController {

    //MARK: - Properties
    let voiceDiaryEndView = VoiceDiaryEndView()
    let navigationBarManager = NavigationManager()
    
    private let viewModel = VoiceDiaryEndViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupActions()
        setupNavigationBar()
        bindViewModel()
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
            textColor: .white
        )
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(voiceDiaryEndView)
        voiceDiaryEndView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setup Actions
    private func setupActions() {
        voiceDiaryEndView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    //MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.$shouldNavigateToTabBar
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    let nextVC = CustomTabBarController(initialIndex: 2)
                    self?.navigationController?.pushViewController(nextVC, animated: false)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }
    
    @objc func nextVC() {
        viewModel.nextButtonTapped.send()
    }
}
