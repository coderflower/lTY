//
//  HomeViewCellViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import CollectionKit
import Foundation
import RxCocoa
import RxSwift
import SKPhotoBrowser
import UIKit
import WCDBSwift
final class HomeViewCellViewModel {
    lazy var condition = HomeModel.Properties.identifier == (model.identifier ?? 0)
    private let model: HomeModel
    /// item 高度
    let cellHeight: CGFloat
    /// 是否显示内容
    let isHiddenContent: Bool
    /// 是否显示图片
    let isHiddenPhotoView: Bool
    /// 标题
    let title: String
    /// 时间
    let timeString: String
    /// 内容
    let attributedText: NSAttributedString?
    /// 图片
    let images: [UIImage]
    let provider: BasicProvider<UIImage, UIImageView>?
    let textHeight: CGFloat
    static let maxWidth: CGFloat = (UIScreen.width - 40)
    static let singleItemHeight: CGFloat = CGFloat(floor(Float(maxWidth * 0.5)))
    static let doubleItemHeight: CGFloat = CGFloat(floor(Float(maxWidth * 0.4)))
    static let itemHeight: CGFloat = CGFloat(floor(Float((maxWidth - 10) / 3)))
    static let space: CGFloat = 5
    init(_ model: HomeModel) {
        self.model = model
        title = model.title
        isHiddenContent = model.content != nil
        timeString = HomeViewCellViewModel.formatDate(model.createTime)
        let images = model.images?.compactMap({ data in autoreleasepool{UIImage(data: data) }})
        self.images = images ?? []
        isHiddenPhotoView = images?.count == 0
        (cellHeight, textHeight) = HomeViewCellViewModel.calculateViewHeight(content: model.content, imagesCount: images?.count ?? 0)
        self.provider = HomeViewCellViewModel.createProvider(images: images, content: model.content)
        if let content = model.content {
            let attributed = TextSizeHelper.fixLineHeightAttributed(5, font: UIFont.systemFont(ofSize: 15))
            attributedText = NSAttributedString(string: content, attributes: attributed)
        } else {
            attributedText = nil
        }

        guard let provider = provider else {
            return
        }

        provider.tapHandler = { tap in
            let photos = model.images?.compactMap { UIImage(data: $0) }
            guard let images = photos?.compactMap({ SKPhoto.photoWithImage($0) }) else { return }
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(tap.index)
            UIApplication.shared.sf.navigationController?.present(browser, animated: true, completion: {})
        }
    }

    /// 图片布局,
    static func caluclateSizeSource(imagesCount: Int) -> (Int, UIImage, CGSize) -> CGSize {
        return { (_: Int, _: UIImage, collectionSize: CGSize) -> CGSize in

            switch imagesCount {
            case 1:
                return CGSize(width: collectionSize.width, height: singleItemHeight)
            case 2, 3, 4:
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
        let viewSource = ClosureViewSource(viewGenerator: { (_, _) -> UIImageView in
            let imageView = UIImageView()
            imageView.borderWidth = 1
            imageView.borderColor = ColorHelper.default.background
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }, viewUpdater: { (view: UIImageView, data: UIImage, _: Int) in
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
        if date.isToday {
            // 是今天
            formatter.dateFormat = "今天 HH:mm"
            return formatter.string(from: date)
        } else if date.isYesterday {
            // 是昨天
            formatter.dateFormat = "昨天 HH:mm"
            return formatter.string(from: date)
        } else if date.isTheSameYear {
            formatter.dateFormat = "M月-d日 HH:mm"
            return formatter.string(from: date)
        } else {
            formatter.dateFormat = "yyyy年-M月-d日 HH:mm"
            return formatter.string(from: date)
        }
    }

    /// 计算 view 高度
    static func calculateViewHeight(content: String?, imagesCount: Int = 0) -> (cellHeight: CGFloat, textHeigh: CGFloat) {
        var height: CGFloat = 50
        /// 计算文本高度
        var textHeight: CGFloat = 0
        if let content = content, content.count > 0 {
            textHeight = TextSizeHelper.size(content, font: UIFont.systemFont(ofSize: 15), width: maxWidth, lineSpacing: 5).height
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
        case 5, 6:
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
        return (height, textHeight)
    }
}

extension HomeViewCellViewModel: ViewModelType {
    struct Input {
        let deleteTap: Observable<Void>
    }

    struct Output {
        let result: Driver<Bool>
        let deleteState: Driver<UIState>
    }

    func transform(input: HomeViewCellViewModel.Input) -> HomeViewCellViewModel.Output {
        let deleteState = State()
        let result = input.deleteTap.withLatestFrom(Observable.just(model)).flatMapLatest({
            HTTPService.shared.delete(item: $0, where: self.condition).trackState(deleteState).asDriverOnErrorJustComplete()
        }).asDriverOnErrorJustComplete()

        return Output(result: result,
                      deleteState: deleteState.asDriver(onErrorJustReturn: .idle))
    }
}
