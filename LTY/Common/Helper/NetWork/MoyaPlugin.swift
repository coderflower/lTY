//
//  MoyaPlugin.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/14.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Moya
import Result

public protocol SFTargetType: TargetType {
    var isShowHud: Bool { get }
    var parameters: [String: Any] { get }
}

public final class RequestLoadingPlugin: PluginType {
    private static var numberOfRequests: Int = 0 {
        didSet {
            if numberOfRequests > 1 { return }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = self.numberOfRequests > 0
            }
        }
    }

    /// 展示或隐藏加载hud
    public func willSend(_: RequestType, target: TargetType) {
        // show loading
        if let target1 = target as? MultiTarget {
            if let tmp = target1.target as? SFTargetType {
                myLog("客户端请求的参数:")
                myLog(tmp.parameters)
            }
        }
        RequestLoadingPlugin.numberOfRequests += 1
    }

    public func didReceive(_: Result<Response, MoyaError>, target _: TargetType) {
        // hide  loading
        RequestLoadingPlugin.numberOfRequests -= 1
    }
}

/// moya 插件
public final class NetworkLogger: PluginType {
    public func willSend(_ request: RequestType, target _: TargetType) {
        myLog("请求接口 : \(request.request?.url?.absoluteString ?? "")")
    }

    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        myLog("***************************Result*************************")
        myLog("requestURL:\n \(target.baseURL.absoluteString + target.path)")
        if case .requestParameters(let parameters, _) = target.task {
            myLog("参数:\n \(parameters)")
        }
        switch result {
        case let .success(response):
            myLog("----> 请求成功 <----")
            do {
                #if DEBUG
                    let dict = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String: Any]
                    myLog("请求地址:\(target.baseURL.absoluteString + target.path)")
                    print("请求结果-->:\n\(String(data: (try? JSONSerialization.data(withJSONObject: dict ?? [:], options: .prettyPrinted)) ?? Data(), encoding: .utf8) ?? ""))\n")
                #endif
            } catch {
                myLog("----> 解析失败:\(error.localizedDescription) <-----")
            }
        case let .failure(error):
            myLog("----> 请求失败 <-----")
            myLog(error.localizedDescription)
            myLog("***************************End*************************")
        }
        debugPrint()
    }
}
