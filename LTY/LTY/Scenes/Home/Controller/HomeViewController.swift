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
class HomeViewController: UIViewController {
    private let viewModel = HomeViewModel()
    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        let header = MJRefreshNormalHeader()
        header.lastUpdatedTimeLabel.isHidden = true
        tmpView.mj_header = header
        tmpView.provider = provider
        return tmpView
    }()
    let dataSource = ArrayDataSource<HomeViewCellViewModel>(data: [])
    lazy var provider: BasicProvider<HomeViewCellViewModel, HomeItemViewCell> = {
        
        let viewSource = ClosureViewSource<HomeViewCellViewModel, HomeItemViewCell>(viewGenerator: { (_, _) -> HomeItemViewCell in
            let view = HomeItemViewCell.xibView()
            view.cornerRadius = 5
            return view
        }, viewUpdater: { (view: HomeItemViewCell, data: HomeViewCellViewModel, at: Int) in
            view.update(data)
        })
        let sizeSource = { (index: Int, data: HomeViewCellViewModel, collectionSize: CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: data.cellHeight)
        }
        let provider = BasicProvider<HomeViewCellViewModel, HomeItemViewCell>(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource: sizeSource)
        provider.layout = FlowLayout(spacing: 10).inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
        return provider
    }()
    
    var collectionDataSource: Binder<[HomeViewCellViewModel]> {
        return Binder(self) { this, data in
            data.forEach({
                myLog($0.content)
            })
            this.dataSource.data = data
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
        configureSignal()
        
    }
}

extension HomeViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = ColorHelper.default.background
        collectionView.snp.makeConstraints({
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(navigation.bar.snp.bottom)
        })
    }
    func configureNavigationBar() {
        navigation.item.title = "今日列表"
        navigation.item.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    }
    func configureSignal() {
        let input = HomeViewModel.Input(headerRefresh: collectionView.mj_header.rx.refreshing.shareOnce())
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
    }
}
