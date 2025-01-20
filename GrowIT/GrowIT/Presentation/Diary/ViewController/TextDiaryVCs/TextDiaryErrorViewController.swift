//
//  ErrorViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/13/25.
//

import UIKit

class TextDiaryErrorViewController: UIViewController {
    
    // MARK: - Properties
    let errorView = ErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        errorView.exitButton.addTarget(self, action: #selector(mainVC), for: .touchUpInside)
        errorView.continueButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func mainVC() {
        if let presentingVC = presentingViewController as? UINavigationController {
            dismiss(animated: true) {
                presentingVC.popToRootViewController(animated: true)
            }
        }
    }
    
}
