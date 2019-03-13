//
//  CollectionViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/13.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import CollectionKit
import MJRefresh
import UIKit
class CollectionViewController: NiblessViewController {
    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.isHidden = true
        tmpView.mj_header = header
        // 设置尾部刷新控件
        tmpView.mj_footer = MJRefreshBackNormalFooter()
        /// 包装空数据 provider
        let emptyImageView = UIImageView(image: UIImage(named: "home_empty"))
        emptyImageView.contentMode = .center
        let emptyProvider = EmptyStateProvider(emptyStateView: emptyImageView, content: self.provider)
        tmpView.provider = emptyProvider
        return tmpView
    }()

    let provider: CollectionKit.Provider
    init(provider: CollectionKit.Provider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        collectionView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(navigation.bar.snp.bottom)
        })
    }
}
