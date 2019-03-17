//
//  PhotoWallViewCellViewModelTestCase.swift
//  LTYTests
//
//  Created by 花菜 on 2019/3/17.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import XCTest
@testable import LTY
class PhotoWallViewCellViewModelTestCase: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTransformModelToViewModel() {
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
        let viewModel = PhotoWallViewCellViewModel(model)
        
        XCTAssertEqual(model.title, viewModel.title)
        XCTAssertEqual(model.images?.count, viewModel.images.count)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
