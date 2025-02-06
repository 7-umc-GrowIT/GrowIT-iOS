//
//  GroViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit
import SnapKit

class GroViewController: UIViewController, ItemListDelegate, PurchaseDelegate {
    // MARK: - Properties
    let userService = UserService()
    private lazy var currentCredit: Int = 0
    
    private var itemListBottomConstraint: Constraint?
    private var selectedItem: ItemList?
    
    //MARK: - Views
    private lazy var groView = GroView().then {
        $0.zoomButton.addTarget(self, action: #selector(didTapZoomButton), for: .touchUpInside)
        $0.purchaseButton.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)
    }
    
    private lazy var itemShopHeader = ItemShopHeader().then {
        $0.myItemButton.addTarget(self, action: #selector(didTapMyItemButton), for: .touchUpInside)
    }
    
    private lazy var itemListModalVC = ItemListModalViewController()
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groView
        
        setView()
        setConstraints()
        setInitialState()
        callGetCredit()
        setDelegate()
    }
    
    // MARK: - NetWork
    func callGetCredit() {
        userService.getUserCredits(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                currentCredit = data.currentCredit
                itemShopHeader.updateCredit(data.currentCredit)
                itemListModalVC.currentCredit = data.currentCredit
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }

    //MARK: - Delegate Method
    func didSelectItem(_ isPurchased: Bool, selectedItem: ItemList?) {
        groView.purchaseButton.isHidden = isPurchased
        self.selectedItem = selectedItem
        if let price = selectedItem?.price {
            groView.purchaseButton.updateCredit(price)
        }
    }
    
    func didCompletePurchase() {
        groView.purchaseButton.isHidden = true
        callGetCredit()
    }
    
    func updateCredit() {
        callGetCredit() 
    }
    
    private func setDelegate() {
        itemListModalVC.itemDelegate = self
        itemListModalVC.purchaseDelegate = self
    }
    
    //MARK: - Functional
    //MARK: Event
    @objc
    private func didTapZoomButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        showModalView(isZoomedOut: sender.isSelected)
    }
    
    @objc
    private func didTapMyItemButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isSelected {
            groView.zoomButton.isSelected = false // 줌 버튼 상태 초기화
            showModalView(isZoomedOut: !sender.isSelected)
        }
        
        let imageName = sender.isSelected ?
        "GrowIT_MyItem_On" : "GrowIT_MyItem_Off"
        itemShopHeader.myItemButton.configuration?.image = UIImage(named: imageName)
        
        itemListModalVC.updateToMyItems(sender.isSelected)
        groView.purchaseButton.isHidden = sender.isSelected
    }
    
    @objc
    private func didTapPurchaseButton() {
        guard let item = selectedItem else { return }
        
        let isShortage = item.price > currentCredit
        let purchaseModalVC = PurchaseModalViewController(
            isShortage: isShortage,
            credit: item.price,
            itemId: item.id
        )
        purchaseModalVC.purchaseDelegate = self
        
        purchaseModalVC.modalPresentationStyle = .pageSheet
        if let sheet = purchaseModalVC.sheetPresentationController {
            //지원할 크기 지정
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom{ context in
                        0.32 * context.maximumDetentValue
                    }
                ]
            } else { sheet.detents = [.medium()] }
            sheet.prefersGrabberVisible = true
        }
        present(purchaseModalVC, animated: true, completion: nil)
    }
    
    //MARK: - UI 업데이트 함수
    private func showModalView(isZoomedOut: Bool) {
        updateItemListPosition(isZoomedOut: isZoomedOut)
        updateButtonStackViewPosition(isZoomedOut: isZoomedOut)
        updateZoomButtonImage(isZoomedOut: isZoomedOut)
        updateGroImageViewTopConstraint(isZoomedOut: isZoomedOut)
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    private func updateItemListPosition(isZoomedOut: Bool) {
        let offset = isZoomedOut ? 500 : 0
        self.itemListBottomConstraint?.update(offset: offset)
    }
    
    private func updateButtonStackViewPosition(isZoomedOut: Bool) {
        groView.buttonStackView.snp.remakeConstraints {
            let bottomConstraint = isZoomedOut
            ? groView.purchaseButton.snp.top
            : itemListModalVC.view.snp.top
            $0.bottom.equalTo(bottomConstraint).offset(-24)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func updateZoomButtonImage(isZoomedOut: Bool) {
        let imageName = isZoomedOut ? "GrowIT_ZoomIn" : "GrowIT_ZoomOut"
        groView.zoomButton.configuration?.image = UIImage(named: imageName)
    }
    
    private func updateGroImageViewTopConstraint(isZoomedOut: Bool) {
        let inset = isZoomedOut ? 168 : 40
        groView.groImageViewTopConstraint?.update(inset: inset)
    }
    
    private func setInitialState() {
        groView.buttonStackView.snp.remakeConstraints {
            $0.bottom.equalTo( itemListModalVC.view.snp.top).offset(-24)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    //MARK: - 컴포넌트추가
    private func setView() {
        addChild(itemListModalVC)
        groView.addSubviews([itemShopHeader, itemListModalVC.view])
        itemListModalVC.didMove(toParent: self)
    }
    
    //MARK: - 레이아웃설정
    private func setConstraints() {
        itemShopHeader.snp.makeConstraints {
            $0.top.equalTo(groView.safeAreaLayoutGuide).inset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        itemListModalVC.view.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.47)
            self.itemListBottomConstraint = $0.bottom.equalToSuperview().offset(0).constraint
        }
    }
    
}
