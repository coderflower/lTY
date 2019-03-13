//
//  AppDelegate+APNS.swift
//  LTY
//
//  Created by 花菜 on 2019/3/13.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import CleanJSON
extension AppDelegate: JPUSHRegisterDelegate {
    
    
    func initJPUSH(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?)  {
        // 通知注册实体类
        let entity = JPUSHRegisterEntity();
        
        
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue);
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self);
        // 注册极光推送
        JPUSHService.setup(withOption: launchOptions, appKey: SFConst.pushAppleKey, channel:"AppStore" , apsForProduction: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveRegistrationID(_:)), name: NSNotification.Name.jpfNetworkDidLogin, object: nil)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo;
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
        /// 前台收到推送
        myLog("前台收到推送")
        receiveNotification(userInfo, isBackground: false)
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo;
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo);
        }
        myLog(userInfo)
        completionHandler();
        myLog("后台收到推送")
        receiveNotification(userInfo)
        
    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//
//        JPUSHService.handleRemoteNotification(userInfo);
//        completionHandler(UIBackgroundFetchResult.newData);
//        /// 后台收到推送
//        receiveNotification(userInfo)
//    }
    
    func receiveNotification(_ info: [AnyHashable : Any]?, isBackground: Bool = true) {
        /// 清空角标
        UIApplication.shared.applicationIconBadgeNumber = 0
        /// 后台直接进入下一步操作,
        guard let model = convert(info: info) else {return}
        myLog(model)
        if isBackground {
            handelAction(model: model)
        } else {
            /// 前台提醒用户
            myLog("前台收到推送")
            receivePushInForeground(model)
        }
    }
    // 接收到推送实现的方法
    func receivePushInForeground(_ model : NotifyModel) {
        
        let alert = UIAlertController(title: model.title,
                                      message: model.desc,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "去看看", style: .default, handler: {action in
            self.handelAction(model: model)
        }))
        UIApplication.shared.sf.navigationController?.present(alert, animated:true, completion:nil)
        
    }
    /// 转换模型
    func convert(info: [AnyHashable : Any]?) -> NotifyModel? {
        
        guard let userInfo = info as? [String: Any] else { return nil}
        debugPrint(userInfo)
        guard let data = try? JSONSerialization.data(withJSONObject: userInfo, options: []) else {
            return nil
        }
        guard let model = try? CleanJSONDecoder().decode(NotifyModel.self, from: data) else {
            return nil
        }
        return model
    }
    /// 处理推送事件
    func handelAction(model: NotifyModel) {
        switch model.pushType {
        case .web:
            self.openWebView(with: model.open_url)
        default:break
        }
    }
    @objc func didReceiveRegistrationID(_ notify: NSNotification) {
        guard let registrationID = JPUSHService.registrationID() else {
            SFToast.show(info: "获取registrationID失败")
            return
        }
        // 保存 registrationID
        myLog(registrationID)
        UserService.shared.user?.registrationId = registrationID
    }
    private func openWebView(with urlString: String?) {
        guard let urlString = urlString else {return}
        
        let webvc = WebViewController(url: urlString)
        
        UIApplication.shared.sf.navigationController?.pushViewController(webvc, animated: true)
    }
    
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if notification?.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            //从通知界面直接进入应用
        }else{
            //从通知设置界面进入应用
        }
    }
}

struct NotifyModel: Codable {
    let title: String
    let desc: String?
    let carnum: String?
    let open_url: String
    let pushType: PushType
    
    enum PushType: String, Codable, CaseDefaultable {
        case normal = "0"
        case target = "1"
        case topic = "2"
        case web = "3"
        case other = "99999"
        static var defaultCase:PushType {
            return .other
        }
    }
}
