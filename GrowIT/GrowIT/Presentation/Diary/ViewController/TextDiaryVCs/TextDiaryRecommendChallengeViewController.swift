//
//  TextDiaryRecommendChallengeViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit

class TextDiaryRecommendChallengeViewController: UIViewController {
    
    //MARK: - Properties
    let textDiaryRecommendChallengeView = TextDiaryRecommendChallengeView()
    
    let navigationBarManager = NavigationManager()
    
    private var buttonCount: Int = 0
    
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
        view.addSubview(textDiaryRecommendChallengeView)
        textDiaryRecommendChallengeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //MARK: - Setup Actions
    private func setupActions() {
        textDiaryRecommendChallengeView.challengeStackView.button1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        textDiaryRecommendChallengeView.challengeStackView.button2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        textDiaryRecommendChallengeView.challengeStackView.button3.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        textDiaryRecommendChallengeView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        /*
         let nextVC = ErrorViewController()
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
         */
        if buttonCount == 0 {
            Toast.show(image: UIImage(named: "toast_Icon") ?? UIImage(), message: "한 개 이상의 챌린지를 선택해 주세요", font: .heading3SemiBold(), in: self.view)
        } else {
            let nextVC = TextDiaryEndViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func buttonTapped(_ sender: CircleCheckButton) {
        if sender.isSelectedState() {
            buttonCount += 1
        } else {
            buttonCount -= 1
        }
        let buttonState = buttonCount > 0
        
        textDiaryRecommendChallengeView.saveButton.setButtonState(
            isEnabled: buttonState,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400
        )
    }
}
