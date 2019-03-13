//
//  NSLayoutConstraint-SFExtension.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/13.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

//
//  NSLayoutConstraint-SFExtension.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/13.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    @IBInspectable var fit: Bool {
        get {
            return _autoScale
        }
        set {
            if newValue, !_autoScale {
                _autoScale = true
                constant = constant * SFConst.scale
            } else if !newValue, _autoScale {
                _autoScale = false
                constant = constant / SFConst.scale
            }
        }
    }

    @IBInspectable var autoOffsetBarHeight: Bool {
        get {
            return _isAutoOffsetNavBarHeight
        }
        set {
            if newValue, !_isAutoOffsetNavBarHeight {
                _isAutoOffsetNavBarHeight = true
                constant = constant + SFConst.navigationBarMaxY
            } else if !newValue, _isAutoOffsetNavBarHeight {
                _isAutoOffsetNavBarHeight = false
                constant = constant - SFConst.navigationBarMaxY
            }
        }
    }
}

private extension NSLayoutConstraint {
    struct NSLayoutConstraintRTKeys {
        static var KeyForAutoOffsetNavBarHeight = "KeyForAutoOffsetNavBarHeight"
        static var KeyForAutoScale = "KeyForAutoScale"
    }

    var _isAutoOffsetNavBarHeight: Bool {
        get {
            return objc_getAssociatedObject(self, &NSLayoutConstraintRTKeys.KeyForAutoOffsetNavBarHeight) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &NSLayoutConstraintRTKeys.KeyForAutoOffsetNavBarHeight, newValue as Bool?, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }

    var _autoScale: Bool {
        get {
            return objc_getAssociatedObject(self, &NSLayoutConstraintRTKeys.KeyForAutoScale) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &NSLayoutConstraintRTKeys.KeyForAutoScale, newValue as Bool?, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
