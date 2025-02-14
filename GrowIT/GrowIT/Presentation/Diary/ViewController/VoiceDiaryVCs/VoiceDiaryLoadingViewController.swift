//
//  VoiceDiaryLoadingViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiaryLoadingViewController: UIViewController {

    //MARK: - Properties
    let voiceDiaryLoadingView = VoiceDiaryLoadingView()
    let navigationBarManager = NavigationManager()
    
    weak var delegate: VoiceDiaryRecordDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToNextScreen()
        }
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
    
    //MARK: - @objc methods
    @objc func prevVC() {
        // navigationController?.popViewController(animated: true)
    }

    private func navigateToNextScreen() {
        let nextVC = VoiceDiarySummaryViewController()
        nextVC.hidesBottomBarWhenPushed = true
        
        nextVC.delegate = self.delegate
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
