//
//  HomeViewCellViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import UIKit
final class HomeViewCellViewModel {
    private let model: HomeModel
    /// item 高度
    let cellHeight: CGFloat
    /// 是否显示内容
    let isHiddenContent: Bool
    /// 是否显示图片
    let isHiddenPhotoView: Bool
    /// 标题
    let title: String
    /// 内容
    let content: String?
    /// 图片
    let photos: [UIImage]
    init(model: HomeModel) {
        self.model = model
        self.cellHeight = 100
        self.title = model.title
        self.content = model.content
        self.photos = model.images?.compactMap({UIImage(data: $0)}) ?? []
        self.isHiddenContent = model.content != nil
        self.isHiddenPhotoView = model.images?.count != 0
    }
}
