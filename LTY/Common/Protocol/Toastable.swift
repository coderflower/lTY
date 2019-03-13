//
//  Toastable.swift
//  XZJQ
//
//  Created by 花菜 on 2018/4/28.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Toast_Swift
import UIKit

public class SFToast: Toastable {
    public static func showMessage(_ message: String?, duration: TimeInterval = 2, position: ToastPosition = .center, title: String? = nil, image: UIImage? = nil, style: ToastStyle = ToastManager.shared.style, completion: ((_ didTap: Bool) -> Void)? = nil) {
        UIApplication.shared.keyWindow?.makeToast(message, duration: duration, position: position, title: title, image: image, style: style, completion: completion)
    }

    public static func hideAllToasts(includeActivity: Bool = false, clearQueue: Bool = true) {
        UIApplication.shared.keyWindow?.hideAllToasts(includeActivity: includeActivity, clearQueue: clearQueue)
    }
}

extension SFToast {
    static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }

    static func loading() {
        hide()

        keyWindow?.makeToastActivity(.center)
    }

    static func show(info: String, duration: TimeInterval = ToastManager.shared.duration) {
        hide()
        keyWindow?.makeToast(info, duration: duration, position: .center)
    }

    static func show(image: UIImage?, duration: TimeInterval = ToastManager.shared.duration) {
        hide()
        let imageView = UIImageView(image: image)
        keyWindow?.showToast(imageView, duration: duration)
    }

    static func show(customView: UIView, duration: TimeInterval = ToastManager.shared.duration) {
        hide()
        keyWindow?.showToast(customView, duration: duration)
    }

    static func hideActivity() {
        keyWindow?.hideToastActivity()
    }

    static func hide() {
        keyWindow?.hideAllToasts(includeActivity: true)
    }
}

protocol Toastable {
    static func showMessage(_ message: String?)
    static func hideToast()
}

extension Toastable {
    public static func showMessage(_ message: String?) {
        UIApplication.shared.keyWindow?.makeToast(message)
    }

    public static func hideToast() {
        UIApplication.shared.keyWindow?.hideToast()
    }
}
