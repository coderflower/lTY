//
//  UIView+SF.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/8.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation

extension SFExtension where Base: UIView {
    var viewController: UIViewController? {
        var viewController: UIViewController?
        var next = base.next
        while next != nil {
            if next!.isKind(of: UIViewController.classForCoder()) {
                viewController = next as? UIViewController
                break
            }
            next = next!.next
        }
        return viewController
    }

    /// 配置
    ///
    /// - Parameter config: 回调
    /// - Returns: 当前控件
    func config(_ config: (Base) -> Void) -> Base {
        config(base)
        return base
    }

    /// 添加到父视图
    ///
    /// - Parameter superView: 父视图
    /// - Returns: 当前控件
    func add(to superView: UIView) -> Base {
        superView.addSubview(base)
        return base
    }

    func end() {}
}

// 抖动方向枚举
public enum ShakeDirection: Int {
    case horizontal // 水平抖动
    case vertical // 垂直抖动
}

extension SFExtension where Base: UIView {
    /**
     扩展UIView增加抖动方法

     @param direction：抖动方向（默认是水平方向）
     @param times：抖动次数（默认5次）
     @param interval：每次抖动时间（默认0.1秒）
     @param delta：抖动偏移量（默认2）
     @param completion：抖动动画结束后的回调
     */
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 5,
                      interval: TimeInterval = 0.1, delta: CGFloat = 2,
                      completion: (() -> Void)? = nil) {
        // 播放动画
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.base.layer.setAffineTransform(CGAffineTransform(translationX: delta, y: 0))
            case .vertical:
                self.base.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: delta))
            }
        }) { (_) -> Void in
            // 如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if times == 0 {
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.base.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (_) -> Void in
                    completion?()
                })
            }
            // 如果当前不是最后一次抖动，则继续播放动画（总次数减1，偏移位置变成相反的）
            else {
                self.shake(direction: direction, times: times - 1, interval: interval,
                           delta: delta * -1, completion: completion)
            }
        }
    }
}
