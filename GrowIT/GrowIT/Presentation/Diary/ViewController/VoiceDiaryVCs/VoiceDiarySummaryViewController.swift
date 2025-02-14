//
//  VoiceDiarySummaryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiarySummaryViewController: UIViewController, VoiceDiaryErrorDelegate, VoiceDiaryRecordDelegate {
    
    // MARK: Properties
    let voiceDiarySummaryView = VoiceDiarySummaryView()
    let navigationBarManager = NavigationManager()
    
    weak var delegate: VoiceDiaryRecordDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        setupActions()
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
        view.addSubview(voiceDiarySummaryView)
        voiceDiarySummaryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        voiceDiarySummaryView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        let labelAction = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        voiceDiarySummaryView.descriptionLabel.addGestureRecognizer(labelAction)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        let prevVC = VoiceDiarySummaryErrorViewController()
        prevVC.delegate = self
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    @objc func nextVC() {
        let nextVC = VoiceDiaryRecommendChallengeViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func labelTapped() {
        let nextVC = VoiceDiaryFixViewController(text: voiceDiarySummaryView.diaryLabel.text ?? "")
        let navController = UINavigationController(rootViewController: nextVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.6)
    }
    
    func didTapExitButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func didFinishRecording(diaryContent: String) {
        DispatchQueue.main.async() {
            self.voiceDiarySummaryView.configure(text: diaryContent)
        }
    }
}
