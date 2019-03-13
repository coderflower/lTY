//
import Foundation
import Moya
//  Response+Rx.swift
//  CarBook
//
//  Created by 花菜 on 2018/7/18.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//
import RxCocoa
import RxSwift

extension Response {
    func mapObject<T: Codable>(_: T.Type) throws -> T {
        let response = try map(HTTPService.Response<T>.self)
        if response.success { return response.data }
        myLog("请求失败: 错误码: \(response.status), reason: \(response.msg)")
        throw HTTPService.Error.status(code: response.status, message: response.msg)
    }
}

public extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
    func mapObject<T: Codable>(_ type: T.Type) -> Single<T> {
        return map { try $0.mapObject(type) }
    }
}

public extension ObservableType where E == Response {
    func mapObject<T: Codable>(_ type: T.Type) -> Observable<T> {
        return map { try $0.mapObject(type) }
    }
}
