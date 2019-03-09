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
        let parameters = Observable.combineLatest(input.title, input.content, input.images).map({(title: $0, content: $1, images: $2)})
        let isPublishEnabled = parameters.map({
            $0.title.count > 1 && (($0.content ?? "").count > 10 || $0.images.count > 0)
        })

        _ = input.publishTap.withLatestFrom(parameters).flatMapFirst({ result -> Observable<String> in

            /// 保存用户数据,
            /// 标题, 内容, 图片
            let model = HomeModel(title: result.title, content: result.content, images: result.images)
            
            do {
                try DBManager.shared.insert(SFTable.main, objects: [model]) 
            }catch {
                myLog("失败\(error)")
            }

            return Observable<String>.empty()
        }).subscribe()
        
        
        return Output(isPublishEnabled: isPublishEnabled)
    }
    
    
    
}

extension PublishViewModel: ViewModelType {
    struct Input {
        let title: Observable<String>
        let content: Observable<String?>
        let images: Observable<[Data]>
        let publishTap: Observable<Void>
    }
    struct Output {
        let isPublishEnabled: Observable<Bool>
    }
}
