//
//  HomeViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit
import CollectionKit
import MJRefresh
import EachNavigationBar
import RxCocoa
class HomeViewController: NiblessViewController {
    private let viewModel: HomeViewModel
    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.isHidden = true
        tmpView.mj_header = header
        //设置尾部刷新控件
        tmpView.mj_footer = MJRefreshBackNormalFooter()
        /// 包装空数据 provider
        let emptyImageView = UIImageView(image: UIImage(named: "home_empty"))
        emptyImageView.contentMode = .center
        let emptyProvider = EmptyStateProvider(emptyStateView: emptyImageView, content: self.provider)
        tmpView.provider = emptyProvider
        return tmpView
    }()
    private let dataSource = ArrayDataSource<HomeViewCellViewModel>(data: [])
    lazy var provider = Provider.shared.homeProvider(dataSource: dataSource)
    init(_ viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.rx
            .notification(NotifyName.userUploadCompleteNotification)
            .bind(to: userUploadCompleteNotification)
            .disposed(by: rx.disposeBag)
    }
    override func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        collectionView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(navigation.bar.snp.bottom)
        })
    }
    override func configureNavigationBar() {
        navigation.item.title = "今日列表"
        navigation.item.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }
    override func configureSignal() {
        let input = HomeViewModel.Input(headerRefresh: collectionView.mj_header.rx.refreshing.shareOnce(), footerRefresh: collectionView.mj_footer.rx.refreshing.shareOnce())
        let output = viewModel.transform(input: input)
        output.dataSource
            .bind(to: collectionDataSource)
            .disposed(by: rx.disposeBag)
        output.refreshState
            .drive(SFToast.rx.state)
            .disposed(by: rx.disposeBag)
        output.endHeaderRefreshing
            .bind(to: collectionView.mj_header.rx.isRefreshing)
            .disposed(by: rx.disposeBag)
        output.endFooterRefreshing
            .bind(to: collectionView.mj_footer.rx.refreshState)
            .disposed(by: rx.disposeBag)
        navigation.item.rightBarButtonItem?.rx.tap.asObservable().bind(to: publishTap).disposed(by: rx.disposeBag)
    }
}

extension HomeViewController {
    
    var publishTap: Binder<Void> {
        return Binder(self) {this ,_ in
            /// 执行操作
            let publish = PublishViewController()
            let nav = SFNavigationController(rootViewController:publish)
            this.present(nav,animated: true, completion: nil)
        }
    }
    var collectionDataSource: Binder<[HomeViewCellViewModel]> {
        return Binder(self) { this, data in
            this.dataSource.data = data
        }
    }
    var userUploadCompleteNotification: Binder<Notification> {
        return Binder(self) {this ,_ in
            this.collectionView.mj_header.beginRefreshing()
        }
    }
}
