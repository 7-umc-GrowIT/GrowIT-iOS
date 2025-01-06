//
//  UIFont+Ext.swift
//  GrowIT
//
//  Created by 허준호 on 1/7/25.
//

import UIKit

struct AppFontName {
    static let pRegular = "Pretendard-Regular"
    static let pMedium = "Pretendard-Medium"
    static let pBold = "Pretendard-Bold"
    static let pSemiBold = "Pretendard-SemiBold"
}

extension UIFont {
    
    // Heading 1 Bold Font
    public class func heading1Bold() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 24, lineHeight: 1.2)
    }
    
    // Heading 1 SemiBold Font
    public class func heading1SemiBold() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 24, lineHeight: 1.2)
    }
    
    // Heading 2 Bold Font
    public class func heading2Bold() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 22, lineHeight: 1.2)
    }
    
    // Heading 2 SemiBold Font
    public class func heading2SemiBold() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 22, lineHeight: 1.2)
    }
    
    // Heading 3 Bold Font
    public class func heading3Bold() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 18, lineHeight: 1.2)
    }
    
    // Heading 3 SemiBold Font
    public class func heading3SemiBold() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 18, lineHeight: 1.2)
    }
    
    // Heading 3 Medium Font
    public class func heading3Medium() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 18, lineHeight: 1.2)
    }

    // Body 1 Medium Font
    public class func body1Medium() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 16, lineHeight: 1.5)
    }
    
    // Body 1 Regular Font
    public class func body1Regular() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 16, lineHeight: 1.5)
    }
    
    // Body 2 SemiBold Font
    public class func body2SemiBold() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 14, lineHeight: 1.5)
    }
    
    // Body 2 Medium Font
    public class func body2Medium() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 14, lineHeight: 1.5)
    }
    
    // Body 2 Regular Font
    public class func body2Regular() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 14, lineHeight: 1.5)
    }
    
    // Detail 1 Medium Font
    public class func detail1Medium() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 12, lineHeight: 1.2)
    }
    
    // Detail 1 Regular Font
    public class func detail1Regular() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 12, lineHeight: 1.5)
    }
    
    // Detail 2 Regular Font
    public class func detail2Regular() -> UIFont {
        return createFont(name: AppFontName.pBold, size: 11, lineHeight: 1.5)
    }
    
    
    
    
    // Create Font with letter spacing and line height
    private class func createFont(name: String, size: CGFloat, lineHeight: CGFloat) -> UIFont {
        // Create the UIFont object
        let font = UIFont(name: name, size: size)!
        
        // Create the paragraph style for line height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        
        // Create attributed string with font, letterSpacing, and line height
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: -size * 0.04,
            .paragraphStyle: paragraphStyle
        ]
        
        // Return an attributed font
        let attributedFont = NSAttributedString(string: "a", attributes: attributes)
        let fontWithAttributes = attributedFont.attributes(at: 0, effectiveRange: nil)[.font] as! UIFont
        return fontWithAttributes
    }
    
}