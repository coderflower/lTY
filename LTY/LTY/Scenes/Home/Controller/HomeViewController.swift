//
//  HomeViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit
import CollectionKit
class HomeViewController: UIViewController {

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
