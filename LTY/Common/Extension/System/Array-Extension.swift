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
            if !condition(element) {
                return false
            }
        }
        return true
    }

    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for element in self {
            let key = filter(element)
            if !result.map({ filter($0) }).contains(key) {
                result.append(element)
            }
        }
        return result
    }
}

extension Array where Element: Hashable {
    /// 按指定条件升维
    func grouped(by condition: (Element) -> Element) -> [[Element]] {
        var result: [Element: [Element]] = [:]
        for element in self {
            let key = condition(element)
            if var values = result[key] {
                values.append(key)
                result.updateValue(values, forKey: key)
            } else {
                result.updateValue([element], forKey: key)
            }
        }
        return result.map({ $0.value })
    }
}
