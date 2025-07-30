//
//  ErrorPopupViewController.swift
//  GrowIT
//
//  Created by 강희정 on 7/23/25.
//

import UIKit
import Combine

final class ErrorPopupViewController: UIViewController {
    
    private let errorView = ErrorView()
    private let viewModel = ErrorPopupViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let icon: String
    private let firstLabel: String
    private let secondLabel: String
    private let title1: String
    private let title2: String
    
    var onExit: (() -> Void)?
    var onContinue: (() -> Void)?
    
    init(icon: String,
         firstLabel: String,
         secondLabel: String,
         title1: String = "나가기",
         title2: String = "계속 진행하기") {
        self.icon = icon
        self.firstLabel = firstLabel
        self.secondLabel = secondLabel
        self.title1 = title1
        self.title2 = title2
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        setupActions()
    }
    
    private func setupUI() {
        view.addSubview(errorView)
        errorView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        errorView.configure(
            icon: icon,
            fisrtLabel: firstLabel,
            secondLabel: secondLabel,
            firstColor: .gray900,
            secondColor: .gray700,
            title1: title1,
            title1Color1: .gray400,
            title1Background: .gray100,
            title2: title2,
            title1Color2: .white,
            title2Background: .negative400,
            targetText: "",
            viewColor: .white
        )
    }
    
    private func bindViewModel() {
        viewModel.actionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                switch action {
                case .exit:
                    self?.dismiss(animated: true) { self?.onExit?() }
                case .continue:
                    self?.dismiss(animated: true) { self?.onContinue?() }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        errorView.exitButton.addTarget(self, action: #selector(exitTapped), for: .touchUpInside)
        errorView.continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    @objc private func exitTapped() { viewModel.exitTapped() }
    @objc private func continueTapped() { viewModel.continueTapped() }
}
