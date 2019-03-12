//
//  NiblessViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

class NiblessViewController: UIViewController {


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    @available(*, unavailable, message: "loading this controller from nib is unsupported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSubviews()
        configureNavigationBar()
        configureSignal()
    }
    
    /// 配置子控件
    func configureSubviews(){}
    /// 配置导航栏
    func configureNavigationBar(){}
    /// transform input to output
    func configureSignal(){}
}
