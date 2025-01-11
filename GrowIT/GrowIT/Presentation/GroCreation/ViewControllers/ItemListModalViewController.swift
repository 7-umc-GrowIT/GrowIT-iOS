//
//  ItemListModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit

class ItemListModalViewController: UIViewController {
    
    private lazy var segmentData: [[ItemDisplayable]] = [
        ItemBackgroundModel.dummy(),
        ItemAccModel.dummy(),
        ItemBackgroundModel.dummy(),
        ItemAccModel.dummy()
    ]
    
    private lazy var currentSegmentIndex: Int = 0 {
        didSet {
            itemListModalView.itemCollectionView.reloadData()
        }
    }
    
    private lazy var itemListModalView = ItemListModalView().then {
        $0.itemSegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = itemListModalView
        
        setDelegate()
    }
    
    //MARK: - UICollectionView
    private func setDelegate() {
        itemListModalView.itemCollectionView.dataSource = self
        itemListModalView.itemCollectionView.delegate = self
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
        
        currentSegmentIndex = segment.selectedSegmentIndex
        
        UIView.transition(
            with: itemListModalView.itemCollectionView,
            duration: 0.1,
            options: [.transitionCrossDissolve],
            animations: {
                self.currentSegmentIndex = segment.selectedSegmentIndex
            },
            completion: nil
        )
    }
}

//MARK: - UICollectionViewDataSource
extension ItemListModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentData[currentSegmentIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCollectionViewCell.identifier,
            for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = segmentData[currentSegmentIndex][indexPath.row]
        
        cell.creditLabel.text = String(item.credit)
        cell.itemBackGroundView.backgroundColor = item.backgroundColor
        cell.itemImageView.image = item.Item
        
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension ItemListModalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

