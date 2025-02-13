//
//  TextDiaryRecommendChallengeViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit

class TextDiaryRecommendChallengeViewController: UIViewController, VoiceDiaryErrorDelegate {
    
    //MARK: - Properties
    let textDiaryRecommendChallengeView = TextDiaryRecommendChallengeView()
    
    let navigationBarManager = NavigationManager()
    
    private var buttonCount: Int = 0
    
    let diaryService = DiaryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
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
        textDiaryRecommendChallengeView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        let prevVC = TextDiaryErrorViewController()
        prevVC.delegate = self
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    @objc func nextVC() {
        if buttonCount == 0 {
            Toast.show(image: UIImage(named: "toast_Icon") ?? UIImage(), message: "한 개 이상의 챌린지를 선택해 주세요", font: .heading3SemiBold())
        } else {
            callPostTextDiary()
            let nextVC = TextDiaryEndViewController()
            nextVC.hidesBottomBarWhenPushed = true
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
    
    func didTapExitButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: API func
    func callPostTextDiary() {
        diaryService.postTextDiary(data: DiaryRequestDTO(
            content: UserDefaults.standard.string(forKey: "TextDiary") ?? "잘못된 전달입니다",
            date: UserDefaults.standard.string(forKey: "TextDate") ?? "잘못된 전달입니다"),
            completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
                print("Success!!!!!!! \(data)")
            case.failure(let error):
                print("Error: \(error)")
            }
        })
    }
    
}
