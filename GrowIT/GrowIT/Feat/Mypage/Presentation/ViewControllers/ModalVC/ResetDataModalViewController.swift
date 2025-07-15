//
//  ResetDataModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 7/15/25.
//

import UIKit

class ResetDataModalViewController: UIViewController {
    //MARK: -Views
    private lazy var logoutModalView = TwoButtonModalView(
        title: "데이터를 초기화할까요?",
        desc: "초기화 시 삭제한 데이터는 복구가 어렵습니다",
        mainBtn: "초기화하기",
        subBtn: "취소",
        mainBtnColor: .negative400
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = logoutModalView
    }
}
