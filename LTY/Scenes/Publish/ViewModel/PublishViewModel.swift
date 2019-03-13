//
//  PublishViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/8.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

final class PublishViewModel {
    func transform(input: Input) -> Output {
        /// 发布按钮是否能点, 标题不能为空,内容最少10个字或者图片不为空
        let parameters = Observable.combineLatest(input.title, input.content, input.images).map({(title: $0, content: $1, photos: $2)})
        let isPublishEnabled = parameters.map({
            $0.title.count > 1 && (($0.content ?? "").count > 10 || !($0.photos?.isEmpty ?? true))
        })

        let uploadState = State()
        
        let result = input.publishTap.withLatestFrom(parameters).flatMapFirst({
            HTTPService.shared
                .insert(objects: [HomeModel(title: $0.title, content: $0.content, images: $0.photos)])
                .trackState(uploadState)
                .catchErrorJustComplete()
        }).asDriverOnErrorJustComplete()
        return Output(isPublishEnabled: isPublishEnabled, result: result, uploadState: uploadState.asDriver(onErrorJustReturn: .idle))
    }
    
    func upload(title: String, content: String?, photos: [Data]?) -> Observable<Bool> {
        let model = HomeModel(title: title, content: content, images: photos)
        return Observable.create({ (observable) -> Disposable in
            do {
               try DBManager.shared.insert(SFTable.main, objects: [model])
                observable.onNext(true)
                observable.onCompleted()
            } catch {
                observable.onError(error)
            }
            return Disposables.create()
        })
    }
    
    
}

extension PublishViewModel: ViewModelType {
    struct Input {
        let title: Observable<String>
        let content: Observable<String?>
        let images: Observable<[Data]?>
        let publishTap: Observable<Void>
    }
    struct Output {
        let isPublishEnabled: Observable<Bool>
        let result: Driver<Bool>
        let uploadState: Driver<UIState>
    }
}
