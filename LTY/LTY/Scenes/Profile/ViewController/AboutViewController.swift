//
//  AboutViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController {
    lazy var contentLabel: UILabel = {
        let label = UILabel("", font: FontHelper.regular(14), color: ColorHelper.default.blackText)
        label.numberOfLines = 0
        view.addSubview(label)
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
    }
    
}
extension AboutViewController: ControllerConfigurable {
    func configureSubviews() {
        contentLabel.text = "我要记-记录日常生活中每一个精彩瞬间,你可以用文字或者图片文的形式记录"
    }
    func configureNavigationBar() {
        navigation.item.title = "关于我们"
    }
}
