//
//  TextDiaryLoadingViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit

class TextDiaryLoadingViewController: UIViewController {
    
    //MARK: - Properties
    let textDiaryLoadingView = TextDiaryLoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToNextScreen()
        }
    }
    
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(textDiaryLoadingView)
        textDiaryLoadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func navigateToNextScreen() {
        let nextVC = TextDiaryRecommendChallengeViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //MARK: - @objc methods
}
