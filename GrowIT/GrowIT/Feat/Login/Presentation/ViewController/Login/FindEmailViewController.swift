//
//  FindEmailViewController.swift
//  GrowIT
//
//  Created by 강희정 on 1/26/25.
//

import UIKit
import Combine

class FindEmailViewController: UIViewController {
    
    private let findEmailView = FindEmailView()
    private let navigationBarManager = NavigationManager()
    private let viewModel = FindEmailViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }
    
    private func setupView() {
        self.view = findEmailView
        self.navigationController?.isNavigationBarHidden = false
        
        navigationBarManager.setTitle(
            to: self.navigationItem,
            title: "이메일 찾기",
            textColor: .gray900,
            font: .heading1Bold()
        )
        
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .idle:
                    break
                case .loading:
                    // 로딩 UI 준비 가능
                    break
                case .success(let email):
                    self?.showToast("이메일: \(email)")
                case .failure(let error):
                    self?.showToast("오류: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    private func showToast(_ message: String) {
        let toastImage = UIImage(named: "Style=check") ?? UIImage()
        CustomToast(containerWidth: 225).show(
            image: toastImage,
            message: message,
            font: UIFont.heading3SemiBold()
        )
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
}
