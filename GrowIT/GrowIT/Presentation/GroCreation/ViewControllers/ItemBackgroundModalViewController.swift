//
//  ItemBackgroundModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/12/25.
//

import UIKit

class ItemBackgroundModalViewController: UIViewController {
    weak var delegate: ItemBackgroundModalDelegate?
    private var selectedBackground: Int = 0

    //MARK: - Views
    private lazy var itemBackgroundModalView = ItemBackgroundModalView().then {
        $0.purchaseButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = itemBackgroundModalView
        ToastSecond.show(image: UIImage(named: "toast_Icon") ?? UIImage(), message: "캐릭터를 생성해 주세요!", font: .heading3SemiBold(), in: self.view)
        
        setDelegate()
    }
    
    //MARK: - UICollectionView
    private func setDelegate() {
        itemBackgroundModalView.itemCollectionView.dataSource = self
        itemBackgroundModalView.itemCollectionView.delegate = self
    }
    
    //MARK: - 기능
    @objc
    private func nextVC() {
        let nextVC = GroSetNameViewController(selectedBackground: selectedBackground)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension ItemBackgroundModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ItemBackgroundModel.dummy().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ItemCollectionViewCell.identifier,
            for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        let item = ItemBackgroundModel.dummy()[indexPath.row]
        
        cell.creditLabel.text = String(item.credit)
        cell.itemBackGroundView.backgroundColor = item.backgroundColor
        cell.itemImageView.image = item.Item
        
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension ItemBackgroundModalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedBackground = indexPath.row
        delegate?.updateBackgroundImage(to: indexPath.row)
    }
}


