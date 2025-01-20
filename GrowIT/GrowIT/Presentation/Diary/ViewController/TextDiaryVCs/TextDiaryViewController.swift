//
//  TextDiaryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit

class TextDiaryViewController: UIViewController {
    
    //MARK: - Properties
    let navigationBarManager = NavigationManager()
    let textDiaryView = TextDiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
    }
    
    //MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "직접 일기 작성하기",
            textColor: .black
        )
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(textDiaryView)
        textDiaryView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setup Button actions
    private func setupActions() {
        textDiaryView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        let nextVC = TextDiaryLoadingViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
