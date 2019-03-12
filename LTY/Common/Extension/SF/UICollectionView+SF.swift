//
//  UICollectionView-Extension.swift
//  XZJQ
//
//  Created by 花菜 on 2018/4/28.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

extension SFExtension where Base: UICollectionView {
    
    public func cell<T: UICollectionViewCell>(ofType cellType: T.Type,
                                              indexPath: IndexPath) -> T {
       guard let cell = base.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        
        return cell
    }
    
    public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofType type: T.Type,
                                                                              ofKind: String,
                                                                              for indexPath: IndexPath) -> T {
        guard let view = base.dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        return view
    }
}

extension SFExtension where Base: UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        base.register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(nibType: T.Type, reuseIdentifier: String = T.reuseIdentifier) {
        base.register(nibType.nib(), forCellWithReuseIdentifier: reuseIdentifier)
    }
    func register<T: UICollectionReusableView>(_ viewClass: T.Type, forSupplementaryViewOfKind kind: String, withReuseIdentifier reuseIdentifier: String = T.reuseIdentifier) {
        base.register(viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
    }
    func register<T: UICollectionReusableView>(nibType: T.Type, forSupplementaryViewOfKind kind: String, withReuseIdentifier reuseIdentifier: String = T.reuseIdentifier) {
        base.register(nibType, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
    }
}
