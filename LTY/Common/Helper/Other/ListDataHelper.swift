//
//  ListDataHelper.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/27.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
import Moya
import RxSwift
public protocol ListProtocol {
    // 定义返回类型
    associatedtype Item
    // 返回值
    var items: [Item] { get set }
    /// 偏移
    var offset: Int {get set}
    
    func requestList<D: Codable>(_ target: TargetType) -> Observable<D>
}
extension ListProtocol {
    func requestList<D: Codable>(_ target: TargetType) -> Observable<D> {
        
        return Observable.empty()
    }
}

struct ListDataHelper<T: Codable>: ListProtocol {
    /// 列表模型类型
    typealias Item = T
    /// 列表数据
    var items: [T]
    /// 偏移位置
    var offset: Int = 0
    
    func requestList<D: Codable>(_ target: TargetType, responseType: D.Type) -> Observable<D> {
        return target.request().mapObject(D.self).asObservable()
    }
}



