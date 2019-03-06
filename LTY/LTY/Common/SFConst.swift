//
//  SFConst.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//
@_exported import SnapKit
@_exported import CollectionKit
@_exported import EachNavigationBar
import Foundation


public struct SFConst {
    /// 导航栏高度
    public static let navigationBarHeight: CGFloat = {
        return 44
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
        return statusBarHeight + navigationBarHeight
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
public extension SFConst {
    static let bundleShortVersionString = "SFBundleShortVersionString";
}
