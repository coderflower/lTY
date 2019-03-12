//
//  HomeItemViewCell.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

class HomeItemViewCell: UIView {
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    /// 文本内容
    @IBOutlet weak var contentLabel: UILabel!
    /// 图片内容
    @IBOutlet weak var photoView: PhotoView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
   
}

extension HomeItemViewCell: Updatable {
    func update(_ model: HomeViewCellViewModel) {
        titleLabel.text = model.title
        contentLabel.attributedText = model.attributedText
        timeLabel.text = model.timeString
        contentLabel.isHighlighted = model.isHiddenContent
        photoView.isHidden = model.isHiddenPhotoView
        photoView.update(model.provider)
    }
}
