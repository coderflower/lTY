//
//  Toast+Rx.swift
//  LightCloud
//
//  Created by GorXion on 2018/5/29.
//  Copyright © 2018年 gaoX. All rights reserved.
//

import RxSwift
import RxCocoa

extension SFToast: ReactiveCompatible {}

extension Reactive where Base: SFToast {
    
    static var state: Binder<UIState> {
        return Binder(UIApplication.shared) { _, state in
            switch state {
            case .idle:
                break
            case .loading:
                SFToast.loading()
            case .success(let info):
                if let info = info {
                    SFToast.show(info: info)
                } else {
                    SFToast.hide()
                }
            case .failure(let info):
                if let info = info {
                    SFToast.show(info: info)
                } else {
                    SFToast.hide()
                }
            }
        }
    }
}
