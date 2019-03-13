//
//  SFNavigationController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit
class SFNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigation.configuration.isEnabled = true
        navigation.configuration.isTranslucent = false
        navigation.configuration.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18),
        ]
        if #available(iOS 11.0, *) {
            navigation.configuration.layoutPaddings = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        } else {
            // Fallback on earlier versions
        }
        navigation.configuration.tintColor = UIColor.white
        navigation.configuration.isShadowHidden = true
        navigation.configuration.barTintColor = ColorHelper.default.theme
        navigation.configuration.backBarButtonItem = .init(style: .image(UIImage(named: "nav_back")), tintColor: UIColor.white)
        navigation.configuration.statusBarStyle = .lightContent
        // Do any additional setup after loading the view.
        interactivePopGestureRecognizer?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count >= 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension SFNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
        if children.count <= 1 {
            return false
        }
        return true
    }
}
