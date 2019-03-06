//
//  SFTabBarViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//
let json = """
[
    {
        "viewController": "HomeViewController",
        "title": "今日",
        "imageName": "icon_tabbar_home_1_normal",
        "selectedImageName": "icon_tabbar_home_1_click",
    },
    {
        "viewController": "PublishViewController",
        "title": "发布",
        "imageName": "icon_tabbar_home_1_normal",
        "selectedImageName": "icon_tabbar_home_1_click",
    },
    {
        "viewController": "ProfileViewController",
        "title": "我的",
        "imageName": "icon_tabbar_home_1_normal",
        "selectedImageName": "icon_tabbar_home_1_click",
    }
]
"""
import UIKit
import CleanJSON
class SFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let models = [
        Model(viewController: HomeViewController(), title: "今日", imageName: "icon_tabbar_home_1_normal", selectedImageName: "icon_tabbar_home_1_click"),
        Model(viewController: HomeViewController(), title: nil, imageName: "button_write_55x40_", selectedImageName: "button_write_55x40_"),
        Model(viewController: HomeViewController(), title: " 我的", imageName: "icon_tabbar_me_2_normal", selectedImageName: "icon_tabbar_me_2_click")
        ]
        tabBar.backgroundImage = UIImage.sf.image(UIColor(hex: "DEDEDE"))
        
        self.viewControllers = models.map{navigationController(with: $0)}
       
        
        
    }

    func navigationController( with model: Model) -> SFNavigationController {
        model.viewController.title = model.title
        model.viewController.tabBarItem.title = model.title
        model.viewController.tabBarItem.image = UIImage(named: model.imageName)
        model.viewController.tabBarItem.selectedImage = UIImage(named: model.selectedImageName)
        if model.title?.isEmpty == true {
            model.viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        }
        return SFNavigationController(rootViewController: model.viewController)
    }

}

extension SFTabBarController {
    struct Model {
        let viewController: UIViewController
        let title: String?
        let imageName: String
        let selectedImageName: String
    }
}
