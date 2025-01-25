//
//  VoiceDiaryRecordViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiaryRecordViewController: UIViewController, VoiceDiaryErrorDelegate {

    // MARK: Properties
    let voiceDiaryRecordView = VoiceDiaryRecordView()
    let navigationBarManager = NavigationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }
    
    private func observeRemainingTime() {
        voiceDiaryRecordView.onRemainingTimeChanged = { [weak self] remainingTime in
            guard let self = self else { return }
            if remainingTime > 120 { // 남은 시간이 1분 이하일 때
                
            }
        }
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
        view.addSubview(voiceDiaryRecordView)
        voiceDiaryRecordView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: Setup Actions
    private func setupActions() {
        voiceDiaryRecordView.endButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        let prevVC = VoiceDiaryRecordErrorViewController()
        prevVC.delegate = self
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    @objc func nextVC() {
        let nextVC = VoiceDiaryLoadingViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func didTapExitButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
