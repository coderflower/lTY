//
//  SFTabBarViewController.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import ESTabBarController_swift
import UIKit
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
        tabBar.backgroundImage = UIImage.sf.image(ColorHelper.default.theme)
        shouldHijackHandler = { _, _, index in
            index == 1
        }
        didHijackHandler = { [weak self] _, _, _ in
            DispatchQueue.main.asyncAfter(deadline: 0.25, execute: {
                let publish = PublishViewController()
                self?.present(SFNavigationController(rootViewController: publish), animated: true, completion: nil)
            })
        }
    }

    func addAllChild() {
        let home = HomeViewController(
            HomeViewModel(condition: HomeModel.Properties
                .createTime.between(
                    Date().morningDate,
                    Date().twentyFourDate
            ))
        )
        let publish = UIViewController()
        let profile = ProfileViewController()

        home.tabBarItem = tabBarItem(TabBarItemContentView(), title: "今日", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        publish.tabBarItem = tabBarItem(LarityContentView(), title: nil, image: UIImage(named: "publish"), selectedImage: UIImage(named: "publish"))
        profile.tabBarItem = tabBarItem(TabBarItemContentView(), title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))

        viewControllers = [home, publish, profile].map { SFNavigationController(rootViewController: $0) }
    }

    func tabBarItem(_ contentView: ESTabBarItemContentView, title: String?, image: UIImage?, selectedImage: UIImage?) -> ESTabBarItem {
        return ESTabBarItem(contentView,
                            title: title,
                            image: image,
                            selectedImage: selectedImage)
    }
}

extension SFTabBarController {}
