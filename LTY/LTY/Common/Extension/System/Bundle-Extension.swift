//
//  Bundle-SFExtension.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/14.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

extension Bundle {
    public static var nameSpace: String {
        return (Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "") + "."
    }
    
    public static var currentVersion: String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
    }
}
