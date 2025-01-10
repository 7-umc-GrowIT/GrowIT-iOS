//
//  ItemListModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit

class ItemListModalViewController: UIViewController {
    
    private lazy var itemListModalView = ItemListModalView().then {
        $0.itemSegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = itemListModalView
        
        setView()
        setConstraints()
    }
    
    //MARK: - 컴포넌트추가
    private func setView() {
        
    }
    
    //MARK: - 레이아웃설정
    private func setConstraints() {
    }
    
    //MARK: - 기능
    @objc private func segmentChanged(_ segment: UISegmentedControl) {
        // 세그먼트 이미지 초기화
        let defaultImages = [
            UIImage(named: "GrowIT_Background_Off")!.withRenderingMode(.alwaysOriginal),
            UIImage(named: "GrowIT_Object_Off")!.withRenderingMode(.alwaysOriginal),
            UIImage(named: "GrowIT_FlowerPot_Off")!.withRenderingMode(.alwaysOriginal),
            UIImage(named: "GrowIT_Accessories_Off")!.withRenderingMode(.alwaysOriginal)
        ]
        
        for index in 0..<segment.numberOfSegments {
            segment.setImage(defaultImages[index], forSegmentAt: index)
        }
        
        switch segment.selectedSegmentIndex {
        case 0:
            segment.setImage(UIImage(named: "GrowIT_Background_On")!
                .withRenderingMode(.alwaysOriginal), forSegmentAt: 0)
            
        case 1:
            segment.setImage(UIImage(named: "GrowIT_Object_On")!
                .withRenderingMode(.alwaysOriginal), forSegmentAt: 1)
        case 2:
            segment.setImage(UIImage(named: "GrowIT_FlowerPot_On")!
                .withRenderingMode(.alwaysOriginal), forSegmentAt: 2)
        case 3:
            segment.setImage(UIImage(named: "GrowIT_Accessories_On")!
                .withRenderingMode(.alwaysOriginal), forSegmentAt: 3)
        default:
            break
        }
    }
}
