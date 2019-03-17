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
        super.tearDown()
    }

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
    
    /// 测试有内容有图片
    func testHomeModelTextAndImage() {
        /// given
        let images = [
            UIImage(named: "logo"),
            UIImage(named: "logo"),
            UIImage(named: "logo")
        ]
        let imagesData = images.compactMap({$0?.pngData()})
        let model = HomeModel(title: "测试标题",
                              content: "文本内容很多文字文本内容很多文字文本内容很多文字文本内容很多文字",
                              images: imagesData)
        /// when
        let viewModel = HomeViewCellViewModel(model)
        /// then
        XCTAssertEqual(viewModel.images.count, model.images?.count)
        XCTAssertEqual(viewModel.isHiddenContent, false)
        XCTAssertEqual(viewModel.isHiddenPhotoView, false)
        XCTAssertTrue(viewModel.timeString.contains("今天"))
    }
    func testHomeModelJustText() {
        /// given
        let model = HomeModel(title: "测试标题",
                              content: "文本内容很多文字文本内容很多文字文本内容很多文字文本内容很多文字")
        /// when
        let viewModel = HomeViewCellViewModel(model)
        /// then
        XCTAssertTrue(viewModel.images.isEmpty)
        XCTAssertEqual(viewModel.isHiddenContent, false)
        XCTAssertEqual(viewModel.isHiddenPhotoView, true)
        XCTAssertTrue(viewModel.timeString.contains("今天"))
    }
    
    func testHomeModelJustImages() {
        /// given
        let images = [
            UIImage(named: "logo"),
            UIImage(named: "logo"),
            UIImage(named: "logo")
        ]
        let imagesData = images.compactMap({$0?.pngData()})
        /// when
        let model = HomeModel(title: "测试标题",
                              images: imagesData)
        
        let viewModel = HomeViewCellViewModel(model)
        /// then
        XCTAssertEqual(viewModel.images.count, model.images?.count)
        XCTAssertEqual(viewModel.isHiddenContent, true)
        XCTAssertEqual(viewModel.isHiddenPhotoView, false)
        XCTAssertEqual(viewModel.textHeight, 0)
        XCTAssertTrue(viewModel.timeString.contains("今天"))
    }
}
