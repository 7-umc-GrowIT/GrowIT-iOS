//
//  ChallengeDeleteModalController.swift
//  GrowIT
//
//  Created by 허준호 on 1/24/25.
//

import UIKit

class ChallengeDeleteModalController: UIViewController {
    
    private lazy var challengeDeleteModal = ChallengeDeleteModal()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeDeleteModal
        view.backgroundColor = .white
        
        challengeDeleteModal.exitBtn.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        challengeDeleteModal.deleteBtn.addTarget(self, action: #selector(challengeDeleted), for: .touchUpInside)
    }
    
    @objc private func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func challengeDeleted() {
        
        Toast.show(image: UIImage(named: "challengeToastIcon") ?? UIImage(), message: "챌린지를 삭제했어요", font: .heading3SemiBold())
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }

}
