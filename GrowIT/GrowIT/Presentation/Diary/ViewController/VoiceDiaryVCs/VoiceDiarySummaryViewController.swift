//
//  VoiceDiarySummaryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiarySummaryViewController: ViewController {
    
    // MARK: Properties
    let voiceDiarySummaryView = VoiceDiarySummaryView()
    let navigationBarManager = NavigationManager()
    
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
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        let nextVC = VoiceDiaryRecommendChallengeViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 일기 요약 이탈 시 오류 modal 뷰
    @objc func labelTapped() {
        let nextVC = VoiceDiaryFixViewController(text: voiceDiarySummaryView.diaryLabel.text ?? "")
        presentPageSheet(viewController: nextVC, detentFraction: 0.6)
    }
}
