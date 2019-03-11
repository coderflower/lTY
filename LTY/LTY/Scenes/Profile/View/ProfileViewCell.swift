//
//  ProfileViewCell.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

final class ProfileViewCell: NiblessView {
    lazy var titleLabel: UILabel = {
        let label = UILabel(font: FontHelper.regular(14), color: ColorHelper.default.blackText)
        addSubview(label)
        return label
    }()
    lazy var subTitleLabel: UILabel = {
        let label = UILabel(font: FontHelper.regular(14), color: ColorHelper.default.blackText)
        addSubview(label)
        return label
    }()
    lazy var accessoryView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon_more"))
        addSubview(imageView)
        return imageView
    }()
    override func initialize() {
        backgroundColor = UIColor.white
        titleLabel.snp.makeConstraints({
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        })
        subTitleLabel.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        })
        accessoryView.snp.makeConstraints({
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        })
    }

}
extension ProfileViewCell: Updatable {
    func update(_ model: ProfileModel) {
        accessoryView.isHidden = model.accessoryType == .none
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
    }
}
