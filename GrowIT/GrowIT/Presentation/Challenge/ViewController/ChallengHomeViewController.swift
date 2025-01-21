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
    private lazy var challengeHomeArea = ChallengeHomeArea()
    private lazy var challengeStatusArea = ChallengeStatusArea()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeHomeView
        view.backgroundColor = .white
        
        setCustomSegment()
        view.addSubview(challengeHomeArea)
        view.addSubview(challengeStatusArea)
        
        challengeHomeArea.backgroundColor = .gray50
        
        challengeHomeArea.snp.makeConstraints{
            $0.top.equalTo(challengeHomeView.challengeSegmentUnderline.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        challengeStatusArea.snp.makeConstraints{
            $0.top.equalTo(challengeHomeView.challengeSegmentUnderline.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        challengeHomeArea.isHidden = false
        challengeStatusArea.isHidden = true
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
        
        challengeHomeArea.isHidden = false
        challengeStatusArea.isHidden = true
    }
    
    @objc private func challengeStatusBtnTapped(){
        challengeHomeView.updateUnderlinePosition(button: challengeHomeView.challengeStatusBtn, animated: true)
        challengeHomeView.challengeHomeBtn.setTitleColor(.gray300, for: .normal)
        challengeHomeView.challengeStatusBtn.setTitleColor(.primary600, for: .normal)
        
        challengeHomeArea.isHidden = true
        challengeStatusArea.isHidden = false
    }
}
