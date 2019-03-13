//
//  UIViewController-Extension.swift
//  XZJQ
//
//  Created by 花菜 on 2018/4/28.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(ofType type: T.Type = T.self) -> T {
        guard let viewController = instantiateViewController(withIdentifier: type.reuseIdentifier) as? T else {
            fatalError()
        }
        return viewController
    }
}

public extension SFExtension where Base: UIViewController {
    static var topMost: UIViewController? {
        let rootViewController = UIApplication.shared.windows.first?.rootViewController
        return self.topMost(of: rootViewController)
    }

    static func topMost(of viewController: UIViewController?) -> UIViewController? {
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return topMost(of: selectedViewController)
        }

        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return topMost(of: visibleViewController)
        }

        if let presentedViewController = viewController?.presentedViewController {
            return topMost(of: presentedViewController)
        }

        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return topMost(of: childViewController)
            }
        }

        return viewController
    }
}

public extension SFExtension where Base: UIViewController {
    /// scrollView去除偏移量
    func disablesAdjustScrollViewInsets(_ scrollView: UIScrollView) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            base.automaticallyAdjustsScrollViewInsets = false
        }
    }

    func alert(title: String?,
               message: String?,
               preferredStyle: UIAlertController.Style = .alert,
               cancelTitle: String?,
               otherTitles: [String],
               completionHandler: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

        if let title = cancelTitle {
            alert.addAction(UIAlertAction(title: title, style: .cancel, handler: { _ in
                completionHandler(0)
            }))
        }

        if !otherTitles.isEmpty {
            otherTitles.enumerated().forEach { index, title in
                alert.addAction(UIAlertAction(title: title, style: .default, handler: { _ in
                    completionHandler(index + 1)
                }))
            }
        }

        base.present(alert, animated: true, completion: nil)
    }

    func goBack(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard base.presentingViewController != nil else {
            base.navigationController?.popViewController(animated: animated)
            return
        }
        if let nav = base.navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
            return
        }
        base.dismiss(animated: animated, completion: completion)
    }
}
