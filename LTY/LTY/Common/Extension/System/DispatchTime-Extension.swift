//
//  DispatchTime-Extension.swift
//  CarBook
//
//  Created by 花菜 on 2018/7/15.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation

extension DispatchTime: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = DispatchTime.now() + .seconds(value)
    }
}
extension DispatchTime: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = DispatchTime.now() + .milliseconds(Int(value * 1000))
    }
}
