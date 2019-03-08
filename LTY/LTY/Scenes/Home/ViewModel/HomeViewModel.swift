//
//  HomeViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
final class HomeViewModel {
    func transform(input: Input) -> Output {
        
        
        
        return Output()
    }
    
    func fetchTodayData() -> Observable<[HomeModel]> {
        
       return Observable.create({ (observable) -> Disposable in
        
            
        
        do {
//
//            Date().isToday()
//            
            let objects: [HomeModel] = try DBManager.shared.selectAll(SFTable.main, condition: (HomeModel.Properties.identifer)) ?? []
            observable.onNext(objects)
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
        let footerRefresh: Observable<Void>
    }
    struct Output {
        
    }
}
