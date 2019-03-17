//
//  RegexHelper.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/10.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation

struct RegexHelper {
    let regex: NSRegularExpression
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }

    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.count))
        return matches.count > 0
    }
}

enum Matcher: String {
    case phone = "^1[0-9]{10}$"
    case email = "^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$"
    case passsword = "^[a-zA-Z0-9]{6,16}$"
    /// (?=.*[0-9])^[a-z，A-Z]{1}[a-zA-Z 0-9]{5,} 密码首位必须是字母,至少6位 必须包含数字
    /// (?=.*[0-9])(?=.*[a-zA-Z])(.{8,})$ 8位以上必须同时包含字母和数字
    case number = "[0-9]+$"
    case numberAndLetter = "^[a-zA-Z0-9]+$"
    case nickname = "^[0-9a-zA-Z\\u4e00-\\u9fa5_]{1,10}$"
    case plate = "^[京津沪渝蒙新藏宁桂黑吉辽晋青冀鲁豫苏皖浙闽赣湘鄂粤琼甘陕川云贵]{1}[A-Za-z]{1}[A-Za-z0-9]{5,6}$"
    func match(_ input: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", rawValue)
        return predicate.evaluate(with: input)
    }

    /// 匹配车牌
    static func match(plate: String) -> String? {
        do {
            let pattern = "[京津沪渝蒙新藏宁桂黑吉辽晋青冀鲁豫苏皖浙闽赣湘鄂粤琼甘陕川云贵]{1}[A-Za-z]{1}[A-Za-z0-9]{0,6}"
            let detector = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            if let result = detector.firstMatch(in: plate, options: .reportCompletion, range: NSMakeRange(0, plate.count)),
                plate.count > result.range.location + result.range.length {
                return (plate as NSString).substring(with: result.range)
            }
            return nil
        } catch {
            return nil
        }
    }
}
