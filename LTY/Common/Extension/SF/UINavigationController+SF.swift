//
//  UINavigationController+SF.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/25.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
public extension SFExtension where Base: UINavigationController {
    public static func push(_ viewController: UIViewController, animated: Bool = true) {
        guard let navigationController = UIViewController.sf.topMost?.navigationController else {
            return
        }
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public static func pop(_ animated: Bool = true) {
        guard let navigationController = UIViewController.sf.topMost?.navigationController else {
            return
        }
        navigationController.popViewController(animated: animated)
    }
    
    
    public static func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        guard let fromViewController = UIViewController.sf.topMost else { return  }
        fromViewController.present(viewController, animated: animated, completion: completion)
    }
    
    public static func dismiss(animated: Bool = true, completion: (() -> Swift.Void)? = nil) {
        guard let fromViewController = UIViewController.sf.topMost else { return  }
        fromViewController.view.endEditing(true)
        fromViewController.dismiss(animated: animated, completion: completion)
    }
    
    public static func showDetail(_ viewController: UIViewController, sender: Any?) {
        guard let fromViewController = UIViewController.sf.topMost else { return  }
        fromViewController.showDetailViewController(viewController, sender: sender)
    }
    
    public static func rootViewController() -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
}
