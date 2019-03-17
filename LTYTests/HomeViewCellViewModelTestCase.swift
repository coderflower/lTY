//
//  HomeViewCellViewModelTestCase.swift
//  LTYTests
//
//  Created by 花菜 on 2019/3/17.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import XCTest
@testable import LTY
class HomeViewCellViewModelTestCase: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
