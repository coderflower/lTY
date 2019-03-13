//
//  AllItemViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import CollectionKit
import MJRefresh
import RxCocoa
import UIKit

class AllItemViewController: ItemViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        provider.tapHandler = { [weak self] tap in
            let vc = DetailViewController(tap.data) { [weak self] in
                self?.collectionView.mj_header.beginRefreshing()
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func configureNavigationBar() {
        navigation.item.title = "所有日记"
    }
}
