//
//  ChallengeCompleteViewController.swift
//  GrowIT
//
//  Created by 허준호 on 1/27/25.
//

import UIKit

class ChallengeCompleteViewController: UIViewController {
    
    private lazy var challengeCompleteView = ChallengeCompleteView()
    var isUpdateMode: Bool = false // 수정모드 여부
    
    deinit {
        NotificationCenter.default.removeObserver(self) // 이벤트 감지 해제
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeCompleteView
        view.backgroundColor = .white
        
        setBtnGesture()
        setupDismissKeyboardGesture()
        setupKeyboardNotifications()
    }
    
    private func setBtnGesture() {
        challengeCompleteView.challengeExitButton.addTarget(self, action: #selector(exitBtnTapped), for: .touchUpInside)
        challengeCompleteView.challengeUpdateButton.addTarget(self, action: #selector(updateBtnTapped), for: .touchUpInside)
    }
    
    /// 나가기 버튼 이벤트
    @objc private func exitBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    /// 수정하기 버튼 이벤트
    @objc private func updateBtnTapped(){
        isUpdateMode = !isUpdateMode // 수정모드 온오프
        challengeCompleteView.setEditMode(isEditMode: isUpdateMode) // 한줄소감 텍스트뷰 편집모드 세팅
    }
    
    // 바깥 영역 터치 시 키보드 숨기기
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // 키보드 숨김 시 편집모드 종료
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// 키보드 감지시 수행하는 함수
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 키보드가 나타나면 키보드 높이만큼 화면 올리기
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    /// 키보드 내려가면 원래대로 복구
    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
