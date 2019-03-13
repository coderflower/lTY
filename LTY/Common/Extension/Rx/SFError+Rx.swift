//
//  SFError+Rx.swift
//  CarBook
//
//  Created by 花菜 on 2018/5/31.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation
import Moya
import WCDBSwift
public enum ErrorCode: Int {
    /// token 过期
    case tokenExprie = 401
    /// 车牌关闭
    case plateUnopened = 502
}

extension Swift.Error {
    var errorMessage: String {
        guard let error = self as? SFError else { return "未知错误" }
        return error.errorMessage
    }
}

extension WCDBSwift.Error: SFError {
    var errorMessage: String {
        return message ?? "数据库失败"
    }
}

protocol SFError: Swift.Error {
    var errorMessage: String { get }
}

extension MoyaError: SFError {
    var errorMessage: String {
        switch self {
        case .underlying(let error, _):
            guard let error = error as NSError? else { return defaultErrorMessage }
            switch error.code {
            case -1001: return "网络请求超时"
            case -1009: return "网络异常,请检查您的网络后重试"
            default: return defaultErrorMessage
            }
        case .objectMapping, .jsonMapping:
            return "数据解析失败"
        default: return defaultErrorMessage
        }
    }

    private var defaultErrorMessage: String {
        #if DEBUG
            return errorDescription ?? "服务器异常"
        #else
            return "服务器异常"
        #endif
    }
}

/*
 extension ObservableConvertibleType {

 func trackNWState(_ relay: PublishRelay<UIState>,
                   loading: Bool = true,
                   success: String? = nil,
                   failure: @escaping (Error) -> String? = { $0.errorMessage }) -> Observable<E> {
     return trackState(relay, loading: loading, success: success, failure: failure)
 }
 }

 extension ObservableConvertibleType {

 func trackLCState(_ relay: PublishRelay<UIState>,
                   loading: Bool = true,
                   success: String? = nil,
                   failure: @escaping (Error) -> String? = { $0.errorMessage }) -> Observable<E> {
     return trackState(relay, loading: loading, success: success, failure: failure)
 }
 }
 */
