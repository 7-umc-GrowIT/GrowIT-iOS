//
//  ItemListModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit

class ItemListModalViewController: UIViewController {
    
    weak var delegate: MyItemListDelegate?
    private var isMyItems: Bool = false
    
    // 아이템 목록 더미데이터
    private lazy var segmentData: [[ItemDisplayable]] = [
        ItemBackgroundModel.dummy(),
        ItemAccModel.dummy(),
        ItemBackgroundModel.dummy(),
        ItemAccModel.dummy()
    ]
    
    // 마이아이템 더미데이터
    private var myItemsData: [[ItemDisplayable]] = [
        ItemBackgroundModel.myItemsDummy(),
        ItemAccModel.myItemsDummy(),
        ItemAccModel.myItemsDummy(),
        ItemAccModel.myItemsDummy()
    ]
    
    private lazy var currentSegmentIndex: Int = 0 {
        didSet {
            itemListModalView.itemCollectionView.reloadData()
        }
    }
    
    //MARK: - Views
    private lazy var itemListModalView = ItemListModalView().then {
        $0.itemSegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        $0.purchaseButton.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)
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
    // 마이아이템 진입 시 업데이트
    func updateToMyItems(_ isMyItems: Bool) {
        self.isMyItems = isMyItems
        segmentData = isMyItems ? myItemsData : [
            ItemBackgroundModel.dummy(),
            ItemAccModel.dummy(),
            ItemBackgroundModel.dummy(),
            ItemAccModel.dummy()
        ]
        itemListModalView.itemCollectionView.reloadData()
        
        // 구매 버튼 안 보이게
        itemListModalView.purchaseButton.isHidden = isMyItems
        let inset: CGFloat = isMyItems ? 100 : -16
        itemListModalView.updateCollectionViewConstraints(forSuperviewInset: inset)
    }
    
    // 세그먼트 이미지 초기화
    @objc private func segmentChanged(_ segment: UISegmentedControl) {
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
    
    @objc private func didTapPurchaseButton() {
        let purchaseModalVC = PurchaseModalViewController(isShortage: true)
        purchaseModalVC.modalPresentationStyle = .pageSheet
        
        if let sheet = purchaseModalVC.sheetPresentationController {
            //지원할 크기 지정
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom{ context in
                        0.32 * context.maximumDetentValue
                    }
                ]
            } else {
                sheet.detents = [.medium()]
            }
            sheet.prefersGrabberVisible = true
        }
        present(purchaseModalVC, animated: true, completion: nil)
    }
}



//MARK: - UICollectionViewDataSource
extension ItemListModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentData[currentSegmentIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 마이 아이템 셀 구분
        if isMyItems {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyItemCollectionViewCell.identifier,
                for: indexPath) as? MyItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            let item = segmentData[currentSegmentIndex][indexPath.row]
            cell.isOwnedLabel.text = "보유 중"
            cell.itemBackGroundView.backgroundColor = item.backgroundColor
            cell.itemImageView.image = item.Item
            
            return cell
            
        } else {
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
    
}

//MARK: - UICollectionViewDelegate
extension ItemListModalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = segmentData[currentSegmentIndex][indexPath.row]
        
        // 구매 버튼 안 보이게
        itemListModalView.purchaseButton.isHidden = item.isPurchased
        delegate?.didSelectPurchasedItem(item.isPurchased)
        let inset: CGFloat = item.isPurchased ? 100 : -16
        itemListModalView.updateCollectionViewConstraints(forSuperviewInset: inset)

    }
}

