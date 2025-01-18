//
//  VoiceDiaryEntryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class VoiceDiaryEntryViewController: ViewController {

    // MARK: Properties
    let navigationBarManager = NavigationManager()
    
    let voiceDiaryEntryView = VoiceDiaryEntryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            tintColor: .black
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

    //MARK: - @objc methods
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        print("Button Tapped")
    }
    
    @objc func labeledTapped() {
        print("Label Tapped")
    }
}
