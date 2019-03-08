//
//  Configurable.swift
//  XZJQ
//
//  Created by 花菜 on 2018/11/23.
//  Copyright © 2018 Coder.flower. All rights reserved.
//

import Foundation

protocol ControllerConfigurable {
    /// 配置子控件
    func configureSubviews()
    /// 配置导航栏
    func configureNavigationBar()
    /// transform input to output
    func configureSignal()
}
extension ControllerConfigurable {
    /// 配置子控件
    func configureSubviews(){}
    /// 配置导航栏
    func configureNavigationBar(){}
    /// transform input to output
    func configureSignal(){}
}

