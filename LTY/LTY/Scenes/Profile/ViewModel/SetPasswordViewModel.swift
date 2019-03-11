//
//  SetPasswordViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class SetPasswordViewModel {
    
    func transform(input: Input) -> Output {
        let state = State()
        let result = input.repeatEndSignal.flatMap({ password -> Observable<Bool> in
            UserDefaults.standard.set(password, forKey: SFConst.passwordKey)
            UserDefaults.standard.synchronize()
            return Observable.just(true).trackState(state, success: "密码设置成功")
        })
        return Output(result: result, state: state.asDriver(onErrorJustReturn: .idle))
    }
}

extension SetPasswordViewModel: ViewModelType {
    struct Input {
        let repeatEndSignal: Observable<String>
    }
    struct Output {
        let result: Observable<Bool>
        let state: Driver<UIState>
    }
}
