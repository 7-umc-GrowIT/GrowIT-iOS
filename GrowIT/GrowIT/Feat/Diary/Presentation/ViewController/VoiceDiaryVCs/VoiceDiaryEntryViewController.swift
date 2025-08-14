//
//  VoiceDiaryEntryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import Combine

class VoiceDiaryEntryViewController: UIViewController {
    
    // MARK: Properties
    let navigationBarManager = NavigationManager()
    let voiceDiaryEntryView = VoiceDiaryEntryView()
    
    private let viewModel = VoiceDiaryEntryViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
        bindViewModel()
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: Setup Navigation Bar
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
            textColor: .black
        )
    }
    
    // MARK: Setup UI
    private func setupUI() {
        view.addSubview(voiceDiaryEntryView)
        voiceDiaryEntryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        voiceDiaryEntryView.recordButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        let labelAction = UITapGestureRecognizer(target: self, action: #selector(labeledTapped))
        voiceDiaryEntryView.helpLabel.addGestureRecognizer(labelAction)
    }
    
    //MARK: - ViewModel Binding
    private func bindViewModel() {
        viewModel.$shouldNavigateBack
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldNavigateToDateSelect
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    let nextVC = VoiceDiaryDateSelectViewController()
                    nextVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldPresentTip
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldPresent in
                if shouldPresent {
                    let nextVC = VoiceDiaryTipViewController()
                    nextVC.modalPresentationStyle = .pageSheet
                    
                    if let sheet = nextVC.sheetPresentationController {
                        if #available(iOS 16.0, *) {
                            sheet.detents = [
                                .custom{ context in
                                    0.37 * context.maximumDetentValue
                                }
                            ]
                        } else {
                            sheet.detents = [.medium()]
                        }
                        sheet.prefersGrabberVisible = true
                    }
                    self?.present(nextVC, animated: true, completion: nil)
                }
            }
            .store(in: &cancellables)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }
    
    @objc func nextVC() {
        viewModel.recordButtonTapped.send()
    }
    
    @objc func labeledTapped() {
        viewModel.helpLabelTapped.send()
    }
}
