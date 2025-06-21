//
//  TextDiaryEndViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/13/25.
//

import UIKit
import Combine

class TextDiaryEndViewController: UIViewController {

    //MARK: - Properties
    let textDiaryEndView =  TextDiaryEndView()
    let navigationBarManager = NavigationManager()
    private let viewModel = TextDiaryEndViewModel()
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
        view.addSubview(textDiaryEndView)
        textDiaryEndView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setup Actions
    private func setupActions() {
        textDiaryEndView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
        
        viewModel.$shouldNavigateToHome
            .filter { $0 }
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
    
    @objc func nextButtonTapped() {
        viewModel.nextButtonTapped.send()
    }

}
