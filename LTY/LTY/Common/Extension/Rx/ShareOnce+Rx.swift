//
//  ShareOnce+Rx.swift
//  CarBook
//
//  Created by 花菜 on 2018/5/31.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//
import RxSwift
extension ObservableType {
    
    func shareOnce() -> Observable<E> {
        return share(replay: 1)
    }
}
