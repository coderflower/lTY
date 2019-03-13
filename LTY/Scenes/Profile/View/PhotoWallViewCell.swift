//
//  PhotoWallViewCell.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

class PhotoWallViewCell: NiblessView {
    /// 图片
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        return imageView
    }()

    /// 标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel(nil, font: FontHelper.regular(16), color: UIColor.white)
        bottomView.addSubview(label)
        return label
    }()

    /// 日期
    private lazy var timeLabel: UILabel = {
        let label = UILabel(nil, font: FontHelper.regular(13), color: UIColor.white)
        bottomView.addSubview(label)
        return label
    }()

    private lazy var bottomView: UIView = {
        let view = UIView(UIColor(white: 0, alpha: 0.3))
        addSubview(view)
        return view
    }()

    override func initialize() {
        cornerRadius = 5
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        titleLabel.snp.makeConstraints({
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        })
        timeLabel.snp.makeConstraints({
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-10)
        })
        bottomView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(35)
        })
    }
}

extension PhotoWallViewCell: Updatable {
    func update(_ model: PhotoWallViewCellViewModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        timeLabel.text = model.createTimeString
    }
}
