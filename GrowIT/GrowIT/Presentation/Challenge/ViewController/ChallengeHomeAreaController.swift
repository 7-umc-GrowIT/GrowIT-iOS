//
//  ChallengeHomeAreaController.swift
//  GrowIT
//
//  Created by 허준호 on 1/22/25.
//

import UIKit

class ChallengeHomeAreaController: UIViewController {
    private lazy var challengeHomeArea = ChallengeHomeArea()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeHomeArea
        view.backgroundColor = .gray50
    }


}
