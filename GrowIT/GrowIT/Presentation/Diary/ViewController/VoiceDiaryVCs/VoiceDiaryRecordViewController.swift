//
//  VoiceDiaryRecordViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiaryRecordViewController: ViewController {

    // MARK: Properties
    let voiceDiaryRecordView = VoiceDiaryRecordView()
    let navigationBarManager = NavigationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
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
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    @objc func nextVC() {
        let nextVC = VoiceDiaryLoadingViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
