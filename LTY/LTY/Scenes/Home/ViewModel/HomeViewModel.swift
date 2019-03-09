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
    func transform(input: Input) -> Output {
        let refreshState = State()
        
        let dataSource = input.headerRefresh.startWith(()).flatMapFirst({
            self.fetchTodayData()
                .trackState(refreshState)
                .catchErrorJustComplete()
                .map({$0.map({HomeViewCellViewModel(model: $0)})})
        }).shareOnce()
        
        
        
        let endHeaderRefreshing = dataSource.asObservable().map({_ in false})
        
        return Output(dataSource: dataSource,
                      refreshState: refreshState.asDriver(onErrorJustReturn: .idle),
                      endHeaderRefreshing: endHeaderRefreshing)
    }
    
    func fetchTodayData() -> Observable<[HomeModel]> {
        return Observable.create({ (observable) -> Disposable in
            do {
                let objects: [HomeModel] = try DBManager.shared.selectAll(SFTable.main, condition: HomeModel.Properties.createTime.between(Date().morningDate(), Date().twentyFourDate())) ?? []
                observable.onNext(objects.reversed())
                observable.onCompleted()
            } catch {
                observable.onError(error)
            }
            return Disposables.create()
        })
    }
}
extension HomeViewModel: ViewModelType {
    struct Input {
        let headerRefresh: Observable<Void>
    }
    struct Output {
        let dataSource: Observable<[HomeViewCellViewModel]>
        let refreshState: Driver<UIState>
        let endHeaderRefreshing: Observable<Bool>
    }
}
