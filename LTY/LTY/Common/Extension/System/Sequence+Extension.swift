//
//  Sequence+Extension.swift
//  CarBook
//
//  Created by 花菜 on 2018/7/25.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation
public extension Sequence {
    
    /// 检查所有元素是否都满足条件
    /// - Example [2,4,6,8,10].all { $0 % 2 == 0 } // true
    /// - Parameter predicate: 判断单个元素是否满足条件
    /// - Returns: 是否所有的元素都满足条件
    public func all(matching predicate: (Element) -> Bool) -> Bool {
        // 对于一个条件，如果没有元素不满足它的话，那意味着所有元素都满足它：
        return !contains { !predicate($0) }
    }
    
    /// 查找最后一个符合条件的元素
    /// - Example let match = ["abca", "cai", "flower"].last { $0.hasSuffix("a") }
    /// - Parameter predicate:
    /// - Returns: 符合条件的元素,如果有就返回,没有返回 nil
    func last(where predicate: (Element) -> Bool) -> Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}
