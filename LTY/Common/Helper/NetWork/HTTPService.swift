//
//  HTTPService.swift
//  Dolphin
//
//  Created by 花菜 on 2018/5/16.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Alamofire
import Cache
import Foundation
import Moya
import RxCocoa
import RxSwift

extension Dictionary where Key == String, Value: Any {
    var queryTask: Task {
        return .requestParameters(parameters: self, encoding: Alamofire.URLEncoding.queryString)
    }

    var JSONTask: Task {
        return .requestParameters(parameters: self, encoding: Alamofire.JSONEncoding.default)
    }
}

// MoyaProvider<MultiTarget>
final class HTTPService {
    public static let shared: HTTPService = HTTPService()
    // 多Target共用一个Provider Target->EndPoint->Request
    // public let defaultProvider = MoyaProvider<MultiTarget>(endpointClosure:customEndPointClosure, manager:defaultAlamofireManager(), plugins: [RequestLoadingPlugin(),NetworkLogger()])
    public lazy var provider: MoyaProvider<MultiTarget> = {
        let provider = MoyaProvider<MultiTarget>(endpointClosure: customEndPointClosure, requestClosure: requestClosure(), plugins: [RequestLoadingPlugin(), NetworkLogger()])
        return provider
    }()

    /// 请求闭包
    ///
    /// - Returns: 请求插件
    private func requestClosure() -> MoyaProvider<MultiTarget>.RequestClosure {
        let requestClosure = { (endpoint: Endpoint, requestClosure: @escaping MoyaProvider<MultiTarget>.RequestResultClosure) in
            do {
                var request = try endpoint.urlRequest()
                // 设置请求超时时间
                request.timeoutInterval = 15
                /// 是否保留 cookie
                // request.httpShouldHandleCookies = false

                /// 判断 token 是否过期, 如果不过期直接执行闭包,
                requestClosure(.success(request))
                /// 否则刷新 toekn, 在执行闭包

            } catch {
                return
            }
        }

        return requestClosure
    }

    // MARK: - 设置请求头部信息

    public let customEndPointClosure = { (target: TargetType) -> Endpoint in
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        let endpoint = Endpoint(
            url: url,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        // 设置你的HTTP头部信息（服务器生成的token，用户唯一标识）
        var header = ["Content-Type": "application/json", "os": "0"]
//        if UserService.shared.token.count > 0 {
//            header["token"] = UserService.shared.token
//            header["userid"] = "\(UserService.shared.user.userid)"
//        }
        return endpoint.adding(newHTTPHeaderFields: header)
    }

    // 创建HTTPS请求的认证Manager
    /*
     * 1.客户端用本地保存的根证书解开证书链，确认服务端下发的证书是由可信任的机构颁发的
     * 2.客户端需要检查证书的 domain 域和扩展域，看是否包含本次请求的 host
     */
    public func defaultAlamofireManager() -> Manager {
        let path = Bundle.main.path(forResource: "", ofType: nil) // 本地自签名证书文件位置
        let data = NSData(contentsOfFile: path!)
        let certificates: [SecCertificate] = [data as! SecCertificate]
        let host = "" // 本次请求的包含的host
        let policies: [String: ServerTrustPolicy] = [host: .pinCertificates(certificates: certificates, validateCertificateChain: true, validateHost: true)]
        let manager: Manager = Manager(configuration: URLSessionConfiguration.default,
                                       serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
        return manager
    }
}

// extension HTTPService {
//
//    public static let storage = try? Storage(syncStorage: DiskConfig(name: "RxNetworkCache"), asyncStorage: MemoryConfig())
// }

extension HTTPService {
//    func checkLogin() -> Observable<Bool> {
//
//        if UserService.shared.isLogin {
//            return Observable.just(true)
//        }
//        return Observable.error(HTTPService.Error.status(code: -100, message: "请先登录"))
//    }
}
