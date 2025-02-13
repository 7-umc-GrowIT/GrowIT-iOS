//
//  LoadingButton.swift
//  GrowIT
//
//  Created by 이수현 on 2/14/25.
//

import Foundation
import UIKit
import Lottie
import SnapKit

class LoadingButton: UIButton {
    
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "Loading") // Lottie 파일 이름
        animation.loopMode = .loop
        animation.contentMode = .scaleAspectFit
        animation.isHidden = true
        return animation
    }()
    
    private let innerCircle = UIView().then {
        $0.backgroundColor = .white
        
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupUI()
        }
    
    private func setupUI() {
        addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.
        }
    }
}
