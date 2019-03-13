//
//  HomeViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WCDBSwift
final class HomeViewModel {
    private let pagesize: Int
    private let condition: Condition?
    init(pageSize: Int = 2, condition: Condition? = nil) {
        self.pagesize = pageSize
        self.condition = condition
    }
    func transform(input: Input) -> Output {
        let refresh = input.headerRefresh.startWith(())
        let refreshState = State()
        let items = refresh.flatMapLatest {
            return HTTPService.shared
                .fethcItems(
                    SFTable.main,
                    from: [],
                    nextTrigger: input.footerRefresh,
                    pagesize: self.pagesize,
                    state: refreshState,
                    where: self.condition)
            }.catchErrorJustComplete().shareOnce()
        
        let dataSource = items.map({
            $0.items.map({HomeViewCellViewModel($0)})
        })
        //当有数据的时候，表示下拉刷状态为 false
        let endHeaderRefresh = dataSource.asObservable().map { _ in false }
        //默认隐藏
        let endFooterRefresh = Observable.from(
            [
                Observable.just(FooterRefreshState.none),
                items.map { result -> FooterRefreshState in
                    if result.items.count == 0 {
                        return FooterRefreshState.none
                    } else if result.items.count < result.offset {
                        return FooterRefreshState.noMoreData
                    } else {
                        return FooterRefreshState.normal
                    }
                }]
            ).merge()
        return Output(endHeaderRefreshing: endHeaderRefresh, endFooterRefreshing: endFooterRefresh, refreshState: refreshState.asDriver(onErrorJustReturn: .idle), dataSource: dataSource)
    }
}
extension HomeViewModel: ViewModelType {
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
