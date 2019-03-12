//
//  NibLoadable.swift
//  XZJQ
//
//  Created by 花菜 on 2018/4/28.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
protocol NibLoadable {}
extension UIView: NibLoadable {}

extension NibLoadable where Self: UIView {
    static func xibView(_ nibName: String? = nil) -> Self {
        guard let view = Bundle.main.loadNibNamed(nibName ?? "\(self)", owner: nil, options: nil)?.last! as? Self else {
            fatalError("load from xib error")
        }
        
        return view
    }
    
    static func nib(bundle: Bundle? = nil) -> UINib {
        return UINib.init(nibName: "\(self)", bundle: bundle)
    }
}








