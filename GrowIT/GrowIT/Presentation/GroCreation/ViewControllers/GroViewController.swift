//
//  GroViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit

class GroViewController: UIViewController {
    private lazy var groView = GroView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groView
    }
    
}
