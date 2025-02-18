//
//  LaunchScreenViewController.swift
//  GrowIT
//
//  Created by 오현민 on 2/16/25.
//

import UIKit

final class LaunchScreenViewController: UIViewController {

    private lazy var titleLabel = UILabel().then {
        $0.text = "AI와 대화하며 성장하다"
        $0.font = UIFont.subHeading2()
        $0.textColor = .grayColor800
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var logoImageView = UIImageView().then {
        $0.image = UIImage(named: "GROWIT")
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var groImageView = UIImageView().then {
        $0.image = UIImage(named: "GrowIT_Gro")
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setView()
    }
    
    private func setView() {
        view.addSubviews([titleLabel, logoImageView, groImageView])
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(144)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.width.equalTo(286)
            $0.height.equalTo(54)
        }
        
        groImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(1.5)
        }
    }
    
    // MARK: - Navigation
        private func navigateToMain() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let mainVC = HomeViewController() // 👉 여기에 진입할 메인 뷰컨트롤러
                let navigationController = UINavigationController(rootViewController: mainVC)
                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
            }
        }
}
