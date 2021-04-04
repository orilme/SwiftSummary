//
//  NetConfig.swift
//  UHouse_V3 88
//
//  Created by yj on 2018/2/23.
//  Copyright © 2018年 UG. All rights reserved.
//

import Foundation
import Moya
import BaseLibrary

///客源-我的客户列表 批量设置接口,code != 200时需要解析,按需可设置true，用完置为false
public var isCustomerBatchSetRequest = false

struct ResponseData: Codable{
    
    var msg: String?
    
    var code: String?
    
    var succeed: Bool?
    
    var requestId: String?
}

struct ResponseModel<T>: Codable where T: Codable {
    var code: String?
    var msg: String?
    var succeed: Bool?
    var data:T?
}


struct ServerResultInterceptor {
    
    func didReceive(target: NetTargetType,
                    response: NetResponse) -> NetResult {
        
        let unknownCode = "\(response.statusCode)"
        
        //请求头因为经常改变大小写兼容
        func authorization(header:[AnyHashable : Any]?) -> String?{
            if let authorization = header?["Authorization"] as? String{
                return authorization
            }
            if let authorization = header?["authorization"] as? String{
                return authorization
            }
            return nil
        }
        
        do {
            let responseObj = try JSONDecoder().decode(ResponseData.self, from:response.data)
            
            //无权限访问
            if let code = responseObj.code,code.starts(with: "403"){
                let netError = NetError.serverVerifyError(message: "不好意思，您暂无查看权限！", code: responseObj.code ?? unknownCode)
                return NetResult.failure(netError)
            }
            
            let code = responseObj.code ?? ""
            if code == "200"  {
                return NetResult.success(response)
            }else {
                let errorMsg = "\(responseObj.msg ?? String(response.statusCode))"
                if responseObj.code == "4000011007" {
                    return NetResult.failure(NetError.dataNull)
                }
                //处理客源批量设置接口code
                if (responseObj.code == "400001" || responseObj.code == "400002") && isCustomerBatchSetRequest {
                    return NetResult.success(response)
                }
                let netError = NetError.serverVerifyError(message: errorMsg, code: responseObj.code ?? unknownCode)
                return NetResult.failure(netError)
            }
        } catch let error{
            let netError = NetError.serializeError(error)
            print("服务器异常\(error)")
            return NetResult.failure(netError)
        }
        
    }
    
}

extension NetTargetType{
    public func didReceive(target: NetTargetType, response: NetResponse) -> NetResult {
        let result = ServerResultInterceptor()
        return result.didReceive(target: target, response: response)
    }
}

extension Network: NetworkConfigable{
    
    public var defaultObjectPath: String?{
        return "data"
    }
    
    public var defaultHeaders: [String : String]? {
        var headers = self.defaultHTTPHeaders
        headers["Authorization"] = "eyJhbGciOiJSUzI1NiJ9.eyJkdCI6Im1vYmlsZSIsInR0IjoiMSIsInN1YiI6IjYzMTA1ODYxNDcyODc1MzE1MiIsIlVOb25jZSI6IjIwNjI3ZWJiLTJjZGEtNDVkNC04YTNhLTljOWFhY2ZlZDNjNSIsInJvbGUiOiI1ODUwMTQ2NDI3MTc5ODI3MjAiLCJpc3MiOiJ5anl6LmNvbSIsImV4cCI6MTYxODAyMTUwMSwiaWF0IjoxNjE1NDI5NTAxLCJqdGkiOiI1ODExNTUxZi02MzIyLTQxY2ItYTEyNC0xNmZlYTIxZTIzMjcifQ.cQ0Eal_AQiGt_cz9AoZPJK3fBc6WdDhGMETJkMXa4EebObk1ECTh8PrhKFJ4HDOxlQ61T4Ii-oyEd5_zGtPq5Nu1kmh7fGZurrT-T0FqfCoBWWBChF1WVv25_W56GWCms2klfulF9vDAieRoPXL_I_LIy1wX4J1Dz8JHi5Cz5PM"

        headers["X-Organ-Id"] = "552692373611008128"
        headers["X-City-Code"] = "450100"
        headers["x-device-name"] = (UIDevice.current.modelName == "Simulator") ? "iPhone Simulator" : UIDevice.current.modelName
 
        return headers
    }
    
    public var defaultHTTPHeaders: [String : String] {
        
        let acceptEncoding: String = "gzip;q=1.0, compress;q=0.5"
        
        
        
        let userAgent: String = {
            
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
            
            let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
                //let quality = 1.0 - (Double(index) * 0.1)
                return "\(languageCode)"
                }.joined(separator: ", ")
            
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                return versionString
            }()
            
            let osName: String = {
                #if os(iOS)
                return "iOS"
                #elseif os(watchOS)
                return "watchOS"
                #elseif os(tvOS)
                return "tvOS"
                #elseif os(macOS)
                return "OS X"
                #elseif os(Linux)
                return "Linux"
                #else
                return "Unknown"
                #endif
            }()
            
            var modelName = UIDevice.current.modelName
            if modelName == "Simulator"{
                modelName = "iPhone"
            }
            return "YJYZERP/\(appVersion) (\(modelName); \(osName) \(osNameVersion); \(acceptLanguage))"
        }()
        
        return ["X-Requested-With":"XMLHttpRequest",
                "acceptEncoding":acceptEncoding,
                "User-Agent": userAgent]
    }
    
    public var netSource: NetStubBehavior {
        #if DEBUG
        return .net
        #else
        return .net
        #endif
    }
    
}

class AppDevice {
    
    static func getdevice()->String {
              
         let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
                  
          let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
              //let quality = 1.0 - (Double(index) * 0.1)
              return "\(languageCode)"
              }.joined(separator: ", ")
          
          let osNameVersion: String = {
              let version = ProcessInfo.processInfo.operatingSystemVersion
              let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
              return versionString
          }()
          
          let osName: String = {
              #if os(iOS)
              return "iOS"
              #elseif os(watchOS)
              return "watchOS"
              #elseif os(tvOS)
              return "tvOS"
              #elseif os(macOS)
              return "OS X"
              #elseif os(Linux)
              return "Linux"
              #else
              return "Unknown"
              #endif
          }()
          
          var modelName = UIDevice.current.modelName
          if modelName == "Simulator"{
              modelName = "iPhone"
          }
          return "YJYZERP\\/\(appVersion)(\(modelName);\(osName)\(osNameVersion);\(acceptLanguage))"
           
    }
}

