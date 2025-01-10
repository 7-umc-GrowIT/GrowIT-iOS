//
//  ItemListModalViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/8/25.
//

import UIKit

class ItemListModalViewController: UIViewController {
    
    private lazy var itemListModalView = ItemListModalView()
    
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
    
}
