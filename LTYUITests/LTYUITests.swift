//
//  LTYUITests.swift
//  LTYUITests
//
//  Created by 花菜 on 2019/3/15.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import XCTest

class LTYUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    func testPublish() {
        // 点击添加
        app.navigationBars.matching(identifier: "今日列表").buttons["Add"].tap()
        // 输入标题
        let textField = app.textFields["在这里输入标题"]
                textField.typeText("测试标题")
        // 输入文字
        let textView = app.textViews
            .containing(
                .staticText,
                identifier:"在这里编辑内容,最多1000字")
            .element
        textView.tap()
        // 输入文字
        textView.typeText("测试文本内容,很多多字")
        // 点击加号添加图片
        app.scrollViews
            .otherElements
            .containing(.image, identifier:"addImage")
            .element
            .tap()
        
        /// 选择图片
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 1).otherElements.children(matching: .button).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).otherElements.children(matching: .button).element.tap()
        collectionViewsQuery.children(matching: .cell).element(boundBy: 6).otherElements.children(matching: .button).element.tap()
        // 图片选择完成
        app.buttons["完成"].tap()
        // 发布
        app.navigationBars.matching(identifier: "添加日记").buttons["发布"].tap()
        
        /// 等待3秒
        sleep(3)
        
        
    }
    
}


