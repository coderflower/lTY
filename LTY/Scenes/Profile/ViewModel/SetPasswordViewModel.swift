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
        let parameters = Observable.combineLatest(input.passwordText, input.repeatText) {
            return (passwordText: $0, repeatText: $1)
        }
        /// 两次长度一致,并且长度都最少6位
        let isConfirmEnabled = parameters.map({
            $0.repeatText.count == $0.passwordText.count && $0.passwordText.count > 5 && $0.repeatText.count > 5
        })
        let setPasswordState = State()
        
        let result = input.confirmTap.withLatestFrom(parameters).flatMapFirst({
            self.configurePassword(password: $0.passwordText, repeateText: $0.repeatText).trackState(setPasswordState, success: "密码设置成功").catchErrorJustComplete()
        })
        return Output(result: result, isConfirmEnabled: isConfirmEnabled, setPasswordState: setPasswordState.asDriver(onErrorJustReturn: .idle))
    }
    func configurePassword(password: String, repeateText: String) -> Observable<Bool> {
        
        if password != repeateText {
           return Observable.error(HTTPService.Error.status(code: -10001, message: "两次输入不一致,请重新输入"))
        }
        
        guard Matcher.passsword.match(password) , Matcher.passsword.match(repeateText)  else {
            return Observable.error(HTTPService.Error.status(code: -10002, message: "密码设置不合理,请重新输入"))
        }
        /// 存储用户密码,
        let user = User(password)
        UserService.shared.user = user
        return Observable.just(true)
    }
}

extension SetPasswordViewModel: ViewModelType {
    struct Input {
        let passwordText: Observable<String>
        let repeatText: Observable<String>
        let confirmTap: Observable<Void>
    }
    struct Output {
        let result: Observable<Bool>
        let isConfirmEnabled: Observable<Bool>
        let setPasswordState: Driver<UIState>
    }
}
