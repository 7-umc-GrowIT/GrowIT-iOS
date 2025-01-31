//
//  VoiceDiaryDateSelectViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiaryDateSelectViewController: UIViewController, JDiaryCalendarControllerDelegate {
    
    // MARK: Properties
    let  voiceDiaryDateSelectView = VoiceDiaryDateSelectView()
    let navigationBarManager = NavigationManager()
    
    let calVC = JDiaryCalendarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupUI()
        setupNavigationBar()
        setupActions()
        setupDelegate()
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
        view.addSubview(voiceDiaryDateSelectView)
        voiceDiaryDateSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(calVC.view)
        addChild(calVC)
        calVC.configureTheme(isDarkMode: true)
        calVC.didMove(toParent: self)
        calVC.view.snp.makeConstraints { make in
            make.top.equalTo(voiceDiaryDateSelectView.dateView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        calVC.view.isHidden = true
    }
    
    // MARK: Setup Delegate
    private func setupDelegate() {
        calVC.delegate = self
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        voiceDiaryDateSelectView.startButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        let labelAction = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        voiceDiaryDateSelectView.helpLabel.addGestureRecognizer(labelAction)
        
        voiceDiaryDateSelectView.toggleButton.addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
    }
    
    
    // MARK: @objc methods
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        let nextVC = VoiceDiaryRecordViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func labelTapped() {
        let nextVC = VoiceDiaryTipViewController()
        nextVC.modalPresentationStyle = .pageSheet
        
        presentPageSheet(viewController: nextVC, detentFraction: 0.37)
    }
    
    @objc func toggleTapped() {
        calVC.view.isHidden.toggle()
    }
    
    func didSelectDate(_ date: String) {
        voiceDiaryDateSelectView.updateDateLabel(date) // ✅ `VoiceDiaryDateSelectView`의 메서드 호출
    }
}
