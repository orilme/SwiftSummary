//
//  ResultView+Extension.swift
//  UAgent
//
//  Created by sunny on 2019/7/15.
//  Copyright © 2019 com.yjyz.www. All rights reserved.
//

import Foundation
import BaseLibrary

/// 结果页面类型
enum ResultType {
    /// 未连接到服务器
    case netDisabled
    /// 无数据
    case dataEempty
    /// 数据错误
    case dataError(message: String)
    /// 未授权
    case unauthorized
}

extension ResultView {
    
    @discardableResult
    class func show(onView view: UIView,
                    type: ResultType,
                    detail: String? = nil,
                    handle:@escaping ()-> Void) -> ResultView {
        switch type {
        case .netDisabled:
           return self.show(onView: view,
                            image: UIImage(named: "network_disabled"),
                      title: "未连接到服务器",
                      detail: detail ?? "点击页面刷新",
                      action: nil,
                      handle:handle)
        case .dataEempty:
           return self.show(onView: view,
                      image: UIImage(named: "network_empty"),
                      title: "暂无信息",
                      detail: detail ?? "点击页面刷新",
                      action: nil,
                      handle:handle)
        case .dataError(let message):
           return self.show(onView: view,
                      image: UIImage(named: "network_data_error"),
                      title: message,
                      detail: detail ?? "点击页面刷新",
                      action: nil,
                      handle:handle)
        case .unauthorized:
           return self.show(onView: view,
                      image: UIImage(named: "network_unauthorized"),
                      title: "不好意思，您暂无查看权限！",
                      detail: detail ?? "点击页面刷新",
                      action: nil,
                      handle:handle)
        }
    }
    
    @discardableResult
    class func show(onView view: UIView,
                    networkError: NetError,
                    detail: String? = nil,
                    handle:@escaping ()-> Void) -> ResultView {
        
        switch networkError {
        case .httpError:
           return self.show(onView: view, type: .netDisabled, detail: detail, handle:handle)
        case .serializeError:
           return self.show(onView: view, type: .dataError(message: networkError.localizedDescription), detail: detail, handle:handle)
        case .serverVerifyError(let error):
            if error.code.starts(with: "403"){
               return self.show(onView: view, type: .unauthorized, detail: detail, handle:handle)
            }else{
               return self.show(onView: view, type: .dataError(message: networkError.localizedDescription), detail: detail, handle:handle)
            }
        case .dataNull:
            return self.show(onView: view, type: .dataEempty, detail: detail, handle:handle)
        }
    }
}
