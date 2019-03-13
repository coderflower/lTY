//
//  TextSizeHelper.swift
//  JOU-Swift
//
//  Created by 花菜 on 2018/5/4.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit

public struct TextSizeHelper {
    fileprivate struct CacheEntry: Hashable {
        let text: String
        let font: UIFont
        let width: CGFloat
        let insets: UIEdgeInsets

        fileprivate var hashValue: Int {
            return text.hashValue ^ Int(width) ^ Int(insets.top) ^ Int(insets.left) ^ Int(insets.bottom) ^ Int(insets.right)
        }
    }

    fileprivate static var cache = [CacheEntry: CGRect]() {
        didSet {
            assert(Thread.isMainThread)
        }
    }

    public static func size(_ text: String, font: UIFont, width: CGFloat, insets: UIEdgeInsets = UIEdgeInsets.zero, lineSpacing: CGFloat? = nil) -> CGRect {
        let key = CacheEntry(text: text, font: font, width: width, insets: insets)
        if let hit = cache[key] {
            return hit
        }
        let constrainedSize = CGSize(width: width - insets.left - insets.right, height: CGFloat.greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any]

        if let lineSpacing = lineSpacing {
            attributes = fixLineHeightAttributed(lineSpacing, font: font)
        } else {
            attributes = [NSAttributedString.Key.font: font]
        }

        let options: NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesFontLeading, .usesLineFragmentOrigin]
        var bounds = text.asNSString.boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
        bounds.size.width = ceil(bounds.width + insets.left + insets.right)
        bounds.size.height = ceil(bounds.height + insets.top + insets.bottom)
        cache[key] = bounds
        return bounds
    }

    /// 修复 lineHeight问题
    static func fixLineHeightAttributed(_ lineSpacing: CGFloat, font: UIFont) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        let lineHeight = lineSpacing + font.lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        let baselineOffset = lineSpacing / 4
        return [.paragraphStyle: paragraphStyle,
                .baselineOffset: baselineOffset,
                .font: font]
    }
}

private func == (lhs: TextSizeHelper.CacheEntry, rhs: TextSizeHelper.CacheEntry) -> Bool {
    return lhs.width == rhs.width && lhs.insets == rhs.insets && lhs.text == rhs.text
}
