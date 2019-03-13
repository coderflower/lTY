//
//  ListDataHelper.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/27.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Moya
import RxSwift
import UIKit
public protocol ListProtocol {
    // 定义返回类型
    associatedtype Item
    // 返回值
    var items: [Item] { get set }
    /// 偏移
    var offset: Int { get set }

    func requestList<D: Codable>(_ target: TargetType) -> Observable<D>
}

extension ListProtocol {
    func requestList<D: Codable>(_: TargetType) -> Observable<D> {
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

    func requestList<D: Codable>(_ target: TargetType, responseType _: D.Type) -> Observable<D> {
        return target.request().mapObject(D.self).asObservable()
    }

    /// 请求分页数据
    ///
    /// - Parameters:
    ///   - state: ui 状态
    ///   - pagesize: 每页多少条数据
    /// - Returns:
    func fethcItems(offset: Int, pagesize: Int, state _: State) -> Observable<ListDataHelper<HomeModel>> {
        return Observable.create({ (observable) -> Disposable in
            do {
                let order = [HomeModel.Properties.createTime.asOrder(by: .descending)]
                let objects: [HomeModel] = try DBManager.shared.getObjects(
                    SFTable.main,
                    on: HomeModel.Properties.all,
                    orderBy: order,
                    limit: pagesize,
                    offset: offset
                ) ?? []
                myLog(objects)
                observable.onNext(ListDataHelper<HomeModel>(items: objects, offset: offset + pagesize))
                observable.onCompleted()
            } catch {
                observable.onNext(ListDataHelper<HomeModel>(items: [], offset: offset))
                observable.onError(error)
            }
            return Disposables.create()
        })
    }

    func fethcItems(_ from: [HomeModel], nextTrigger: Observable<Void>, pagesize: Int = 10, state: State) -> Observable<ListDataHelper<HomeModel>> {
        return fethcItems(offset: from.count, pagesize: pagesize, state: state).flatMapLatest { (result) -> Observable<ListDataHelper<HomeModel>> in
            Observable.concat([
                Observable.just(ListDataHelper<HomeModel>(items: from + result.items,
                                                          offset: result.offset)),
                Observable.never().takeUntil(nextTrigger),
                self.fethcItems( // 在原有数据前提下，请求
                    from + result.items,
                    nextTrigger: nextTrigger,
                    pagesize: pagesize,
                    state: state
                ),
            ])
        }
    }
}
