//
//  UIApplication+SF.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/25.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

extension SFExtension where Base: UIApplication {
    /// 获取当前活动的 nav
    var navigationController: UINavigationController? {
        return UIViewController.sf.topMost?.navigationController
    }
}
