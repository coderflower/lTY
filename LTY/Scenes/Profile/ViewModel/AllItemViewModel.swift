//
//  AllItemViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
final class AllItemViewModel {
    private let pagesize = 3
    func transform(input: Input) -> Output {
        let refresh = input.headerRefresh.startWith(())
        let refreshState = State()
        let items = refresh.flatMapLatest { (_)  -> Observable<ListDataHelper<HomeModel>> in
            return self.requestItems([], nextTrigger: input.footerRefresh, pagesize: self.pagesize, state: refreshState)
            }.shareOnce()
        
        let dataSource = items.map({
            $0.items.map({HomeViewCellViewModel(model: $0)})
        })
        //当有数据的时候，表示下拉刷状态为 false
        let endHeaderRefresh = dataSource.asObservable().map { _ in false }
        //默认隐藏
        let endFooterRefresh = Observable.from([Observable.just(FooterRefreshState.none),
                                                      items.map { result -> FooterRefreshState in
                                                        if result.items.count == 0 {
                                                            return FooterRefreshState.none
                                                        } else if result.items.count < result.offset {
                                                            return FooterRefreshState.noMoreData
                                                        } else {
                                                            return FooterRefreshState.normal
                                                        }
            }]).merge()
        
        return Output(endHeaderRefreshing: endHeaderRefresh, endFooterRefreshing: endFooterRefresh, refreshState: refreshState.asDriver(onErrorJustReturn: .idle), dataSource: dataSource)
    }
    
    

    /// 请求分页数据
    ///
    /// - Parameters:
    ///   - state: ui 状态
    ///   - pagesize: 每页多少条数据
    /// - Returns:
    func fethcItems(offset: Int, pagesize: Int, state: State) -> Observable<ListDataHelper<HomeModel>> {
        
        return Observable.create({ (observable) -> Disposable in
            do {
                let order = [HomeModel.Properties.createTime.asOrder(by: .descending)]
                let objects: [HomeModel] = try DBManager.shared.getObjects(SFTable.main,
                                                                           on: HomeModel.Properties.all,
                                                                           orderBy: order,
                                                                           limit: pagesize,
                                                                           offset: offset) ?? []
                
               myLog(objects)
                
                observable.onNext(ListDataHelper<HomeModel>(items: objects, offset: offset + pagesize))
                observable.onCompleted()
            } catch  {
                observable.onNext(ListDataHelper<HomeModel>(items: [], offset: offset))
                observable.onError(error)
            }
            return Disposables.create()
        })
    }
    
    func requestItems(_ from: [HomeModel], nextTrigger: Observable<Void>, pagesize: Int = 5, state: State) -> Observable<ListDataHelper<HomeModel>> {
        
        return fethcItems(offset: from.count, pagesize: pagesize, state: state).flatMapLatest { (result) -> Observable<ListDataHelper<HomeModel>> in
            /// 追加最新请求的数据
            var originItems = from
            originItems.append(contentsOf: result.items)
            
            let listData = ListDataHelper<HomeModel>(items: originItems, offset: result.offset)
            
            return Observable.concat([
                Observable.just(listData),                    // 发出信号
                Observable.never().takeUntil(nextTrigger),      // 直到上拉加载更多的时候，才进行下一步
                self.requestItems(originItems, nextTrigger: nextTrigger, pagesize: pagesize, state: state) // 在原有数据前提下，请求
                ])
        }
    }
    
}

extension AllItemViewModel: ViewModelType {
    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
    }
    
    struct Output {
        //停止头部刷新状态
        let endHeaderRefreshing: Observable<Bool>
        //停止尾部刷新状态
        let endFooterRefreshing: Observable<FooterRefreshState>
        let refreshState: Driver<UIState>
        let dataSource: Observable<[HomeViewCellViewModel]>
    }
    
}
