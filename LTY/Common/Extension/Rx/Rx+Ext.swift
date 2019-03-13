//
//  Rx+Ext.swift
//  CarBook
//
//  Created by 花菜 on 2018/8/17.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
public extension ObservableConvertibleType {
    func asDriver(onErrorJustReturnClosure: @escaping @autoclosure () -> E) -> Driver<E> {
        return asDriver { _ in
            Driver.just(onErrorJustReturnClosure())
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { _ in
            Driver.empty()
        }
    }
}
