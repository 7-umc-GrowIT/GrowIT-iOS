//
//  GroViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit
import SnapKit

class GroViewController: UIViewController {
    private var itemListBottomConstraint: Constraint?
    private var isZoomIn: Bool = true
    
    //MARK: - Views
    private lazy var groView = GroView().then {
        $0.zoomButton.addTarget(self, action: #selector(didTapZoomButton), for: .touchUpInside)
        $0.purchaseButton.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)
    }
    private lazy var itemListModalVC = ItemListModalViewController()
    private lazy var itemShopHeader = ItemShopHeader().then {
        $0.myItemButton.addTarget(self, action: #selector(didTapMyItemButton), for: .touchUpInside)
    }
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groView
        
        setView()
        setConstraints()
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
            self.itemListBottomConstraint = $0.bottom.equalToSuperview().offset(500).constraint
        }
    }
    
    //MARK: - 기능
    @objc private func didTapZoomButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        // 상태에 따라 동작 분기
        updateItemListPosition(isZoomedOut: sender.isSelected)
        updateButtonStackViewPosition(isZoomedOut: sender.isSelected)
        updateZoomButtonImage(isZoomedOut: sender.isSelected)
        updateGroImageViewTopConstraint(isZoomedOut: sender.isSelected)
        
        // 레이아웃 업데이트 애니메이션
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func didTapPurchaseButton() {
        let purchaseModalVC = PurchaseModalViewController()
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
    
    @objc private func didTapMyItemButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        let imageName = sender.isSelected ? "GrowIT_MyItem_On" : "GrowIT_MyItem_Off"
        itemShopHeader.myItemButton.configuration?.image = UIImage(named: imageName)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - UI 업데이트 함수
    private func updateItemListPosition(isZoomedOut: Bool) {
        let offset = isZoomedOut ? 0 : 500
        self.itemListBottomConstraint?.update(offset: offset)
    }
    
    private func updateButtonStackViewPosition(isZoomedOut: Bool) {
        groView.buttonStackView.snp.remakeConstraints {
            let bottomConstraint = isZoomedOut
            ? itemListModalVC.view.snp.top
            : groView.purchaseButton.snp.top
            $0.bottom.equalTo(bottomConstraint).offset(-24)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func updateZoomButtonImage(isZoomedOut: Bool) {
        let imageName = isZoomedOut ? "GrowIT_ZoomOut" : "GrowIT_ZoomIn"
        groView.zoomButton.configuration?.image = UIImage(named: imageName)
    }
    
    private func updateGroImageViewTopConstraint(isZoomedOut: Bool) {
        let inset = isZoomedOut ? 40 : 168
        groView.groImageViewTopConstraint?.update(inset: inset)
    }
    
}
