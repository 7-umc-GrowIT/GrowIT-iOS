//
//  TextDiaryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/12/25.
//

import UIKit
import EzPopup

class TextDiaryViewController: UIViewController {
    
    //MARK: - Properties
    let navigationBarManager = NavigationManager()
    let textDiaryView = TextDiaryView()
    
    let calVC = JDiaryCalendarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
        navigationController?.navigationBar.isHidden = false
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
        textDiaryView.dropDownButton.addTarget(self, action: #selector(calenderVC), for: .touchUpInside)
    }
    
    //MARK: - @objc methods
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        print(textDiaryView.saveButton.isEnabled)
        if textDiaryView.saveButton.isEnabled == false {
            Toast.show(image: UIImage(named: "toast_Icon") ?? UIImage(), message: "일기를 더 작성해 주세요", font: .heading3SemiBold())
        } else {
            let userDiary = textDiaryView.diaryTextField.text
            UserDefaults.standard.set(userDiary, forKey: "TextDiary")
            let nextVC = TextDiaryLoadingViewController()
            nextVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func calenderVC(_ sender: UIButton) {
        let calVC = JDiaryCalendarController()
        calVC.view.backgroundColor = .clear
        let popupVC = PopupViewController(contentController: calVC, popupWidth: 382, popupHeight: 370)
        present(popupVC, animated: true)
    }
}
