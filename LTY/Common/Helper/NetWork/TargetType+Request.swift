//
//  TargetType+Request.swift
//  CarBook
//
//  Created by 花菜 on 2018/7/18.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation
import RxSwift
import Moya

extension TargetType {
    func request() -> Single<Response> {
        return HTTPService.shared.provider.rx.request(.target(self))
    }
}
