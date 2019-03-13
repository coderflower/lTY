//
//  FontHelper.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/14.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
extension SFExtension where Base: UIFont {
    /// 平方特细
    static func thin(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Thin", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }

    /// 平方细体
    static func light(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Light", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }

    /// 平方常规
    static func regular(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Regular", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }

    /// 平方粗体
    static func medium(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Medium", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }

    /// 平方特粗
    static func semibold(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Semibold", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }
}

struct FontHelper {
    /// 平方特细
    static func thin(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Thin", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }

    /// 平方细体
    static func light(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Light", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }

    /// 平方常规
    static func regular(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Regular", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }

    /// 平方粗体
    static func medium(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Medium", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }

    /// 平方特粗
    static func semibold(_ size: CGFloat) -> UIFont {
        let font = UIFont(name: "PingFangSC-Semibold", size: size.fit)
        return font ?? UIFont.systemFont(ofSize: size.fit)
    }
}
