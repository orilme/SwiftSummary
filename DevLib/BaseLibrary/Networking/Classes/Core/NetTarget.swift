//
//  NetTarget.swift
//  UGNetworking
//
//  Created by yj on 2017/11/1.
//  Copyright © 2017年 yj. All rights reserved.
//

import Foundation
import Moya
import Alamofire

struct AnyEncodable: Encodable {
    
    private let encodable: Encodable
    
    public init(_ encodable: Encodable) {
        self.encodable = encodable
    }
    
    func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}

public protocol BaseURLable {
    var baseURL: URL { get }
}

public class NetTarget{
    
    var path:String
    
    var method:Moya.Method
    
    var task:NetTask
    
    public var headers:[String: String]?
    
    public init(path:String,
                method:Moya.Method,
                task:NetTask = NetTask.default,
                headers:[String: String]? = nil) {
        
        self.path = path
        self.method = method
        self.task = task
        self.headers = headers
    }
    
    public convenience init(path:String,
                            method:Moya.Method,
                            task:NetTask = NetTask.default){
        self.init(path: path, method: method, task: task, headers: nil)
    }
    
}

public protocol NetTargetType: TargetType,BaseURLable{
    
    var target: NetTarget { get }
    
    var mockData: Data? { get }
    
    //配置默认的编码
    static func defaultEncoding(method:Moya.Method) -> ParameterEncoding
    
    func didReceive(target: NetTargetType,
                    response: NetResponse) -> NetResult
    
}

public extension NetTargetType{
    
    var path: String { return target.path }
    
    var method: Moya.Method { return target.method }
    
    var sampleData: Data { return self.mockData ?? Data() }
    
    var mockData: Data? { return nil }
    
    //默认实现参数序列化任务
    var task: Task {
        //将定义的任务转发Moya任务
        let encoding = Self.defaultEncoding(method: self.method)
        switch self.target.task {
        case .uploadFile(let url):
            return .uploadFile(url)
        case .default:
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .requestEncoding(let encoding):
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .requestParametersEncoding(let parameters, let encoding):
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .requestPlain:
            return .requestPlain
        case .requestParameters(let parameters):
            return .requestParameters(parameters: parameters, encoding: encoding)
        case .requestData(let data):
            return .requestData(data)
        case .requestJSONEncodable(let encodable):
            if let parameters = encodable.json.value as? [String:Any]{
                return .requestParameters(parameters: parameters, encoding: encoding)
            }else{
                return .requestJSONEncodable(encodable)
            }
        case .uploadMultipart(let data):
            return .uploadMultipart(data)
        case .uploadCompositeMultipart(let data, let urlParameters):
            return .uploadCompositeMultipart(data,urlParameters: urlParameters)
        case .requestCompositeParameters(bodyParameters: let body, bodyEncoding:let encoding, urlParameters: let urlParameters):
            return .requestCompositeParameters(bodyParameters: body, bodyEncoding: encoding, urlParameters: urlParameters)
        }
    }
    
    var headers: [String: String]? { return target.headers }
    
    //参数默认实现
    var parameters: [String: Any]{
        let parameters =  Mirror.JSON(reflecting: self)
        return parameters
    }
    
    static func defaultEncoding(method:Moya.Method) -> ParameterEncoding{
        
        switch method {
        case .post,.put:
            return JSONEncoding.default
        default:
            return URLParameterEncoding(destination: URLParameterEncoding.Destination.methodDependent, arrayEncoding: URLParameterEncoding.ArrayEncoding.noBrackets,
                                        boolEncoding: URLParameterEncoding.BoolEncoding.numeric)
        }
    }
    
}
