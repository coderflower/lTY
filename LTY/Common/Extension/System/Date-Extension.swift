//
//  Date-Extension.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation

extension Date {
    var isToday: Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)

        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }

    var isYesterday: Bool {
        let calendar = Calendar.current
        // 当前时间
        let nowComponents = calendar.dateComponents([.day], from: Date())
        // self
        let selfComponents = calendar.dateComponents([.day], from: self as Date)
        let cmps = calendar.dateComponents([.day], from: selfComponents, to: nowComponents)
        return cmps.day == 1
    }

    var isTheSameYear: Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year]
        let nowComps = calendar.dateComponents(unit, from: Date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        return (selfCmps.year == nowComps.year)
    }

    /// 获取对应时间的零点时间..
    var morningDate: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return (calendar.date(from: components))!
    }

    /// 获取对应时间的 24点时间
    var twentyFourDate: Date {
        /// 0点 加 24 * 60 * 60 = 86400
        return morningDate.addingTimeInterval(86400)
    }

    /// 转换为当前时区的事件
    func transformDate() -> Date {
        let zone = NSTimeZone.system
        let interval = zone.secondsFromGMT()
        return addingTimeInterval(TimeInterval(interval))
    }
}
