//
//  ErrorViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/13/25.
//

import UIKit
import Combine

class TextDiaryErrorViewController: UIViewController {
    
    weak var delegate: VoiceDiaryErrorDelegate?
    
    // MARK: - Properties
    let errorView = ErrorView()
    private let viewModel = TextDiaryErrorViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var diaryId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        bindViewModel()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        errorView.exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        errorView.continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.delegate = self
        viewModel.diaryId = diaryId
        
        viewModel.$shouldDismiss
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldDismiss in
                if shouldDismiss {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldDismissAndExit
            .filter { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldDismissAndExit in
                if shouldDismissAndExit {
                    self?.dismiss(animated: true) { [weak self] in
                        self?.delegate?.didTapExitButton()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: @objc methods
    @objc func continueButtonTapped() {
        viewModel.continueButtonTapped.send()
    }
    
    @objc func exitButtonTapped() {
        viewModel.exitButtonTapped.send()
    }
}

extension TextDiaryErrorViewController: TextDiaryErrorViewModelDelegate {
    func didTapExitButton() {
        delegate?.didTapExitButton()
    }
}
