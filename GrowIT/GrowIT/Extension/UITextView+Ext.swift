//
//  UITextView+Ext.swift
//  GrowIT
//
//  Created by 이수현 on 2/18/25.
//

import UIKit

extension UITextView {
    func setLineSpacing(_ spacing: CGFloat) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style
        ]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: attributes)
    }
}
