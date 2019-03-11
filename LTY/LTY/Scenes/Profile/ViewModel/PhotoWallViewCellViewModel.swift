//
//  PhotoWallViewCellViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import UIKit
final class PhotoWallViewCellViewModel {
    private let model: HomeModel
    let title: String
    let createTimeString: String
    let image: UIImage?
    let images: [UIImage]
    init(_ model: HomeModel ) {
        self.model = model
        self.title = model.title
        if let images = model.images {
            self.images = images.compactMap({UIImage(data: $0)})
            self.image = self.images.first
        } else {
            self.images = []
            self.image = nil
        }
        self.createTimeString = HomeViewCellViewModel.formatDate(model.createTime)
    }
}
