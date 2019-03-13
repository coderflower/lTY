//
//  UILabel-SFExtension.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/16.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(_ text: String? = nil, font: UIFont = FontHelper.regular(12), color: UIColor = UIColor(hex: "333333"), textAlignment: NSTextAlignment = .center) {
        self.init()
        self.text = text
        self.font = font
        textColor = color
        sizeToFit()
        self.textAlignment = textAlignment
    }
}

extension UILabel {
    /// 修复 lineHeight问题
    @discardableResult
    func fixLineHeightAttributed(_ lineSpacing: CGFloat, font: UIFont) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        let lineHeight = lineSpacing + font.lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineSpacing
        let baselineOffset = lineSpacing / 4
        return [.paragraphStyle: paragraphStyle,
                .baselineOffset: baselineOffset]
    }
}

extension UILabel {
    /*
     enum FontType {
     case thin
     case light
     case regular
     case medium
     case semibold
     }
     */
    @IBInspectable var regular: CGFloat {
        get {
            return 1
        }
        set {
            font = FontHelper.regular(newValue)
        }
    }

    @IBInspectable var light: CGFloat {
        get {
            return 1
        }
        set {
            font = FontHelper.light(newValue)
        }
    }

    @IBInspectable var medium: CGFloat {
        get {
            return 1
        }
        set {
            font = FontHelper.medium(newValue)
        }
    }

    @IBInspectable var semibold: CGFloat {
        get {
            return 1
        }
        set {
            font = FontHelper.semibold(newValue)
        }
    }
}
