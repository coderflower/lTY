//
//  ProfileViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
        configureSignal()
    }

}
extension ProfileViewController: ControllerConfigurable {
    func configureSubviews() {
        view.backgroundColor = .random
    }
    func configureNavigationBar() {
        navigation.item.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "dismiss"))
    }
    func configureSignal() {
        navigation.item.leftBarButtonItem?.rx.tap.bind(to: rx.goBack).disposed(by: rx.disposeBag)
    }
}
