//
//  App.swift
//  LTYUITests
//
//  Created by 花菜 on 2019/3/15.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import XCTest

class App: XCUIApplication {

    func navigateToAllSecondPage() {
        XCTContext.runActivity(named: "跳转所有二级页面") { _ in
            
            self.tabBars.children(matching: .other).element(boundBy: 2).tap()
            
            let scrollViewsQuery = self.scrollViews
            scrollViewsQuery.otherElements.containing(.staticText, identifier:"所有日记").element.tap()
            self.navigationBars.matching(identifier: "所有日记").buttons["nav back"].tap()
            scrollViewsQuery.otherElements.containing(.staticText, identifier:"密码管理").element.tap()
            self.navigationBars.matching(identifier: "密码管理").buttons["nav back"].tap()
            scrollViewsQuery.otherElements.containing(.staticText, identifier:"我的相册").element.tap()
            self.navigationBars.matching(identifier: "照片墙").buttons["nav back"].tap()
            scrollViewsQuery.otherElements.containing(.staticText, identifier:"关于我们").element.tap()
            self.navigationBars.matching(identifier: "关于我们").buttons["nav back"].tap()
            scrollViewsQuery.otherElements.containing(.staticText, identifier:"去评论").element.tap()
            
        }
    }
    
}
