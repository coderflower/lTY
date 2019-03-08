//
//  Then+Rx.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/27.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
public extension ObservableType {
    func then(_ closure: @escaping @autoclosure () -> Void) -> Observable<E> {
        return map{
            closure()
            return $0
        }
    }
}
