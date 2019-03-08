//
//  Updatable.swift
//  CarBook
//
//  Created by 花菜 on 2018/6/11.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//
/// 更新数据协议
protocol Updatable {
    associatedtype Model
    
    func update(_ model: Model)
}
extension Updatable {
    
    func update(_ model: Model) {}
}

