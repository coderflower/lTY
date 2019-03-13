//
//  PhotoView.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import CollectionKit
import SKPhotoBrowser
import UIKit
class PhotoView: UIView {
    let collectionView = CollectionView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    func initialize() {
        collectionView.showsVerticalScrollIndicator = false
        addSubview(collectionView)
    }

    override func layoutSubviews() {
        collectionView.frame = bounds
    }
}

extension PhotoView: Updatable {
    func update(_ model: BasicProvider<UIImage, UIImageView>?) {
        guard let provider = model else {
            return
        }
        collectionView.provider = provider
    }
}
