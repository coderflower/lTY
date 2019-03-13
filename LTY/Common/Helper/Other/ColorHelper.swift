//
//  UIColor.sf.swift
//  JOU-Swift
//
//  Created by 花菜 on 2018/4/28.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

final class ColorHelper {
    static let `default`: ColorHelper = ColorHelper()
    /// #E78170
    var theme: UIColor = {
        UIColor(hex: "E78170")
    }()

    /// #EAEAEA
    var line: UIColor = {
        UIColor(hex: "EAEAEA")
    }()

    /// #8C9AA8
    var lightText: UIColor = {
        UIColor(hex: "8C9AA8")
    }()

    /// #262000
    var blackText: UIColor = {
        UIColor(hex: "262000")
    }()

    /// #4A4A4A
    var darkGray: UIColor = {
        UIColor(hex: "4A4A4A")
    }()

    /// #F1F3F8
    let background: UIColor = {
        UIColor(hex: "f1f3f8")
    }()

    /// 话题颜色#09A9F3
    let topic: UIColor = {
        UIColor(hex: "09A9F3")
    }()

    /// #E4E4E4
    let disabledColor: UIColor = {
        UIColor(hex: "E4E4E4")
    }()
}
