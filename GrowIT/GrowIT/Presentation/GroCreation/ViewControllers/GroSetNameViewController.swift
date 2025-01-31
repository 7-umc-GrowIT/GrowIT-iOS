//
//  GroSetNameViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/18/25.
//

import UIKit

class GroSetNameViewController: UIViewController {
    /// 추후 셀 선택시 넘어오는 값으로 변경
    let selectedColors: [CGColor] = [
        UIColor.itemColorYellow!.cgColor,
        UIColor.white.cgColor
    ]
    let selectedIcon = UIImage(named: "Item_Background_Star")
    
    //MARK: - Views
    private lazy var groSetNameView = GroSetNameView(gradientColors: selectedColors, iconImage: selectedIcon!)
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groSetNameView
    }
    
}
