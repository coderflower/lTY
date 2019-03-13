//
//  UserTarget.swift
//  LTY
//
//  Created by 花菜 on 2019/3/12.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
import WCDBSwift

extension HTTPService {
    
    
    /// 请求分页数据
    ///
    /// - Parameters:
    ///   - state: ui 状态
    ///   - pagesize: 每页多少条数据
    /// - Returns:
    private func fethcItems(
        _ table:TableProtocol = SFTable.main,
        offset: Int,
        pagesize: Int,
        state: State,
        on propertyConvertibleList: [PropertyConvertible] = HomeModel.Properties.all,
        where condition: Condition? = nil
        ) -> Observable<ListDataHelper<HomeModel>> {
        
        return Observable.create({ (observable) -> Disposable in
            do {
                let objects: [HomeModel] = try table.dataBase.getObjects(on: propertyConvertibleList, fromTable: table.name, where: condition, orderBy: HomeModel.order, limit: pagesize, offset: offset)
                myLog(objects)
                observable.onNext(ListDataHelper<HomeModel>(items: objects, offset: offset + pagesize))
                observable.onCompleted()
            } catch  {
                observable.onError(error)
            }
            return Disposables.create()
        })
            .trackState(state)
            .catchErrorJustReturn(ListDataHelper<HomeModel>(items: [], offset: offset))
    }
    
    func fethcItems(_ table:TableProtocol,
        from: [HomeModel],
        nextTrigger: Observable<Void>,
        pagesize: Int = 10,
        state: State,
        on propertyConvertibleList: [PropertyConvertible] = HomeModel.Properties.all,
        where condition: Condition? = nil
        ) -> Observable<ListDataHelper<HomeModel>> {
        return fethcItems(
            table,
            offset: from.count,
            pagesize: pagesize,
            state: state
            ).flatMapLatest {
                return Observable.concat([
                    Observable.just(ListDataHelper<HomeModel>(items: from + $0.items,offset: $0.offset)),
                    Observable.never().takeUntil(nextTrigger),
                    self.fethcItems(
                        table,
                        from: from + $0.items,
                        nextTrigger: nextTrigger,
                        pagesize: pagesize,
                        state: state,
                        on: propertyConvertibleList,
                        where: condition)
                    ])
        }
    }
    
    public func insert<T: TableCodable>(objects: [T], on propertyConvertibleList: [PropertyConvertible]? = nil, intoTable table:TableProtocol = SFTable.main) -> Observable<Bool> {
        return Observable.create({ (observable) -> Disposable in
            do {
                try table.dataBase.insert(objects: objects, on: propertyConvertibleList, intoTable: table.name)
                observable.onNext(true)
                observable.onCompleted()
            } catch {
                observable.onError(error)
            }
            return Disposables.create()
        })
    }
}




