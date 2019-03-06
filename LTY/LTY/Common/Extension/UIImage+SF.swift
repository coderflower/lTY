//
//  UIImage-SFExtension.swift
//  CB-Swift
//
//  Created by 花菜 on 2018/4/13.
//  Copyright © 2018年 Coder.flower. All rights reserved.
//

import UIKit


extension SFExtension where Base: UIImage {
    
    
    /// 圆形图片裁剪
    ///
    /// - Parameters:
    ///   - image: 原图片
    ///   - size: 目标大小
    /// - Returns: 新的图片
    func resizing(size: CGSize?, backColor: UIColor = UIColor.white, borderColor: UIColor = UIColor.lightGray, borderWidth: CGFloat = 1) -> UIImage? {
        // 0. 获取矩形框
        var size = size
        if size == nil {
            let width = min(base.size.width, base.size.height)
            size = CGSize(width: width, height: width)
        }
        let rect = CGRect(origin: CGPoint(), size: size!)
        // 1. 开启上下文
        /**
         参数:
         1. size: 绘图尺寸
         2. opaque: 不透明度
         3. scale: 设置为0会自动根据主屏幕的分辨率,默认使用1.0的分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        // 2. 背景填充
        backColor.setFill()
        UIRectFill(rect)
        
        // 3. 创建圆形路径
        let path = UIBezierPath(ovalIn: rect)
        // 4. 路径裁切
        path.addClip()
        
        // 5. 绘制图片
        base.draw(in: rect)
        
        // 6.绘制内切边框
        let ovalPath = UIBezierPath(ovalIn: rect)
        
        borderColor.setStroke()
        ovalPath.lineWidth = borderWidth
        ovalPath.stroke()
        
        // 7. 获取图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 8. 关闭上下文
        UIGraphicsEndImageContext()
        // 9. 返回结果
        return newImage
    }
    
    static func image(_ color: UIColor) -> UIImage {
        let imageW = 3.0
        let imageH = 3.0
        // 1.开启基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageW, height: imageH), false, 0.0)
        // 2.画一个color颜色的矩形框
        color.set()
        
        UIRectFill(CGRect(x: 0, y: 0, width: imageW, height: imageH))
        
        // 3.拿到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4.关闭上下文
        UIGraphicsEndImageContext()
        
        return image ?? UIImage();
        
    }
    
    //将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        
        if base.size.width/base.size.height > ratio {
            newSize = CGSize(width: base.size.height * ratio, height: base.size.height)
        }else{
            newSize = CGSize(width: base.size.width, height: base.size.width / ratio)
        }
        
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = base.size.width
        rect.size.height = base.size.height
        rect.origin.x    = (newSize.width - base.size.width ) / 2.0
        rect.origin.y    = (newSize.height - base.size.height ) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        base.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    //将图片缩放成指定尺寸（多余部分自动删除）
    func scaled(to newSize: CGSize) -> UIImage {
        //计算比例
        let aspectWidth  = newSize.width/base.size.width
        let aspectHeight = newSize.height/base.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        //图片绘制区域
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width  = base.size.width * aspectRatio
        scaledImageRect.size.height = base.size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - base.size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - base.size.height * aspectRatio) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        base.draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
