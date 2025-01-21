//
//  ChallengHomeViewController.swift
//  GrowIT
//
//  Created by 허준호 on 1/21/25.
//

import UIKit

class ChallengHomeViewController: UIViewController {

    private lazy var challengHomeView = ChallengHomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengHomeView
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
    }

}
