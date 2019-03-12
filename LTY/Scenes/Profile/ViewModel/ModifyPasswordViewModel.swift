//
//  ModifyPasswordViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
final class ModifyPasswordViewModel {
    func transform(input: Input) -> Output {
        
        let parameters = Observable.combineLatest(input.oldPassword, input.newPassword) {
            return (oldPassword: $0, newPassword: $1)
        }
        
        let isConfirmEnabled = parameters.map({
            $0.oldPassword.count >= 6 && Matcher.passsword.match($0.newPassword)
        })
        let changePasswordState = State()
        
        let result = input.confirmTap.withLatestFrom(parameters).flatMap({
            self.checkPassword($0.oldPassword, newPassword: $0.newPassword)
                .trackState(changePasswordState, success: "密码修改成功").catchErrorJustComplete()
        }).asDriverOnErrorJustComplete()
        
        return Output(isConfirmEnabled: isConfirmEnabled,
                      result: result,
                      changePasswordState: changePasswordState.asDriver(onErrorJustReturn: .idle))
    }
    func checkPassword(_ oldPassword: String, newPassword: String) -> Observable<Bool> {
        if oldPassword == newPassword {
            return  Observable.error(HTTPService.Error.status(code: -100, message: "新密码与旧密码相同, 请重新设置"))
        }
        /// 获取本地旧密码 ,
        guard let password = UserDefaults.standard.string(forKey: SFConst.passwordKey) else {
            return  Observable.error(HTTPService.Error.status(code: -101, message: "您还没有设置密码"))
        }
        /// 修改成功
        if password == oldPassword {
            
            /// 判断新密码是否符合规则 8-16位
            if  Matcher.passsword.match(newPassword) {
                UserDefaults.standard.set(newPassword, forKey: SFConst.passwordKey)
                UserDefaults.standard.synchronize()
                return Observable.just(true)
            } else {
                return  Observable.error(HTTPService.Error.status(code: -102, message: "新密码必须为6-16位字母和数字"))
            }
        } else {
            /// 原密码错误
            return  Observable.error(HTTPService.Error.status(code: -101, message: "旧密码错误,请重新输入"))
        }
    }
}

extension ModifyPasswordViewModel: ViewModelType {
    struct Input {
        let oldPassword: Observable<String>
        let newPassword: Observable<String>
        let confirmTap: Observable<Void>
    }
    struct Output {
        let isConfirmEnabled: Observable<Bool>
        let result: Driver<Bool>
        let changePasswordState: Driver<UIState>
    }
}

