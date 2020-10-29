//
//  TakePhotoTool.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/2/27.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     * 将图片缩放到指定的CGSize大小
     * UIImage image 原始的图片
     * CGSize size 要缩放到的大小
     */
    func imageScaleToSize(image:UIImage, size:CGSize) -> UIImage? {
        
        // 得到图片上下文，指定绘制范围
        UIGraphicsBeginImageContext(size)
        
        // 将图片按照指定大小绘制
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 从当前图片上下文中导出图片
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 当前图片上下文出栈
        UIGraphicsEndImageContext()
        
        // 返回新的改变大小后的图片
        return scaledImage
    }

    /**
     * 从图片中按指定的位置大小截取图片的一部分
     * UIImage image 原始的图片
     * CGRect rect 要截取的区域
     */
    func imageFromImageInRect(image:UIImage, rect:CGRect) -> UIImage? {

        //将UIImage转换成CGImageRef
        let sourceImageRef = image.cgImage
 
        //按照给定的矩形区域进行剪裁
        let newImageRef = sourceImageRef?.cropping(to: rect)
        //将CGImageRef转换成UIImage
        let newImage = UIImage.init(cgImage: newImageRef!)
        //返回剪裁后的图片
        return newImage

    }

}
