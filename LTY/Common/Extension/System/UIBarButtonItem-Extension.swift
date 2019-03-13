//
//  UIBarButtonItem-SFExtension.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/3.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
public extension UIBarButtonItem {
    convenience init(title: String?) {
        self.init(title: title, style: .plain, target: nil, action: nil)
    }

    convenience init(image: UIImage?) {
        self.init(image: image, style: .plain, target: nil, action: nil)
    }
}
