//
//  AddPhotoViewCell.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

final class AddPhotoViewCell: NiblessView {
    private lazy var closeButton: UIButton = {
        let tmpButton = UIButton(type: .custom)
        addSubview(tmpButton)
        tmpButton.setImage(UIImage(named: "dismiss"), for: .normal)
        tmpButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        return tmpButton
    }()

    private lazy var imageView: UIImageView = {
        let tmpImageView = UIImageView()
        tmpImageView.borderColor = ColorHelper.default.line
        tmpImageView.borderWidth = 1
        tmpImageView.contentMode = .scaleAspectFill
        tmpImageView.clipsToBounds = true
        addSubview(tmpImageView)
        return tmpImageView
    }()

    private lazy var placeHolderImageView: UIImageView = {
        let tmpImageView = UIImageView()
        tmpImageView.contentMode = .scaleAspectFill
        tmpImageView.image = UIImage(named: "addImage")
        addSubview(tmpImageView)
        return tmpImageView
    }()

    var completion: ((Int) -> Void)?
    /// 图片索引
    var index: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        imageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        placeHolderImageView.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
        closeButton.snp.makeConstraints({
            $0.top.right.equalToSuperview()
            $0.width.height.equalTo(30)
        })
    }
}

extension AddPhotoViewCell: Actionable {
    @objc private func closeButtonAction() {
        completion?(index)
    }
}

extension AddPhotoViewCell: Updatable {
    func update(_ model: PhotoModel) {
        if let image = model.image {
            imageView.image = image
            closeButton.isHidden = false
            placeHolderImageView.isHidden = true
        } else {
            imageView.image = nil
            closeButton.isHidden = true
            placeHolderImageView.isHidden = false
        }
    }
}
