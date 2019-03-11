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
import ESTabBarController_swift
class SFTabBarController: ESTabBarController {
    #if DEBUG
    private lazy var fpsLabel: FPSLabel = {
        let label = FPSLabel()
        return label
    }()
    #endif
    override func viewDidLoad() {
        super.viewDidLoad()
        addAllChild()
        configureTabBar()
        #if DEBUG
//        view.addSubview(fpsLabel)
        #endif
    }
    func configureTabBar() {
        tabBar.shadowImage = UIImage(named: "transparent")
        tabBar.backgroundImage = UIImage(named: "background_dark")
        shouldHijackHandler = { _, _, index in
            if index == 1 {
                return true
            }
            return false
        }
        didHijackHandler = { [weak self]_, _, index in
            DispatchQueue.main.asyncAfter(deadline: 0.25, execute: {
                let publish = PublishViewController()
                self?.present(SFNavigationController(rootViewController:publish), animated: true, completion: nil)
            })
        }
    }
    func addAllChild() {
        let home = HomeViewController()
        let publish = UIViewController()
        let profile = ProfileViewController()
        
        home.tabBarItem = tabBarItem(TabBarItemContentView(), title: "今日", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        publish.tabBarItem = tabBarItem(LarityContentView(), title: nil, image: UIImage(named: "publish"), selectedImage: UIImage(named: "publish"))
        profile.tabBarItem = tabBarItem(TabBarItemContentView(), title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
   
        self.viewControllers = [home, publish, profile].map{SFNavigationController(rootViewController: $0)}
    }

    func tabBarItem(_ contentView: ESTabBarItemContentView, title: String?, image: UIImage?, selectedImage: UIImage?) -> ESTabBarItem {
        return ESTabBarItem(contentView,
                            title: title,
                            image: image,
                            selectedImage: selectedImage)
    }

}

extension SFTabBarController {
    
}
