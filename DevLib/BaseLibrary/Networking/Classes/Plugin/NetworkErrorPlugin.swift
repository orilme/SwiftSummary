//
//  NetLoadPlugin.swift
//  Alamofire
//
//  Created by yj on 2018/1/17.
//

import Foundation
import Moya
import Result


public final class NetworkErrorPlugin: PluginType {
    
    public typealias NetworkCompleteClosure = (_ result: Result<Moya.Response, MoyaError>,_ target: TargetType) -> Void
    
    let networkCompleteClosure: NetworkCompleteClosure
    
    public init(completeClosure: @escaping NetworkCompleteClosure) {
        
        self.networkCompleteClosure = completeClosure
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        self.networkCompleteClosure(result, target)
    }
    
}
