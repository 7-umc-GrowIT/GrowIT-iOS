//
//  DiaryViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/11/25.
//

import Foundation
import SnapKit

class DiaryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
    
    let button = AppButton(title: "확인했어요", titleColor: .black, isEnabled: true)

}
