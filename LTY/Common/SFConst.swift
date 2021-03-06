//
@_exported import CollectionKit
@_exported import EachNavigationBar
import Foundation
@_exported import RxSwiftExt
//  SFConst.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//
@_exported import SnapKit

public struct SFConst {
    static let margin: CGFloat = 10
    /// 导航栏高度
    public static let navigationBarHeight: CGFloat = {
        44
    }()

    /// tabBar 高度
    public static let tabBarHeight: CGFloat = UIDevice.sf.safeAreaInsets.bottom + 49
    /// 状态栏高度
    public static let statusBarHeight: CGFloat = {
        if #available(iOS 11.0, *) {
            return (UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets.top ?? 0)
        } else {
            return 20
        }
    }()

    public static let navigationBarMaxY: CGFloat = {
        statusBarHeight + navigationBarHeight
    }()

    public static let navigationBarMinY: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIDevice.sf.safeAreaInsets.top
        } else {
            return 0
        }
    }()

    /// 屏幕适配比例
    public static let scale: CGFloat = UIScreen.width > 414 ? 414 / 375.0 : UIScreen.width / 375.0
}

/// 静态常量
public extension SFConst {}

public extension SFConst {
    static let pushAppleKey = "f134e0e2fad4dd348ee1a029"
    static let umAppleKey = "5c88b3683fc1956654000de7"
    static let bundleShortVersionString = "SFBundleShortVersionString"
    static let passwordKey = "passwordKey"
    static let hasPasswordKey = "hasPasswordKey"
}
