//
//  ClipImageTool.swift
//  UAgent
//
//  Created by orilme on 2020/01/09.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import UIKit

extension UIImage {
    
    // 翻转图片
    func rotationImage(orientation:UIImage.Orientation) -> UIImage {
        
        var rotate : Double = 0.0;
        var rect = CGRect.init()
        var translateX : CGFloat = 0.0;
        var translateY : CGFloat = 0.0;
        var scaleX : CGFloat = 1.0;
        var scaleY : CGFloat = 1.0;
        
        let imageWidth = self.size.width
        let imageHeight = self.size.height

        
        // 根据方向旋转
        switch (orientation) {
        case .left:
            rotate = Double.pi / 2;
            rect = CGRect.init(x: 0, y: 0, width: imageHeight, height: imageWidth)
            translateX = 0
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case .right:
            rotate = 33 * Double.pi / 2;
            rect = CGRect.init(x: 0, y: 0, width: imageHeight, height: imageWidth)
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case .down:
            rotate = Double.pi
            rect = CGRect.init(x: 0, y: 0, width: imageWidth, height: imageHeight)
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRect.init(x: 0, y: 0, width: imageWidth, height: imageHeight)
            translateX = 0;
            translateY = 0;
            break;
        }
        
        
        //做CTM变换,并绘制图片
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.translateBy(x: 0, y: rect.size.height)
        context?.scaleBy(x: 1, y: -1)
        context?.rotate(by: CGFloat(rotate))
        context?.translateBy(x: translateX, y: translateY)
        context?.scaleBy(x: scaleX, y: scaleY)
        context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
        let newPic = UIGraphicsGetImageFromCurrentImageContext();
        return newPic!
    }
    
    // 修复图片旋转
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
         
        var transform = CGAffineTransform.identity
         
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
            break
             
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
            break
             
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -.pi / 2)
            break
             
        default:
            break
        }
         
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
             
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1)
            break
             
        default:
            break
        }
         
        let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: self.cgImage!.colorSpace!, bitmapInfo: self.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
         
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.height), height: CGFloat(size.width)))
            break
             
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(size.width), height: CGFloat(size.height)))
            break
        }
         
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
         
        return img
    }
    
    // 判断图片和裁剪框的关系类型
    func judgeRelationTypeWithCropSize(_ cropSize: CGSize) -> Int {
        
        var relationType = 0
        
        let crop_W = cropSize.width
        let crop_H = cropSize.height
        
        let image_W = self.size.width
        let image_H = self.size.height
        
        let imageRadio = image_W / image_H
        let cropRadio = crop_W / crop_H
        
        
        /** 裁切框宽高比 > 1
         0. 裁切框宽高比 >= 图片宽高比    imageView宽固定，高适配
         1. 裁切框宽高比 <  图片宽高比    imageView高固定，宽适配
         */
        
        /** 裁切框宽高比 = 1
         2. 裁切框宽高比 >= 图片宽高比    imageView宽固定，高适配
         3. 裁切框宽高比 <  图片宽高比    imageView高固定，宽适配
         */
        
        
        /** 裁切框宽高比 < 1
         4. 裁切框宽高比 >= 图片宽高比    imageView宽固定，高适配
         5. 裁切框宽高比 <  图片宽高比    imageView高固定，宽适配
         */
        
        if cropRadio > 1 {
            if cropRadio >= imageRadio {
                relationType = 0
            } else {
                relationType = 1
            }
        } else if cropRadio == 1 {
            if cropRadio >= imageRadio {
                relationType = 2
            } else {
                relationType = 3
            }
        } else {
            if cropRadio >= imageRadio {
                relationType = 4
            } else {
                relationType = 5
            }
        }
        
        return relationType
    }


}


