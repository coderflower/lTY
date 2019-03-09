//
//  HomeViewCellViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import UIKit
import CollectionKit

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
    /// 时间
    let timeString: String
    let provider: BasicProvider<UIImage, UIImageView>?
    static let maxWidth: CGFloat = (UIScreen.width - 40)
    static let singleItemHeight: CGFloat = CGFloat(floor(Float(maxWidth * 0.5)))
    static let doubleItemHeight: CGFloat = CGFloat(floor(Float(maxWidth * 0.4)))
    static let itemHeight: CGFloat = CGFloat(floor(Float((maxWidth - 10) / 3)))
    static let space: CGFloat = 5
    init(model: HomeModel) {
        self.model = model
        self.title = model.title
        self.content = model.content
        self.isHiddenContent = model.content != nil
        self.timeString = HomeViewCellViewModel.formatDate(model.createTime)
        let images = model.images?.compactMap({UIImage(data: $0)})
        self.isHiddenPhotoView = images?.count == 0
        self.cellHeight = HomeViewCellViewModel.calculateViewHeight(content: model.content, imagesCount: images?.count ?? 0)
        self.provider = HomeViewCellViewModel.createProvider(images: images, content: model.content)
    }
    /// 图片布局,
    static func caluclateSizeSource(imagesCount: Int) -> (Int, UIImage, CGSize) -> CGSize{
        return { (index: Int, data: UIImage, collectionSize: CGSize) -> CGSize in            
            
            switch imagesCount {
            case 1:
                return CGSize(width: collectionSize.width, height: singleItemHeight)
            case 2,3,4:
                return CGSize(width: doubleItemHeight, height: doubleItemHeight)
            default:
                return CGSize(width: itemHeight, height: itemHeight)
            }
        }
    }
    
    static func createProvider(images: [UIImage]?, content: String?) -> BasicProvider<UIImage, UIImageView>? {
        guard let images = images, !images.isEmpty else {
            return nil
        }
        let dataSource = ArrayDataSource<UIImage>(data: images)
        let sizeSource = caluclateSizeSource(imagesCount: images.count)
        let viewSource = ClosureViewSource(viewGenerator: { (data, index) -> UIImageView in
            let imageView = UIImageView()
            imageView.borderWidth = 1
            imageView.borderColor = ColorHelper.default.background
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }, viewUpdater: {(view: UIImageView, data: UIImage, at: Int) in
            view.image = data
        })
        let provider = BasicProvider(dataSource: dataSource, viewSource: viewSource, sizeSource: sizeSource)
        /// 设置顶部间距10
        if let content = content, content.count > 0 {
            provider.layout = FlowLayout(spacing: 5).inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        } else {
            provider.layout = FlowLayout(spacing: 5).inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        
        return provider
    }
    static let formatter = DateFormatter()
    static func formatDate(_ date: Date) -> String {
        if date.isToday() {
            //是今天
            formatter.dateFormat = "今天HH:mm"
            return formatter.string(from: date)
        }else if date.isYesterday(){
            //是昨天
            formatter.dateFormat = "昨天HH:mm"
            return formatter.string(from: date)
        } else if date.isTheSameYear() {
            formatter.dateFormat = "MM-dd HH:mm"
            return formatter.string(from: date)
        } else{
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: date)
        }
    }
    
    /// 计算 view 高度
    static func calculateViewHeight(content: String?, imagesCount: Int = 0) -> CGFloat {
         var height: CGFloat = 50
        /// 计算文本高度
        if let content = content, content.count > 0 {
            let textHeight = TextSizeHelper.size(content, font: UIFont.systemFont(ofSize: 15), width: maxWidth, lineSpacing: 5).height
            height += textHeight
            /// 文字底部10
            height += 10
        }
        /// 计算图片高度, 1张图 2: 1, 其他图片1:1
        var imageHeight: CGFloat = 0
        switch imagesCount {
        case 1:
            /// 图片距离文字底部间距
           imageHeight = singleItemHeight
        case 2:
            /// 图片距离文字底部间距
            imageHeight = doubleItemHeight
        case 3, 4:
            imageHeight = doubleItemHeight * 2 + space
        case 5 , 6:
            /// 图片距离文字底部间距
            /// 2个 item 高度, 间距5
            imageHeight = (itemHeight * 2 + space)
        case 7, 8, 9:
            /// 图片距离文字底部间距
            imageHeight = (itemHeight * 3 + space * 2)
        default:
            imageHeight = 0
        }
        /// 如果有图片,底部间距要 + 10
        if imageHeight != 0 {
            // 图片底部间距
            height += imageHeight
            height += 10
        }
        return height
    }
}

