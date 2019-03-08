//
//  HomeModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//
import Foundation
import WCDBSwift
struct HomeModel: Codable {
    /// 创建时间
    let createTime: String
    /// 标题
    let title: String
    /// 内容
    let content: String
    /// 图片数组
    let images: [Data]
}

extension HomeModel: TableCodable {
    enum CodingKeys: String, CodingTableKey, CodingKey {
        typealias Root = HomeModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case createTime, title, content, images
    }
}
