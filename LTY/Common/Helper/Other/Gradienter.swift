//
//  Gradienter.swift
//  Gradienter_Example
//
//  Created by 花菜 on 2019/1/11.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public struct Gradienter {
    //      A         B
    //       ____G____
    //      |         |
    //      E         F
    //      |         |
    //       ----H----
    //      C         D
    enum Direction {
        case leftToRight
        case topToBottom
        case topLeftToBottomRight
        case botomLeftToTopRight
        case custom(CGPoint, CGPoint)
    }

    static func linearImage(from starColor: UIColor, to endColor: UIColor, direction: Direction = .leftToRight, size: CGSize = CGSize(width: 200, height: 200)) -> UIImage {
        defer {
            UIGraphicsEndImageContext()
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [starColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0, 1]
        switch direction {
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .botomLeftToTopRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case let .custom(startPoint, endPoint):
            gradientLayer.startPoint = startPoint
            gradientLayer.endPoint = endPoint
        }
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let contenxt = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        gradientLayer.render(in: contenxt)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return UIImage()
        }
        return image
    }
}
