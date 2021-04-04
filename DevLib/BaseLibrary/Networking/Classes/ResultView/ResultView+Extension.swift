//
//  ResultView+Extension.swift
//  Alamofire
//
//  Created by sunny on 2019/12/24.
//

import Foundation

/// 结果页面类型
public enum ResultType {
    /// 无数据
    case dataEempty
    /// 网络错误
    case netError(type: NetError)
}

extension ResultView {
    
    final class func show(onView: UIView,
                     type: ResultType,
                     detail: String?,
                     handle: @escaping ()-> Void) -> ResultView {
        
        let title: String
        let image: UIImage?
        let bundlePath = (Bundle(for: ResultView.self).resourcePath ?? "") + "/Networking.bundle"
        
        switch type {
            
            case .dataEempty:
                title = "暂无信息"
                image = UIImage(contentsOfFile: bundlePath+"/network_empty")
            case .netError(type: let error):
                switch error {
                case .httpError:
                    title = "未连接到服务器"
                    image = UIImage(contentsOfFile: bundlePath+"/network_disabled")
                case .serializeError:
                    title = "数据错误"
                    image = UIImage(contentsOfFile: bundlePath+"/network_data_error")
                case .serverVerifyError(message: let message, code: let code):
                    title = "\(code):\(message)"
                    if code == "403" {
                        image = UIImage(contentsOfFile: bundlePath+"/network_unauthorized")
                    }else{
                        image = UIImage(contentsOfFile: bundlePath+"/network_data_error")
                    }
                case .dataNull:
                    title = "数据错误"
                    image = UIImage(contentsOfFile: bundlePath+"/network_data_error")
            }
        }
        let resultView = ResultView.show(onView: onView,
                                         image: image,
                                         title: title,
                                         detail: detail ?? "点击页面刷新",
                                         action: nil,
                                         handle: handle)
        return resultView
    }
}

