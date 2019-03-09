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
    let identifer: Int?
    /// 标题
    let title: String
    /// 内容
    let content: String?
    /// 图片数组
    let images: [Data]?
    /// 创建时间
    let createTime: Date
    init(title: String, content: String?, images: [Data]?) {
        self.identifer = nil
        self.title = title
        self.content = content
        self.images = images
        self.createTime = Date()
    }
}

extension HomeModel: TableCodable {
    enum CodingKeys: String, CodingTableKey, CodingKey {
        typealias Root = HomeModel
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case createTime, title, content, images
        case identifer = "id"
        //Column constraints for primary key, unique, not null, default value and so on. It is optional.
        static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .identifer: ColumnConstraintBinding(isPrimary: true, isAutoIncrement: true),
            ]
        }
    }
}


