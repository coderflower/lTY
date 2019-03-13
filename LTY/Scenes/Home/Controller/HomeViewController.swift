//
//  HomeViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import RxCocoa
import UIKit
class HomeViewController: ItemViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /// 用户发布新的日记,需要更新列表
        NotificationCenter.default.rx
            .notification(NotifyName.userUploadCompleteNotification)
            .bind(to: shouldRefreshNotification)
            .disposed(by: rx.disposeBag)
        /// 用户删除日志如果更新列表
        NotificationCenter.default.rx
            .notification(NotifyName.deleteCompleteNotification)
            .bind(to: shouldRefreshNotification)
            .disposed(by: rx.disposeBag)
    }

    override func configureNavigationBar() {
        navigation.item.title = "今日列表"
        navigation.item.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }

    override func configureSignal() {
        super.configureSignal()
        navigation.item.rightBarButtonItem?.rx.tap.asObservable().bind(to: publishTap).disposed(by: rx.disposeBag)
    }
}

extension HomeViewController {
    var publishTap: Binder<Void> {
        return Binder(self) { this, _ in
            /// 执行操作
            let publish = PublishViewController()
            let nav = SFNavigationController(rootViewController: publish)
            this.present(nav, animated: true, completion: nil)
        }
    }

    var shouldRefreshNotification: Binder<Notification> {
        return Binder(self) { this, _ in
            this.collectionView.mj_header.beginRefreshing()
        }
    }
}
