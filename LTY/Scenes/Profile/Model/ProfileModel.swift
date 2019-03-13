//
//  ProfileModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation

struct ProfileModel {
    let title: String
    let subTitle: String?
    let accessoryType: AccessoryType
    let actionType: ActionType
    enum AccessoryType: Int {
        case none // don't show any accessory view

        case disclosureIndicator // regular chevron. doesn't track
    }

    enum ActionType: String {
        /// 打开所有日记
        case diary
        /// 设置密码
        case password
        /// 查看所有图片
        case images
        /// 关于我们
        case about
    }

    init(title: String,
         subTitle: String? = nil,
         accessoryType: AccessoryType = .disclosureIndicator,
         actionType: ActionType) {
        self.title = title
        self.subTitle = subTitle
        self.accessoryType = accessoryType
        self.actionType = actionType
    }
}
