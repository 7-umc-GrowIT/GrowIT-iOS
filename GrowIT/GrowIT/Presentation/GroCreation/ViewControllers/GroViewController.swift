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
    
    private lazy var groView = GroView().then {
            $0.zoomButton.addTarget(self, action: #selector(didTapZoomButton), for: .touchUpInside)
        }
    private lazy var itemListModalView = ItemListModalView()
    private lazy var itemShopHeader = ItemShopHeader()
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groView
        
        setView()
        setConstraints()
    }
    
    //MARK: - 컴포넌트추가
    private func setView() {
        groView.addSubviews([itemShopHeader, itemListModalView])
    }
    
    //MARK: - 레이아웃설정
    private func setConstraints() {
        itemShopHeader.snp.makeConstraints {
            $0.top.equalTo(groView.safeAreaLayoutGuide).inset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        itemListModalView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
            self.itemListBottomConstraint = $0.bottom.equalToSuperview().offset(500).constraint
        }
    }
    
    //MARK: - 기능구현
    @objc private func didTapZoomButton(_ sender: UIButton) {
        print("클릭")
        sender.isSelected.toggle()
        if sender.isSelected { // 캐릭터 축소
            self.itemListBottomConstraint?.update(offset: 0) // 아이템샵 올리기
            groView.buttonStackView.snp.remakeConstraints {
                $0.bottom.equalTo(itemListModalView.snp.top).offset(-24)
                $0.trailing.equalToSuperview().inset(24)
            }
            groView.zoomButton.configuration?.image = UIImage(named: "GrowIT_ZoomOut")
            groView.groImageViewTopConstraint?.update(inset: 40)

            
        } else { // 캐릭터 확대
            self.itemListBottomConstraint?.update(offset: 500) // 아이템샵 내리기
            groView.buttonStackView.snp.remakeConstraints {
                $0.bottom.equalTo(groView.purchaseButton.snp.top).offset(-24)
                $0.trailing.equalToSuperview().inset(24)
            }
            groView.zoomButton.configuration?.image = UIImage(named: "GrowIT_ZoomIn")
            groView.groImageViewTopConstraint?.update(inset: 168)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
