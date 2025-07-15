//
//  LogoutModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 7/15/25.
//

import UIKit

class LogoutModalViewController: UIViewController {
    //MARK: -Views
    private lazy var logoutModalView = TwoButtonModalView(
        title: "로그아웃 할까요?",
        desc: "다음 로그인을 할 때 이메일로 로그인해 주세요",
        mainBtn: "로그아웃하기",
        subBtn: "취소")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = logoutModalView
    }
}
