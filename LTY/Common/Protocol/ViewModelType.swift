//
//  ViewModelType.swift
//  XZJQ
//
//  Created by 花菜 on 2018/5/5.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    /// Tansform Action for DataBinding
    func transform(input: Input) -> Output
}
