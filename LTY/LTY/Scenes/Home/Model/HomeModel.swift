//
//  HomeModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//
import Foundation

struct HomeModel: Codable {
    /// 创建时间
    let createTime: String
    /// 标题
    let title: String
    /// 内容
    let content: String
}
