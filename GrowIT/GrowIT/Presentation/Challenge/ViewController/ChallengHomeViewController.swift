//
//  ChallengHomeViewController.swift
//  GrowIT
//
//  Created by 허준호 on 1/21/25.
//

import UIKit
import SnapKit

class ChallengHomeViewController: UIViewController {

    private lazy var challengeHomeView = ChallengHomeView()
    private lazy var challengeHomeAreaVC = ChallengeHomeAreaController()
    private lazy var challengeStatusArea = ChallengeStatusArea()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeHomeView
        view.backgroundColor = .white
        
        setCustomSegment()
        setupChallengeHomeArea()
        challengeHomeView.addSubview(challengeStatusArea)
        
        challengeStatusArea.snp.makeConstraints{
            $0.top.equalTo(challengeHomeView.challengeSegmentUnderline.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        challengeHomeAreaVC.view.isHidden = false
        challengeStatusArea.isHidden = true
    }
    
    private func setupChallengeHomeArea(){
        addChild(challengeHomeAreaVC)
        challengeHomeAreaVC.didMove(toParent: self)
        challengeHomeView.addSubview(challengeHomeAreaVC.view)
        challengeHomeAreaVC.view.snp.makeConstraints{
            $0.top.equalTo(challengeHomeView.challengeSegmentUnderline.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setCustomSegment(){
        challengeHomeView.challengeHomeBtn.setTitleColor(.primary600, for: .normal)
        challengeHomeView.challengeHomeBtn.addTarget(self, action: #selector(challengeHomeBtnTapped), for: .touchUpInside)
        challengeHomeView.challengeStatusBtn.addTarget(self, action: #selector(challengeStatusBtnTapped), for: .touchUpInside)
        
        challengeHomeView.updateUnderlinePosition(button: challengeHomeView.challengeHomeBtn, animated: false)
    }
    
    @objc private func challengeHomeBtnTapped(){
        challengeHomeView.updateUnderlinePosition(button: challengeHomeView.challengeHomeBtn, animated: true)
        challengeHomeView.challengeHomeBtn.setTitleColor(.primary600, for: .normal)
        challengeHomeView.challengeStatusBtn.setTitleColor(.gray300, for: .normal)
        
        challengeHomeAreaVC.view.isHidden = false
        challengeStatusArea.isHidden = true
    }
    
    @objc private func challengeStatusBtnTapped(){
        challengeHomeView.updateUnderlinePosition(button: challengeHomeView.challengeStatusBtn, animated: true)
        challengeHomeView.challengeHomeBtn.setTitleColor(.gray300, for: .normal)
        challengeHomeView.challengeStatusBtn.setTitleColor(.primary600, for: .normal)
        
        challengeHomeAreaVC.view.isHidden = true
        challengeStatusArea.isHidden = false
    }
}
