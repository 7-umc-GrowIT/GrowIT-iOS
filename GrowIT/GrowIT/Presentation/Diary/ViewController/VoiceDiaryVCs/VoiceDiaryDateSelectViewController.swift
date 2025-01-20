//
//  VoiceDiaryDateSelectViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiaryDateSelectViewController: ViewController {

    // MARK: Properties
    let  voiceDiaryDateSelectView = VoiceDiaryDateSelectView()
    let navigationBarManager = NavigationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupUI()
        setupNavigationBar()
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
        view.addSubview(voiceDiaryDateSelectView)
        voiceDiaryDateSelectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        voiceDiaryDateSelectView.startButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        let labelAction = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        voiceDiaryDateSelectView.helpLabel.addGestureRecognizer(labelAction)
    }
    
    
    // MARK: @objc methods
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        let nextVC = VoiceDiaryRecordViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func labelTapped() {
        let nextVC = VoiceDiaryTipViewController()
        nextVC.modalPresentationStyle = .pageSheet
        
        if let sheet = nextVC.sheetPresentationController {
        //지원할 크기 지정
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
        present(nextVC, animated: true, completion: nil)
    }
}
