//
//  GroSetNameViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/18/25.
//

import UIKit

class GroSetNameViewController: UIViewController {
    private let selectedBackground: Int
    
    let selectedColors: [CGColor]
    var selectedIcon = UIImage()
    
    //MARK: - init
    init(selectedBackground: Int) {
        self.selectedBackground = selectedBackground
        
        let colors = [
            [UIColor.itemColorYellow!.cgColor, UIColor.white.cgColor],
            [UIColor.itemColorGreen!.cgColor, UIColor.white.cgColor],
            [UIColor.itemColorPink!.cgColor, UIColor.white.cgColor]
        ]
        self.selectedColors = colors[selectedBackground]
        
        let icons = [
            UIImage(named: "Item_Background_Star"),
            UIImage(named: "Item_Background_Tree"),
            UIImage(named: "Item_Background_Heart")
        ]
        self.selectedIcon = icons[selectedBackground]!
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groSetNameView
    }
    
    //MARK: - Views
    private lazy var groSetNameView = GroSetNameView(
        gradientColors: selectedColors,
        iconImage: selectedIcon
    )
}
