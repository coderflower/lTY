//
//  LTYTests.swift
//  LTYTests
//
//  Created by 花菜 on 2019/3/15.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import XCTest
import WCDBSwift
@testable import LTY
class LTYTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try? DBManager.shared.createTable(dataBase: SFDataBase.test , table: SFTable.test, rootType: HomeModel.self)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

    func testInsertData() {
        /// 测试插入数据
        let model = HomeModel(title: "测试标题", content: "测试内容文字必须大于10")
       XCTAssertNoThrow(try SFTable.test.dataBase.insert(objects: [model], intoTable: SFTable.test.name))
    }
    
    func testSelectedData() {
        /// 测试查询数据
        let objects: [HomeModel]? = try? SFTable.test.dataBase.getObjects(on: HomeModel.Properties.all, fromTable: SFTable.test.name, where: HomeModel.Properties.title == "测试标题")
        
        XCTAssertNotNil(objects)
    }
    
}
