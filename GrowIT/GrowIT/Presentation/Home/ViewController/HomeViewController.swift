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
        callGetGroImage()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        //setupGradientView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callGetGroImage()
    }
    
    // MARK: - NetWork
    func callGetGroImage() {
        groService.getGroImage(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                homeview.characterArea.groFaceImageView.kf.setImage(with: URL(string: data.gro.groImageUrl), options: [.transition(.fade(0.3)), .cacheOriginalImage])
                let equippedItems = data.equippedItems
                
                let categoryImageViews: [String: UIImageView] = [
                    "BACKGROUND": homeview.characterArea.backgroundImageView,
                    "OBJECT": homeview.characterArea.groObjectImageView,
                    "PLANT": homeview.characterArea.groFlowerPotImageView,
                    "HEAD_ACCESSORY": homeview.characterArea.groAccImageView
                ]
                
                for item in equippedItems {
                    if let imageView = categoryImageViews[item.category] {
                        imageView.kf.setImage(with: URL(string: item.itemImageUrl), options: [.transition(.fade(0.3)), .cacheOriginalImage])
                    } else {
                        fatalError("category not found")
                    }
                }
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        })
    }
    
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
        $0.topNavBar.settingBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }

    @objc private func goToItemShop() {
        let itemShopVC = GroViewController()
        navigationController?.pushViewController(itemShopVC, animated: false)
    }
    
    @objc private func logout(){
        TokenManager.shared.clearTokens()
        let nextVC = LoginViewController()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = nextVC
            window.makeKeyAndVisible()

            // 뷰 컨트롤러 전환 시 애니메이션을 제공합니다.
            UIView.transition(with: window, duration: 0.1, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

