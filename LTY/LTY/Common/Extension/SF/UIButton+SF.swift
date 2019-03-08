//
//  UIButton+SF.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/8.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
extension SFExtension where Base: UIButton{
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State...) {
        state.forEach({base.setBackgroundImage(UIImage.sf.image(color), for: $0)})
        
    }
}
