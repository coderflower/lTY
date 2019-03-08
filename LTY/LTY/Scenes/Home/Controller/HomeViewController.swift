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

class HomeViewController: UIViewController {
    private lazy var collectionView: CollectionView = {
        let tmpView = CollectionView()
        view.addSubview(tmpView)
        tmpView.provider = provider
        return tmpView
    }()
    let dataSource = ArrayDataSource<HomeViewCellViewModel>(data: [])
    lazy var provider: BasicProvider<HomeViewCellViewModel, HomeItemViewCell> = {
        
        let viewSource = ClosureViewSource<HomeViewCellViewModel, HomeItemViewCell>(viewUpdater: { (view: HomeItemViewCell, data: HomeViewCellViewModel, at: Int) in
           
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
        configureSignal()
        
        let button = UIButton("测试查询", color: ColorHelper.default.blackText, font: FontHelper.regular(20))
        
        view.addSubview(button)
        button.snp.makeConstraints({
            $0.center.equalToSuperview()
        })
    }
}

extension HomeViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = .random
    }
    func configureNavigationBar() {
        navigation.item.title = "今日列表"
        navigation.item.rightBarButtonItem = UIBarButtonItem(title: "关于")
        navigation.item.rightBarButtonItem?.tintColor = .white
    }
    func configureSignal() {
        navigation.item.leftBarButtonItem?.rx.tap.bind(to: rx.goBack).disposed(by: rx.disposeBag)
    }
}
