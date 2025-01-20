//
//  Toast.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class Toast {
    static func show(image: UIImage, message: String, font: UIFont, in view: UIView) {
        
        let containerView = UIView().then {
            $0.backgroundColor = UIColor(hex: "#00000066")
            $0.layer.cornerRadius = 16
        }
        
        let imageView = UIImageView().then {
            $0.image = image
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
        }
        
        let label = UILabel().then {
            $0.text = message
            $0.font = .heading3SemiBold()
            $0.textColor = .white
            $0.textAlignment = .center
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-136)
            make.width.equalTo(316)
            make.height.equalTo(56)
        }
        
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(22)
            make.width.height.equalTo(24)
        }
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(imageView.snp.top).offset(1)
            make.centerY.equalTo(imageView.snp.centerY)
        }
        
        
        containerView.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            containerView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                containerView.alpha = 0.0
            }) { _ in
                containerView.removeFromSuperview()
            }
        }
    }
}
