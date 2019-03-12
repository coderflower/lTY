//
//  PasswordManagerViewModel.swift
//  LTY
//
//  Created by 花菜 on 2019/3/11.
//  Copyright © 2019 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
final class PasswordManagerViewModel {
    func transform(input: Input) -> Output {
        
        
        let isHiddenChangeView = input.isOn.map({!$0})
        
        
        
        return Output(isHiddenChangeView: isHiddenChangeView)
    }
}

extension PasswordManagerViewModel: ViewModelType {
    
    struct Input {
        let isOn: Observable<Bool>
        let changePasswordTap: Observable<Void>
    }
    struct Output {
        let isHiddenChangeView: Observable<Bool>
    }
}
