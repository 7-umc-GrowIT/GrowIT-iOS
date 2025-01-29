//
//  ItemListModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit
import Kingfisher

class ItemListModalViewController: UIViewController {
    // MARK: -Properties
    let itemService = ItemService()
    weak var delegate: MyItemListDelegate?
    private var isMyItems: Bool = false
    private var category: String = ""
    
    private var responseItems: [ItemList] = []
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
    
    private lazy var currentSegmentIndex: Int = 0 {
        didSet {
            itemListModalView.itemCollectionView.reloadData()
        }
    }
    
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
    
    // MARK: - NetWork
    func callGetItems() {
        print("callGetItems called with category: \(category)")
        itemService.getItemList(category: category, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let data):
                self.responseItems = data.itemList
                
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
        return responseItems.count
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
 
            for item in responseItems {
                cell.creditLabel.text = String(item.price)
                cell.itemImageView.kf.setImage(with: URL(string: Constants.API.imageURL + item.imageUrl))
                print("이미지 주소: \(Constants.API.imageURL + item.imageUrl)")
                cell.itemBackGroundView.backgroundColor = .itemPink /// 임시

            }
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
