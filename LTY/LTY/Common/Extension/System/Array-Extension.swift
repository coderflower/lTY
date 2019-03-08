//
//  Array-Extension.swift
//  CarBook
//
//  Created by 花菜 on 2018/7/12.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation

extension Array {
    func every(_ condition: (Element) -> Bool) -> Bool {
        for element in self {
            if !(condition(element)) {
                return false
            }
        }
        return true
    }

    
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
