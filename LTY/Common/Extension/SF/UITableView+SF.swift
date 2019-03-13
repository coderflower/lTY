//
//  UITableView-Extension.swift
//  XZJQ
//
//  Created by 花菜 on 2018/4/28.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

extension SFExtension where Base: UITableView {
    func cell<T: UITableViewCell>(ofType _: T.Type, reuseIdentifier: String = T.reuseIdentifier) -> T {
        guard let cell = base.dequeueReusableCell(withIdentifier: reuseIdentifier) as? T else {
            fatalError()
        }
        return cell
    }

    func headerFooter<T: UITableViewHeaderFooterView>(ofType _: T.Type, reuseIdentifier: String = T.reuseIdentifier) -> T {
        guard let view = base.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier) as? T else {
            fatalError()
        }
        return view
    }
}

extension SFExtension where Base: UITableView {
    func register<T: UITableViewCell>(_ cellType: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        base.register(cellType, forCellReuseIdentifier: reuseIdentifier)
    }

    func register<T: UITableViewCell>(nibType: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        base.register(nibType.nib(), forCellReuseIdentifier: reuseIdentifier)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(nibType: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        base.register(nibType.nib(), forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }

    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ anyClass: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        base.register(anyClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
}
