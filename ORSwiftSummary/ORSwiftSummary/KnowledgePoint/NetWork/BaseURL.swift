//
//  BaseURL.swift
//  UAgent
//
//  Created by sunny on 2019/7/2.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import Foundation
import BaseLibrary

// https://ops-beta.yjyz.com/
// https://erp-beta.yjyz.com/
// 模块来源于wiki https://gitee.com/ujuz/wiki
enum ModuleType {
    /// [合同管理](https://api-beta.yjyz.com/erp.contract.api/doc.html)
    case contract
    /// [房源](https://api-beta.yjyz.com/erp.property.api/doc.html)
    case property
    /// [客源](https://api-beta.yjyz.com/erp.customer.api/doc.html)
    case customer
    /// [系统设置](https://api-beta.yjyz.com/erp.settings.api/doc.html)
    case settings
    /// [新房项目管理](https://api-beta.yjyz.com/erp.project.api/d oc.html)
    case project
    /// [楼盘字典](https://api-beta.yjyz.com/ops.community.api/doc.html)
    case community
    /// [运营平台](https://api-x.yjyz.com/ops.web.api/doc.html)
    case ops
}

enum BaseURLType: String {
    
    case prod
    case beta
    case mock
    
    //URL依赖类型和业务模块
    static func baseURL(type: BaseURLType,module:ModuleType? = nil) -> URL? {
        
        switch type {
        case .prod:
            return URL(string: "https://api.yjyz.com")!
        case .beta:
            return URL(string: "https://api-beta.yjyz.com")!
        case .mock:
            if let module = module{
                switch module {
                case .contract:
                    return URL(string:"https://mock.yjyz.com/mock/5ca4111cca98815ddec9374c/contract")!
                case .property:
                    return URL(string: "https://mock.yjyz.com/mock/5ca5bf4fca98815ddec938aa/property")!
                case .customer:
                    return URL(string: "https://mock.yjyz.com/mock/5cab2337ca98815ddec939f7")!
                case .settings:
                    return URL(string: "https://mock.yjyz.com/mock/5caae3bcca98815ddec939ac")!
                default:
                    return nil
                }
            }
            return nil
        }
    }
    
    /// 返回当前URL
    static var currentURL: URL{
        return self.baseURL(type: self.currentType)!
    }
    
    /// 当前环境类型
    static var currentType: BaseURLType{
        #if DEBUG
        return .beta
        #else
        // 打包环境需要betaURL
        return .prod
        #endif
    }
}

extension NetTargetType {
    public var baseURL: URL{
        return BaseURLType.currentURL
    }
}

