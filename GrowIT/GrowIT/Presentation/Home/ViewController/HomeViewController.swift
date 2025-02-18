//
//  HomeViewController.swift
//  GrowIT
//
//  Created by 허준호 on 1/7/25.
//

import UIKit

class HomeViewController: UIViewController {
    let groService = GroService()
    
    private lazy var gradientView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeview
        loadGroImage()
        setNotification()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //setupGradientView()
    }
    
    // MARK: - Set Character
    private func loadGroImage() {
        GroImageCacheManager.shared.fetchGroImage { [weak self] data in
            guard let self = self, let data = data else { return }
            self.updateCharacterViewImage(with: data)
        }
    }
    
    @objc
    private func updateCharacterView() {
        GroImageCacheManager.shared.refreshGroImage { [weak self] data in
            guard let self = self, let data = data else { return }
            self.updateCharacterViewImage(with: data)
        }
    }
    
    private func updateCharacterViewImage(with data: GroGetResponseDTO) {
        homeview.characterArea.groFaceImageView.kf.setImage(with: URL(string: data.gro.groImageUrl), options: [.transition(.fade(0.3)), .cacheOriginalImage])
        
        let categoryImageViews: [String: UIImageView] = [
            "BACKGROUND": homeview.characterArea.backgroundImageView,
            "OBJECT": homeview.characterArea.groObjectImageView,
            "PLANT": homeview.characterArea.groFlowerPotImageView,
            "HEAD_ACCESSORY": homeview.characterArea.groAccImageView
        ]
        
        for item in data.equippedItems {
            if let imageView = categoryImageViews[item.category] {
                imageView.kf.setImage(with: URL(string: item.itemImageUrl), options: [.transition(.fade(0.3)), .cacheOriginalImage])
            }
        }
    }
    
    //MARK: -
    private func setupGradientView() {
        // 그라디언트 뷰의 프레임 설정
        gradientView.frame = CGRect(x: 0, y: view.bounds.height / 2, width: view.bounds.width, height: view.bounds.height / 2 - 20)
        view.addSubview(gradientView)
        
        // 그라디언트 레이어 생성 및 설정
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [
            UIColor.gray.withAlphaComponent(0).cgColor,
            UIColor.gray.withAlphaComponent(0.2).cgColor,
            UIColor.gray.withAlphaComponent(0.6).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        // 그라디언트 레이어를 뷰에 추가
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    private lazy var homeview = HomeView().then {
        $0.topNavBar.itemShopBtn.addTarget(self, action: #selector(goToItemShop), for: .touchUpInside)
    }
    
    @objc private func goToItemShop() {
        let itemShopVC = GroViewController()
        navigationController?.pushViewController(itemShopVC, animated: false)
    }
    
    //MARK: Notification
    private func setNotification() {
        let Notification = NotificationCenter.default
        
        Notification.addObserver(self, selector: #selector(updateCharacterView), name: .groImageUpdated, object: nil)
    }
}
