//
//  SFExtension.swift
//  JOU-Swift
//
//  Created by 花菜 on 2018/4/28.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

/// 是否开启日志
public func myLog(_ item: Any, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName)---->第\(lineNum)行 \(funcName)")
        print(item)
    #endif
}

public extension CGFloat {
    var fit: CGFloat {
        return CGFloat(ceilf(Float(SFConst.scale * self)))
    }
}

public extension Float {
    var fit: CGFloat {
        return CGFloat(ceilf(Float(SFConst.scale * CGFloat(self))))
    }
}

public extension Double {
    var fit: CGFloat {
        return CGFloat(ceilf(Float(SFConst.scale * CGFloat(self))))
    }
}

public extension Int {
    var fit: CGFloat {
        return CGFloat(ceilf(Float(SFConst.scale * CGFloat(self))))
    }
}

public struct SFExtension<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

/// A type that has reactive extensions.
public protocol SFExtensionCompatible {
    /// Extended type
    associatedtype CompatibleType

    /// Reactive extensions.
    static var sf: SFExtension<CompatibleType>.Type { get set }

    /// Reactive extensions.
    var sf: SFExtension<CompatibleType> { get set }
}

extension SFExtensionCompatible {
    /// Reactive extensions.
    public static var sf: SFExtension<Self>.Type {
        get {
            return SFExtension<Self>.self
        }
        set {
            // this enables using Reactive to "mutate" base type
        }
    }

    /// Reactive extensions.
    public var sf: SFExtension<Self> {
        get {
            return SFExtension(self)
        }
        set {
            // this enables using Reactive to "mutate" base object
        }
    }
}

import class Foundation.NSObject

/// Extend NSObject with `sf` proxy.
extension NSObject: SFExtensionCompatible {}

extension SFExtension where Base: UIButton {
    public var testTitle: String {
        return "testTitle"
    }
}
