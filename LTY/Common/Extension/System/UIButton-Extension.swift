//
//  UIButton-SFExtension.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/16.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit


extension UIButton {
    convenience init(_ text: String = "", color: UIColor = ColorHelper.default.darkGray, font: UIFont = FontHelper.regular(14)) {
        self.init()
        setTitle(text, for: .normal)
        setTitleColor(color, for: .normal)
        titleLabel?.font = font
        sizeToFit()
    }
    
    convenience init(imageName: String) {
        self.init()
        setImage(UIImage.init(named: "\(imageName)_normal"), for: .normal)
        setImage(UIImage.init(named: "\(imageName)_highlighted"), for: .highlighted)
        setImage(UIImage.init(named: "\(imageName)_selected"), for: .selected)
        sizeToFit()
    }
    convenience init(image: UIImage?) {
        self.init()
        setImage(image, for: .normal)
    }
    convenience init(backgroundImageName: String) {
        self.init()
        setBackgroundImage(UIImage.init(named: backgroundImageName), for: .normal)
        sizeToFit()
    }
}
extension UIButton {
    @IBInspectable var regular: CGFloat {
        get {
            return 1
        }
        set {
            self.titleLabel?.font = FontHelper.regular(newValue)
        }
    }
    
    @IBInspectable var light: CGFloat {
        get {
            return 1
        }
        set {
            self.titleLabel?.font = FontHelper.light(newValue)
        }
    }
    @IBInspectable var medium: CGFloat {
        get {
            return 1
        }
        set {
            self.titleLabel?.font = FontHelper.medium(newValue)
        }
    }
    @IBInspectable var semibold: CGFloat {
        get {
            return 1
        }
        set {
            self.titleLabel?.font = FontHelper.semibold(newValue)
        }
    }
//    open override var isHighlighted: Bool {
//        set {
//            super.isHighlighted = newValue
//            backgroundColor = newValue ? backgroundColor : backgroundColor?.withAlphaComponent(0.9)
//        }
//        get {
//            return super.isHighlighted
//        }
//    }
//    open override var isEnabled: Bool {
//        set {
//            super.isEnabled = newValue
//            backgroundColor = newValue ? backgroundColor : backgroundColor?.withAlphaComponent(0.9)
//        }
//        get {
//            return super.isEnabled
//        }
//    }
}
