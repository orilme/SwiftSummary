//
//  NetLoggerPlugin.swift
//  UManager
//
//  Created by yj on 2017/11/20.
//  Copyright © 2017年 UG. All rights reserved.
//

import Foundation
import Moya
import Result

class NetworkLoggerPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType){

        let url = target.baseURL.appendingPathComponent(target.path)
     
        var requestLog = "LOG-Net:Request：\(url)\n"
        
        switch target.task {
        case .requestParameters(let parameters, let encoding):
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            if let jsonData = jsonData,let jsonString = String(data: jsonData, encoding: .utf8){
                requestLog = requestLog + "parameters:\(jsonString)\nencoding:\(encoding)"
            }
        default:break
        }
        print(requestLog)
    }

    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType){
        
        var responseLog = "Response:\n"
        
        switch result {
        case let .success(response):
            let stringResponse = try? response.mapString()
            responseLog = responseLog + (stringResponse ?? "")
        case let .failure(error):
            responseLog = responseLog + "Error:\(error)"
        }
        
        print("responseLog:\(responseLog)")
//        Log.log(info: responseLog,target.path)
    }
    
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError>{
        return result
    }
}

