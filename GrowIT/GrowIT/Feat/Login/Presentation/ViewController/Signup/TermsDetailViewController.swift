//
//  TermsDetailViewController.swift
//  GrowIT
//
//  Created by 강희정 on 2/18/25.
//

import UIKit
import Combine

class TermsDetailViewController: UIViewController, UITextViewDelegate {
    
    private let navigationBarManager = NavigationManager()
    private let termsDetailView = TermsDetailView()
    private var viewModel: TermsDetailViewModel!
    private weak var parentViewModel: TermsAgreeViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    func configure(termId: Int, content: String, parentViewModel: TermsAgreeViewModel) {
        self.parentViewModel = parentViewModel
        self.viewModel = TermsDetailViewModel(termId: termId, content: content)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupActions()
    }
    
    private func setupUI() {
        view.addSubview(termsDetailView)
        termsDetailView.snp.makeConstraints { $0.edges.equalToSuperview() }
        termsDetailView.contentTextView.delegate = self
        navigationBarManager.setTitle(to: navigationItem, title: "약관 상세", textColor: .gray900, font: .heading1Bold())
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(prevVC))
    }
    
    private func setupBindings() {
        viewModel.$content
            .receive(on: DispatchQueue.main)
            .sink { [weak self] content in
                self?.termsDetailView.configure(content: content)
            }
            .store(in: &cancellables)
        
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .readyToAgree:
                    self?.enableAgreeButton()
                case .agreed:
                    self?.parentViewModel?.updateTermAgreement(termId: self?.viewModel.termId ?? 0)
                    self?.navigationController?.popViewController(animated: true)
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        termsDetailView.agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.height
        
        if offsetY + scrollViewHeight >= contentHeight - 10 {
            viewModel.userScrolledToBottom()
        }
    }
    
    @objc private func agreeButtonTapped() {
        viewModel.agree()
    }
    
    private func enableAgreeButton() {
        termsDetailView.agreeButton.isEnabled = true
        termsDetailView.agreeButton.backgroundColor = .gray900
        termsDetailView.agreeButton.setTitleColor(.white, for: .normal)
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
}
