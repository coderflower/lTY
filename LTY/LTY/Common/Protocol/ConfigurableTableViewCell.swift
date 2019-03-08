//
//  ConfigureableTableViewCell.swift
//  Dolphin
//
//  Created by 花菜 on 2018/5/18.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

protocol Configurable {
    var reuseIdentifier: String { get }
    var cellHeight: CGFloat { get }
    var callBack: (() -> (Void))? {set get}
    func configure(_ cell: UITableViewCell)
}


struct TableViewItemBuilder<T> where T: Updatable, T: UITableViewCell {
    let model: T.Model
    let reuseIdentifier: String
    let cellHeight: CGFloat
    var callBack: (() -> (Void))? = nil
    init(model: T.Model, reuseIdentifier: String = T.reuseIdentifier, cellHeight: CGFloat = UITableView.automaticDimension, callBack: (() -> (Void))? = nil) {
        self.model = model
        self.reuseIdentifier = reuseIdentifier
        self.cellHeight = cellHeight
        self.callBack = callBack
    }
    
    func cell(for tableView: UITableView) -> T {
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! T
    }
}
extension TableViewItemBuilder: Configurable {
    func configure(_ cell: UITableViewCell) {
        if let cell = cell as? T {
            
            cell.update(model)
        }
    }
}
