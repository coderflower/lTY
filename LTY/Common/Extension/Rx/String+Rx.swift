//
//  String+Rx.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/10.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import RxSwift
public extension Observable where E == String {
    
    var isEmpty: Observable<Bool> {
        return map { $0.isEmpty }
    }
}
