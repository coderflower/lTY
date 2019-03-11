//
//  PhotoWallViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
final class PhotoWallViewModel {
    func transform(input: Input) -> Output {
        let state = State()
        let dataSource = input.viewWillAppear.flatMap({
            self.fetchAllData().trackState(state).catchErrorJustComplete().map({$0.map{PhotoWallViewCellViewModel($0)}})
        })
        return Output(dataSource: dataSource, state: state.asDriver(onErrorJustReturn: .idle))
    }
    func fetchAllData() -> Observable<[HomeModel]> {
        return Observable.create({ (observable) -> Disposable in
            do {
                let objects: [HomeModel] = try DBManager.shared.selectAll(SFTable.main) ?? []
                observable.onNext(objects.filter({$0.images?.isEmpty != true}).reversed())
                observable.onCompleted()
            } catch {
                observable.onError(error)
            }
            return Disposables.create()
        })
    }
}
extension PhotoWallViewModel: ViewModelType {
    struct Input {
        let viewWillAppear: Observable<Void>
    }
    struct Output {
        let dataSource: Observable<[PhotoWallViewCellViewModel]>
        let state: Driver<UIState>
    }
}
