//
//  Encodable+Extension.swift
//  UAgent
//
//  Created by sunny on 2019/5/9.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import Foundation

public struct JSONObject {
    
    public var data:Data?
    
    public var dictionaryValue:[String : Any] {
        
        if let json = self.value as? [String:Any]{
            return json
        }
        return [String:Any]()
    }
    
    public var arrayValue:[Any] {
        
        if let json = self.value as? [Any]{
            return json
        }
        return [Any]()
    }
    
    public var value:Any? {
        if let jsonData = data,let json = try? JSONSerialization.jsonObject(with: jsonData, options:.allowFragments){
            return json
        }
        return nil
    }
    
}

extension Encodable{
    
    public var json:JSONObject {
        
        var jsonObject = JSONObject()
        let encodable = AnyEncodable(self)
        if let jsonData = try? JSONEncoder().encode(encodable){
            jsonObject.data = jsonData
            return jsonObject
        }
        return jsonObject
    }
    
    public func objctJson() -> String {
        let decoder = JSONEncoder()
        if let jsonData =  try? decoder.encode(self) {
            if let str = String.init(data: jsonData, encoding: .utf8) {
                return str
            }
        }
        return ""
    }
}
