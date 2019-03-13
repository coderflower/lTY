//
//  UIView-SFExtension.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/13.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

extension UIView {
    convenience init(_ backgroundColor: UIColor = UIColor.white) {
        self.init()
        self.backgroundColor = backgroundColor
    }

//    //将当前视图转为UIImage
//    func asImage() -> UIImage {
//        if #available(iOS 10.0, *) {
//            let renderer = UIGraphicsImageRenderer(bounds: bounds)
//            return renderer.image { rendererContext in
//                layer.render(in: rendererContext.cgContext)
//            }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
}

extension UIView {
    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.masksToBounds = newValue > 0
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
}
