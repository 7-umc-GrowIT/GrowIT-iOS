//
//  GroSetBackgroundViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/12/25.
//

import UIKit
import SnapKit

class GroSetBackgroundViewController: UIViewController {
    private var itemListBottomConstraint: Constraint?
    private var isZoomIn: Bool = true
    
    //MARK: - Views
    private lazy var groView = GroView().then {
        $0.eraseButton.isHidden = true
        $0.zoomButton.addTarget(self, action: #selector(didTapZoomButton), for: .touchUpInside)
        $0.purchaseButton.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)
    }
    
    private lazy var itemBackgroundModalVC = ItemBackgroundModalViewController()
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groView
        
        setView()
        setConstraints()
        setButtonUI()
    }
    //MARK: - 컴포넌트추가
    private func setView() {
        addChild(itemBackgroundModalVC)
        groView.addSubview(itemBackgroundModalVC.view)
        itemBackgroundModalVC.didMove(toParent: self)
        itemBackgroundModalVC.setParentController(self)
    }
    
    //MARK: - 레이아웃설정
    private func setConstraints() {
        itemBackgroundModalVC.view.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.47)
            self.itemListBottomConstraint = $0.bottom.equalToSuperview().offset(500).constraint
        }
    }
    
    //MARK: - 기능구현
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
        // 다음으로
    }
    
    func changeBackgroundImageView(_ num: Int) {
        switch num {
        case 0:
            groView.backgroundImageView.image = UIImage.growITBackgroundStar
        case 1:
            groView.backgroundImageView.image = UIImage.growITBackgroundTree
        case 2:
            groView.backgroundImageView.image = UIImage.growITBackgroundHeart
        default:
            break
        }
    }
    
    //MARK: - UI 업데이트 함수
    private func setButtonUI() {
        groView.purchaseButton.showCredit = false
        groView.purchaseButton.title = "다음으로"
        groView.purchaseButton.updateUI()
    }
    
    private func updateItemListPosition(isZoomedOut: Bool) {
        let offset = isZoomedOut ? 0 : 500
        self.itemListBottomConstraint?.update(offset: offset)
    }
    
    private func updateButtonStackViewPosition(isZoomedOut: Bool) {
        groView.buttonStackView.snp.remakeConstraints {
            let bottomConstraint = isZoomedOut
            ? itemBackgroundModalVC.view.snp.top
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
