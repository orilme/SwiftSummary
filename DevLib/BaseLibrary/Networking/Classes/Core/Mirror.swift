//
//  MirrorHelper.swift
//  UGNetworking
//
//  Created by yj on 2017/11/5.
//  Copyright © 2017年 UG. All rights reserved.
//

import Foundation

extension Mirror{
    
    /// 通过自省拼装参数
    ///
    /// - Parameter value: 网络请求任务
    /// - Parameter valueWhenNil: 当对像为空时的替换值
    /// - Returns: 拼装好的参数列表
    static func JSON(reflecting subject:Any,_ valueWhenNil:Any? = nil) -> [String:Any] {
        return parseMirror(Mirror(reflecting:subject),valueWhenNil)
    }
    /// 解析Mirror
    static private func parseMirror(_ mirror:Mirror,_ valueWhenNil:Any? = nil) -> [String:Any] {
        var result:[String:Any] = [:]
        for child in mirror.children {
            let label = child.label
            var value = child.value
            var childMirror = Mirror(reflecting: value)
            
            //如果是可选类型,把值取出来,并重新反射
            if isOptionalValueMirror(childMirror) {
                if let (v,m) = optionalValueMirror(value) {
                    value = v
                    childMirror = m
                }else{
                    if let lb = label {
                        result[lb] = valueWhenNil ?? nil
                    }
                    continue
                }
            }
            
            if isDictionaryValueMirror(childMirror) {
                if let dic = value as? [String:Any] {
                    return result.merging(dic, uniquingKeysWith: { (v1, v2) -> Any in
                        return v1
                    })
                }
            }
            
            //如果存在父类 先去解父类
            if let superMirror = childMirror.superclassMirror {
                result = result.merging(parseMirror(superMirror), uniquingKeysWith: { (v1, v2) -> Any in
                    return v1
                })
            }
            
            if isCollectValueMirror(childMirror){
                var array:[Any] = []
                for item in childMirror.children {
                    let json = self.JSON(reflecting: item.value)
                    if json.keys.isEmpty {
                        array.append(item.value)
                    }
                }
                if let lb = label {
                    result[lb] = array
                }
            }else if childMirror.children.count > 0 {
                result = result.merging(self.JSON(reflecting:value), uniquingKeysWith: {(v1,v2) in
                    return v1
                })
            }else if let lb = label {
                result[lb] = value
            }
        }
        return result
    }
    /// 是否是可选择类型的镜像
    static private func isOptionalValueMirror(_ mirror:Mirror) -> Bool {
        if let displayStyle = mirror.displayStyle,displayStyle == .optional {
            return true
        }else{
            return false
        }
    }
    /// 是否是字典类型的镜像
    static private func isDictionaryValueMirror(_ mirror:Mirror) -> Bool {
        if let displayStyle = mirror.displayStyle,displayStyle == .dictionary {
            return true
        }else{
            return false
        }
    }
    /// 是否是collect类型的镜像
    static private func isCollectValueMirror(_ mirror:Mirror) -> Bool {
        if let displayStyle = mirror.displayStyle,displayStyle == .collection {
            return true
        }else{
            return false
        }
    }
    /// 获取可选类型的值,并重新重成镜像
    static private func optionalValueMirror(_ value:Any) -> (Any,Mirror)?{
        if let child = Mirror(reflecting:value).children.first {
            return (child.value,Mirror(reflecting:child.value))
        }else{
            return nil
        }
    }
}
