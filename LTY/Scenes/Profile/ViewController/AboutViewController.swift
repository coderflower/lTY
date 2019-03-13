//
//  AboutViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/12.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNavigationBar()
    }
}

extension AboutViewController: Actionable {
    @IBAction func bottomButtonAction(_: Any) {
        let web = WebViewController(url: "https://github.com/coderflower")
        navigationController?.pushViewController(web, animated: true)
    }
}

extension AboutViewController: ControllerConfigurable {
    func configureNavigationBar() {
        navigation.item.title = "关于我们"
    }
}
