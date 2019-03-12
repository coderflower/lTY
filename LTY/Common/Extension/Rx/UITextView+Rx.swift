//
//  UITextView+Rx.swift
//  CarBook
//
//  Created by 花菜 on 2018/8/17.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
public extension Reactive where Base: UITextView {

    var delegate: TextViewDelegateProxy {
        return TextViewDelegateProxy.proxy(for: base)
    }
}

public extension UITextView {

    var maxLength: Int {
        get { return 0 }
        set {
            TextViewDelegateProxy.proxy(for: self).shouldChangeText = { (textView, range, string) -> Bool in
                if string.isEmpty { return true }
                guard let text = textView.text else { return true }
                let length = text.count + string.count - range.length
                return length <= newValue
            }
        }
    }
}

public class TextViewDelegateProxy: DelegateProxy<UITextView, UITextViewDelegate>, DelegateProxyType, UITextViewDelegate {
    /// Typed parent object.
    public weak private(set) var textView: UITextView?
    
    public init(textView: ParentObject) {
        self.textView = textView
        super.init(parentObject: textView, delegateProxy: TextViewDelegateProxy.self)
    }
    
    public static func registerKnownImplementations() {
        self.register { TextViewDelegateProxy(textView: $0) }
    }
   
    public static func currentDelegate(for object: UITextView) -> UITextViewDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: UITextViewDelegate?, to object: UITextView) {
        object.delegate = delegate
    }
    
    /// - parameter textview: Parent object for delegate proxy.

    public typealias ShouldChangeText = (UITextView, NSRange, String) -> Bool
    
    public var shouldChangeText: ShouldChangeText = { _, _, _ in true }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return shouldChangeText(textView, range, text)
    }
}
