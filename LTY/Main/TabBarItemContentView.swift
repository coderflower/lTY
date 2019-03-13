//
//  TabBarItemContentView.swift
//  LTY
//
//  Created by 花菜 on 2019/3/7.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import ESTabBarController_swift
import UIKit
final class TabBarItemContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = UIColor.white
        highlightTextColor = UIColor.white
        iconColor = UIColor.white
        highlightIconColor = UIColor.white
        backdropColor = ColorHelper.default.theme
        highlightBackdropColor = ColorHelper.default.theme
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LarityContentView: ESTabBarItemContentView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.backgroundColor = ColorHelper.default.theme
        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = UIColor(white: 235 / 255.0, alpha: 1.0).cgColor
        imageView.layer.cornerRadius = 35
        insets = UIEdgeInsets(top: -32, left: 0, bottom: 0, right: 0)
        let transform = CGAffineTransform.identity
        imageView.transform = transform
        superview?.bringSubviewToFront(self)

        textColor = UIColor(white: 255.0 / 255.0, alpha: 1.0)
        highlightTextColor = UIColor(white: 255.0 / 255.0, alpha: 1.0)
        iconColor = UIColor(white: 255.0 / 255.0, alpha: 1.0)
        highlightIconColor = UIColor(white: 255.0 / 255.0, alpha: 1.0)
        backdropColor = .clear
        highlightBackdropColor = .clear
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with _: UIEvent?) -> Bool {
        let p = CGPoint(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
    }

    override func updateLayout() {
        super.updateLayout()
        imageView.sizeToFit()
        imageView.center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
    }

    public override func selectAnimation(animated _: Bool, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.25, animations: {
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 0.5)
        }) { _ in
            completion?()
            self.imageView.transform = CGAffineTransform.identity
        }
    }

    public override func reselectAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }

    public override func deselectAnimation(animated _: Bool, completion: (() -> Void)?) {
        completion?()
    }

    public override func highlightAnimation(animated _: Bool, completion: (() -> Void)?) {
        UIView.beginAnimations("small", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = imageView.transform.scaledBy(x: 0.8, y: 0.8)
        imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }

    public override func dehighlightAnimation(animated _: Bool, completion: (() -> Void)?) {
        UIView.beginAnimations("big", context: nil)
        UIView.setAnimationDuration(0.2)
        let transform = CGAffineTransform.identity
        imageView.transform = transform
        UIView.commitAnimations()
        completion?()
    }

    private func playMaskAnimation(animateView view: UIView, target: UIView, completion _: (() -> Void)?) {
        view.center = CGPoint(x: target.frame.origin.x + target.frame.size.width / 2.0, y: target.frame.origin.y + target.frame.size.height / 2.0)

//        let scale = POPBasicAnimation.init(propertyNamed: kPOPLayerScaleXY)
//        scale?.fromValue = NSValue.init(cgSize: CGSize.init(width: 1.0, height: 1.0))
//        scale?.toValue = NSValue.init(cgSize: CGSize.init(width: 36.0, height: 36.0))
//        scale?.beginTime = CACurrentMediaTime()
//        scale?.duration = 0.3
//        scale?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
//        scale?.removedOnCompletion = true
//
//        let alpha = POPBasicAnimation.init(propertyNamed: kPOPLayerOpacity)
//        alpha?.fromValue = 0.6
//        alpha?.toValue = 0.6
//        alpha?.beginTime = CACurrentMediaTime()
//        alpha?.duration = 0.25
//        alpha?.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut)
//        alpha?.removedOnCompletion = true
//
//        view.layer.pop_add(scale, forKey: "scale")
//        view.layer.pop_add(alpha, forKey: "alpha")
//
//        scale?.completionBlock = ({ animation, finished in
//            completion?()
//        })
    }
}
