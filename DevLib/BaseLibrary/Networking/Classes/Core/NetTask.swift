//
//  NetTask.swift
//  UGNetworking
//
//  Created by yj on 2017/11/3.
//  Copyright © 2017年 UG. All rights reserved.
//

import Foundation
import Moya

public typealias ParameterEncoding = Moya.ParameterEncoding
public typealias JSONEncoding = Moya.JSONEncoding
public typealias URLEncoding = Moya.URLEncoding
public typealias PropertyListEncoding = Moya.PropertyListEncoding
public typealias MultipartFormData = Moya.MultipartFormData

public enum NetTask {
    
    /// 参数是由 Mirror 反射 配置的默认编码
    case `default`
    /// 上传文件
    case uploadFile(URL)
    /// A "multipart/form-data" upload task.
    case uploadMultipart([MultipartFormData])
    /// A "multipart/form-data" upload task  combined with url parameters.
    case uploadCompositeMultipart([MultipartFormData], urlParameters: [String: Any])
    /// 请求体set data
    case requestData(Data)
    /// 没有参数
    case requestPlain
    /// 自定义编码，参数是反射参数
    case requestEncoding(encoding: ParameterEncoding)
    /// JSON请求编码模型
    case requestJSONEncodable(Encodable)
    /// 自定义参数，编码是默认配置编码
    case requestParameters(parameters: [String: Any])
    /// 自定义参数、编码
    case requestParametersEncoding(parameters: [String: Any],encoding: ParameterEncoding)
    // bodyParameters、urlParameters
    case requestCompositeParameters(bodyParameters: [String: Any], bodyEncoding: ParameterEncoding, urlParameters: [String: Any])
}

