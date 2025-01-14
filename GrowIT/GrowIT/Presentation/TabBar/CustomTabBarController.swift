//
//  CustomTabBarController.swift
//  GrowIT
//
//  Created by 허준호 on 1/9/25.
//

import UIKit
import SnapKit

class CustomTabBarController: UIViewController {
    
    private var customTabBar: CustomTabBarView!
    private var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupCustomTabBar()
    }
    
    private func setupViewControllers() {
        let firstVC = FirstViewController()
        let secondVC = HomeViewController()
        let thirdVC = ThirdViewController()
        
        viewControllers = [firstVC, secondVC, thirdVC]
        
        // 초기 뷰 컨트롤러 설정
        add(asChildViewController: viewControllers[1])
    }
    
    private func setupCustomTabBar() {
        customTabBar = CustomTabBarView()
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBar)
        customTabBar.didSelectItem = { [weak self] index in
            self?.switchTo(index: index)
            self?.customTabBar.updateTabItemSelection(at: index)
        }
        
        customTabBar.snp.makeConstraints{
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.1)
        
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(customTabBar)
    }
    
    private func switchTo(index: Int) {
        let newVC = viewControllers[index]
        if children.last == newVC { return }
        replaceChildViewController(with: newVC)
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.insertSubview(viewController.view, at: 0)
        viewController.view.frame = view.bounds
        viewController.didMove(toParent: self)
    }
    
    private func replaceChildViewController(with newViewController: UIViewController) {
        let currentViewController = children.last
        addChild(newViewController)
        
        transition(from: currentViewController!, to: newViewController, duration: 0.3, options: .transitionCrossDissolve, animations: {
            newViewController.view.frame = self.view.bounds
        }) { [weak self] completed in
            currentViewController?.willMove(toParent: nil)
            currentViewController?.view.removeFromSuperview()
            currentViewController?.removeFromParent()
            newViewController.didMove(toParent: self)
        }
    }
}
