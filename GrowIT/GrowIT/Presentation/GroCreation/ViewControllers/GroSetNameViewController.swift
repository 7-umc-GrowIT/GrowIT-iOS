//
//  GroSetNameViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/18/25.
//

import UIKit

class GroSetNameViewController: UIViewController {
    
    //MARK: - Views
    private lazy var groSetNameView = GroSetNameView()
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groSetNameView
    }
    
}
