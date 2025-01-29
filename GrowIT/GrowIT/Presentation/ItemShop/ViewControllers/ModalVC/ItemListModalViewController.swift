//
//  ItemListModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit
import Kingfisher

class ItemListModalViewController: UIViewController {
    // MARK: - Properties
    let itemService = ItemService()
    weak var delegate: MyItemListDelegate?
    
    private var isMyItems: Bool = false
    private var category: String = "BACKGROUND"
    private var selectedItem: ItemList?
    
    private var myItems: [ItemList] = []
    private var shopItems: [ItemList] = []
    
    private lazy var currentSegmentIndex: Int = 0 {
        didSet { itemListModalView.itemCollectionView.reloadData() }
    }
    
    // MARK: - Data
    private let categories: [String] = ["BACKGROUND", "OBJECT", "PLANT", "HEAD_ACCESSORY"]
    
    private let selectedImages: [UIImage] = [
        UIImage(named: "GrowIT_Background_On")!,
        UIImage(named: "GrowIT_Object_On")!,
        UIImage(named: "GrowIT_FlowerPot_On")!,
        UIImage(named: "GrowIT_Accessories_On")!
    ]
    private let defaultImages: [UIImage] = [
        UIImage(named: "GrowIT_Background_Off")!,
        UIImage(named: "GrowIT_Object_Off")!,
        UIImage(named: "GrowIT_FlowerPot_Off")!,
        UIImage(named: "GrowIT_Accessories_Off")!
    ]
    
    let colorMapping: [String: UIColor] = [
        "green": .itemGreen,
        "pink": .itemPink,
        "yellow": .itemYellow
    ]
    
    // MARK: - NetWork
    func callGetItems() {
        itemService.getItemList(category: category, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
                self.shopItems = data.itemList
                self.myItems = data.itemList.filter { $0.purchased }
                
                DispatchQueue.main.async {
                    self.itemListModalView.itemCollectionView.reloadData()
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
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
        callGetItems()
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
        itemListModalView.itemCollectionView.reloadData()
        
        // 구매 버튼 안 보이게
        itemListModalView.purchaseButton.isHidden = isMyItems
        let inset: CGFloat = isMyItems ? 100 : -16
        itemListModalView.updateCollectionViewConstraints(forSuperviewInset: inset)
    }
    
    @objc private func segmentChanged(_ segment: UISegmentedControl) {
        for index in 0..<segment.numberOfSegments {
            segment.setImage(defaultImages[index].withRenderingMode(.alwaysOriginal), forSegmentAt: index)
        }
        
        let selectedIndex = segment.selectedSegmentIndex
        segment.setImage(selectedImages[selectedIndex].withRenderingMode(.alwaysOriginal), forSegmentAt: selectedIndex)
        category = categories[selectedIndex]
        
        callGetItems()
        
        UIView.transition(
            with: itemListModalView.itemCollectionView,
            duration: 0.1,
            options: [.transitionCrossDissolve],
            animations: {
                self.currentSegmentIndex = selectedIndex
            },
            completion: nil
        )
    }
    
    @objc private func didTapPurchaseButton() {
        guard let item = selectedItem else { return }

        let purchaseModalVC = PurchaseModalViewController(isShortage: false, credit: item.price)
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
        return isMyItems ? myItems.count : shopItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 마이아이템 셀
        if isMyItems {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MyItemCollectionViewCell.identifier,
                for: indexPath) as? MyItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let item = myItems[indexPath.row]
            cell.isOwnedLabel.text = "보유 중"
            cell.itemBackGroundView.backgroundColor = colorMapping[item.shopBackgroundColor] ?? .itemYellow
            cell.itemImageView.kf.setImage(with: URL(string: item.imageUrl))
            return cell
            
        } else {
            // 샵아이템 셀
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ItemCollectionViewCell.identifier,
                for: indexPath) as? ItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let item = shopItems[indexPath.row]
            cell.creditLabel.text = String(item.price)
            cell.itemBackGroundView.backgroundColor = colorMapping[item.shopBackgroundColor] ?? .itemYellow
            cell.itemImageView.kf.setImage(with: URL(string: item.imageUrl))
            return cell
        }
    }
    
}

//MARK: - UICollectionViewDelegate
extension ItemListModalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = isMyItems ? myItems[indexPath.row] : shopItems[indexPath.row]

        itemListModalView.purchaseButton.updateCredit(item.price)
        delegate?.didSelectPurchasedItem(item.purchased, selectedItem: item)

        
        // 구매한 아이템의 경우
        itemListModalView.purchaseButton.isHidden = item.purchased
        let inset: CGFloat = item.purchased ? 100 : -16
        itemListModalView.updateCollectionViewConstraints(forSuperviewInset: inset)
        
    }
}

extension ItemListModalViewController: UICollectionViewDelegateFlowLayout {
    // 동적 셀 너비 조정
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let itemRow: CGFloat = 3
        let itemSpacing: CGFloat = 8
        let aspectRatio: CGFloat = 140 / 122
        
        let availableWidth = collectionView.bounds.width - (itemSpacing * 2)
        let itemWidth = floor(availableWidth / itemRow)
        let itemHeight = itemWidth * aspectRatio
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
