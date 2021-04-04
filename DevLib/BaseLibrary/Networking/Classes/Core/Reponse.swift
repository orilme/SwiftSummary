//
//  NetResponseMapPlugin.swift
//  UGNetworking
//
//  Created by yj on 2017/11/5.
//  Copyright © 2017年 UG. All rights reserved.
//

import Foundation
import Moya


public protocol ResponseType  {
    var  failureHandle:((NetError) -> Void)? { get set }
    func didReceive(response:Moya.Response) -> NetError?
}

public final class JSONResponse: ResponseType{
    
    var jsonHandler:((Any)->Void)?
    
    var json:Any?
    
    public var failureHandle: ((NetError) -> Void)?
    
    public func didReceive(response: Response) -> NetError? {
        
        do {
            let json = try response.mapJSON()
            
            self.jsonHandler?(json)
            self.jsonHandler = nil
        }
        catch{
            print("jsonError:\(error)")
            let netError = NetError.serializeError(error)
            self.failureHandle?(netError)
            return netError
        }
        return nil
    }
    
}

public final class DataResponse: ResponseType{
    
    public var failureHandle: ((NetError) -> Void)?
    
    var responseHandler:((Response)->Void)?
    
    public func didReceive(response: Response) -> NetError? {
        self.responseHandler?(response)
        return nil
    }
    
}


public final class StringResponse: ResponseType{
    
    public var failureHandle: ((NetError) -> Void)?
    
    var stringHandler:((String)->Void)?
    
    public func didReceive(response:Moya.Response) -> NetError? {
        
        do {
            let string = try response.mapString()
            self.stringHandler?(string)
//            self.stringHandler = nil
        }
        catch{
            print("stringError:\(error)")
            let netError =  NetError.serializeError(error)
            self.failureHandle?(netError)
            return netError
        }
        return nil
    }
    
}

public final class ObjectResponse<D: Decodable>: ResponseType{
    
    public var failureHandle: ((NetError) -> Void)?
    
    var objectHandler:((D)->Void)?
    
    var keyPath:String?
    
    var decoder = JSONDecoder()
    
    public init(atKeyPath keyPath: String? = nil,
                using decoder: JSONDecoder = JSONDecoder(),
                objectHandler:((D)->Void)?){
        
        self.keyPath = keyPath
        self.decoder = decoder
        self.objectHandler = objectHandler
    }
    
    public func didReceive(response: Response) -> NetError? {
        
        do {
            if let objectHandler = self.objectHandler {
                let obj = try response.map(D.self, atKeyPath: self.keyPath)
                objectHandler(obj)
//                self.objectHandler = nil
            }
        }
        catch{
            print("ObjectMapError:\(error)")
            let netError = NetError.serializeError(error)
            self.failureHandle?(netError)
            return netError
        }
        
        return nil
    }
}

