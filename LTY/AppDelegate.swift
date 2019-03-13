//
//  AppDelegate.swift
//  LTY
//
//  Created by 花菜 on 2019/3/6.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initWindow()
        configKeyboard()
        
        configureVender(launchOptions)
        try? DBManager.shared.createTable(dataBase: SFDataBase.main, rootType: HomeModel.self)
        return true
    }
    private func configureVender(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        initJPUSH(launchOptions)
        #if DEBUG
        UMCommonLogManager.setUp()
        UMConfigure.setLogEnabled(true)
        #endif
        MobClick.setCrashReportEnabled(true)
        UMConfigure.initWithAppkey(SFConst.umAppleKey, channel: "App store")
       
    }
    
    /// 初始化窗口
    private func initWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SFTabBarController()
        window?.makeKeyAndVisible()
    }
    /// 键盘配置
    private func configKeyboard() {
        //键盘
        // 控制整个功能是否启用
        IQKeyboardManager.shared.enable = true
        // 控制点击背景是否收起键盘
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        // 控制键盘上的工具条文字颜色是否用户自定义
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        //是否显示占位文字
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        // 输入框距离键盘的距离
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 30.0
        // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
        IQKeyboardManager.shared.toolbarManageBehaviour = .bySubviews;
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

