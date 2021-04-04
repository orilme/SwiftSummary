//
//  Network.swift
//  UGNetworking
//
//  Created by yj on 2017/11/1.
//  Copyright © 2017年 UG. All rights reserved.
//

import Moya
import Result

public typealias FailureHandler = (NetError) -> Void
public typealias NetResponse = Moya.Response

private var ResultNetworkKey: Void?

public enum NetError: Swift.Error{
    //网络请求失败错误，如超时等404错误
    case httpError(MoyaError)
    //序列化解析错误
    case serializeError(Error)
    //服务器返回错误信息
    case serverVerifyError(message:String,code:String)
    //暂无数据
    case dataNull
}

public class HttpManager {
    
    public static let manager = HttpManager()
    
    public var httpManager:Manager!
    
    public var connectionProxyDictionary: [AnyHashable : Any]?{
        didSet{
            self.httpManager = nil
        }
    }
    
    func isDebug() -> Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    init() {
        if isDebug() == false {
            /// release环境不给设置代理
            self.connectionProxyDictionary = Dictionary()
        }
    }
    
    public func defaultHttpManager() -> Manager {
        if let httpManager = httpManager {
            return httpManager
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.httpShouldUsePipelining = true
        if let connectionProxyDictionary = self.connectionProxyDictionary{
            configuration.connectionProxyDictionary = connectionProxyDictionary
        }
        httpManager = Manager(configuration: configuration)
        httpManager.startRequestsImmediately = false
        return httpManager
    }
    
}

extension NetError: LocalizedError{
    
    public var errorDescription: String? {
        switch self {
        case .httpError(let error):
            return error.errorDescription
        case .serializeError:
            return "数据异常"
        case .serverVerifyError(message: let message, code: _):
            return message
        case .dataNull:
            return ""
        }
    }
    
}

public enum NetStubBehavior{
    //网络请求数据
    case net
    //网络或者Mock数据
    case netOrMock(seconds: TimeInterval)
    //本地缓存数据
    case localCache(seconds: TimeInterval)
    //单元测试数据
    case mockData(seconds: TimeInterval)
}

public enum NetShowErrorType{
    case none
    case hud
    case defaultEmpty
    case dialog
}

public typealias NetResult = Result<NetResponse, NetError>

public protocol NetworkConfigable{
    
    var defaultHeaders: [String: String]? { get }
    
    var netSource:NetStubBehavior { get }
    
    var defaultObjectPath:String? { get }
}

public extension  NetworkConfigable{
    var defaultHeaders: [String: String]? { return nil }
    var defaultObjectPath:String? { return nil }
}

public func request<Target: NetTargetType>(_ target:Target) -> Network<Target> {
    return Network(target)
}

//适配器
public class Network<Target: NetTargetType> {
    
    fileprivate var failure:(FailureHandler)?
    
    fileprivate var plugins = [PluginType]()
    
    public var target:Target!
    
    var response:ResponseType!
    
    var showErrorType:NetShowErrorType = .hud
    
    var emptyView: ResultView?
    
    public var timeout : TimeInterval = 45
    
    init(_ target:Target) {
        self.target = target
        plugins.append(NetworkLoggerPlugin())
    }
    
    deinit {
        print("LOG-VC deinit")
    }
    
    public func loading(onView view:UIView,
                        title:String? = nil,
                        errorType:NetShowErrorType = .hud) ->Network{
        
        objc_setAssociatedObject(view, &ResultNetworkKey, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let plugin = NetworkActivityPlugin { [weak view] (type, target) in
            guard let strongView = view else { return }
            switch type{
            case .began:
                LoadingView.load(onView: strongView)
            case .ended:
                LoadingView.hidden(from: strongView)
            }
        }
        
        self.plugins.append(plugin)
        
        return self.showError(onView: view, type: errorType)
    }
    
    
    
    public func showError(onView view:UIView,
                          type:NetShowErrorType = .hud) ->Network{
        
        for plugin in self.plugins {
            if let _ = plugin as? NetworkErrorPlugin {
                return self
            }
        }
        
        self.showErrorType = type
        
        let errorHandle: (NetError) -> Void = { [weak self,weak weakView = view] netError in
            guard let weakSelf = self else { return }
            guard let strongView = weakView else { return }
            switch netError {
            case .dataNull:
                return
            default: break
            }
            switch weakSelf.showErrorType{
            case .none:
                break
            case .hud:
                HUD.showText(onView: strongView,
                             title: netError.localizedDescription)
            case .defaultEmpty:
                 ResultView.show(onView: strongView, type: .netError(type: netError), detail: nil) { [weak strongView] in
                                                   guard let strongView = strongView else { return }
                                                   ResultView.hidden(from: strongView)
                                                   weakSelf.reload()
                                               }
            case .dialog:
                if let currentController = UIViewController.current() {
                    let alert = UIAlertController.init(title: "提示", message: netError.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction.init(title: "确定", style: .default)
                    action.setValue( UIColor.blue, forKey: "titleTextColor")
                    alert.addAction(action)
                    currentController.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        let errorPlugin = NetworkErrorPlugin { [weak self] (result, target) in
            guard let weakSelf = self else{ return }
            switch result{
            case .success(let response):
                let netResult = weakSelf.target.didReceive(target:weakSelf.target,response: response)
                switch netResult {
                case .failure(let error):
                    errorHandle(error)
                case .success: break
                }
            case .failure(let error):
                errorHandle(NetError.httpError(error))
            }
        }
        
        self.plugins.append(errorPlugin)
        
        return self
    }
    
    public func responseJSON(handler: @escaping (Any) ->Void){
        
        let response = JSONResponse()
        response.jsonHandler = handler
        self.response = response
        self.start()
    }
    
    public func response(handler: @escaping (NetResponse) ->Void){
        let response  = DataResponse()
        response.responseHandler = handler
        self.response = response
        self.start()
    }
    
    public func responseString(handler: @escaping (String) ->Void){
        
        let response = StringResponse()
        response.stringHandler = handler
        self.response = response
        self.start()
    }
    
    public func responseObject<D: Decodable>(atKeyPath keyPath: String? = "data",
                                             using decoder: JSONDecoder = JSONDecoder(),
                                             handler: @escaping (D) ->Void){
        let response = ObjectResponse<D>(atKeyPath: keyPath, using: decoder, objectHandler: handler)
        self.response = response
        self.start()
    }
    
    public func failure(handler:@escaping FailureHandler) -> Network{
        self.failure = handler
        return self
    }
    
    
    public func reload(){
        self.start()
    }
    
    
    private func start(){
        
        let provider:MoyaProvider<Target>!
        
        if let config = self as? NetworkConfigable {
            
            let endpointClosure = { (target: Target) -> Endpoint in
                var defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
                if let headers = config.defaultHeaders {
                    defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: headers)
                }
                return defaultEndpoint
            }
            
            let requestClosure = { [weak self] (endpoint:Endpoint,closure:MoyaProvider.RequestResultClosure) -> Void in
                guard let self = self else {
                    return
                }
                do {
                    var urlRequest = try endpoint.urlRequest()
                    if endpoint.url.contains("order/estate/queryOrder") {
                        urlRequest.timeoutInterval = 60
                    }else{
                        urlRequest.timeoutInterval = 45
                    }
                    //                    urlRequest.timeoutInterval = self.timeout
                    closure(.success(urlRequest))
                } catch MoyaError.requestMapping(let url) {
                    closure(.failure(MoyaError.requestMapping(url)))
                } catch MoyaError.parameterEncoding(let error) {
                    closure(.failure(MoyaError.parameterEncoding(error)))
                } catch {
                    closure(.failure(MoyaError.underlying(error, nil)))
                }
            }
            
            provider = MoyaProvider<Target>(endpointClosure: endpointClosure,
                                            requestClosure: requestClosure,
                                            stubClosure: { (target) -> StubBehavior in
                                                
                                                switch config.netSource{
                                                case .net:
                                                    return .never
                                                case .localCache(let seconds):
                                                    return .delayed(seconds: seconds)
                                                case .mockData(let seconds):
                                                    return .delayed(seconds: seconds)
                                                case .netOrMock(let seconds):
                                                    if target.mockData != nil{
                                                        return .delayed(seconds: seconds)
                                                    }else{
                                                        return .never
                                                    }
                                                }
            }, manager:HttpManager.manager.defaultHttpManager(),plugins: self.plugins)
        }else{
            provider = MoyaProvider<Target>(plugins: self.plugins)
        }
        
        provider.request(target) { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
            case let .success(response):
                let netResult = weakSelf.target.didReceive(target: weakSelf.target,response: response)
                switch netResult{
                case .success(let netResponse):
                    if let error = weakSelf.response.didReceive(response: netResponse){
                        //解析返回错误
                        weakSelf.failure?(error)
                        //重新请求的时候，不能走失败闭包回调注释掉了
                        //                        self.failure = nil
                    }
                case .failure(let error):
                    //服务器返回的错误
                    weakSelf.failure?(error)
                    //                    self.failure = nil
                }
            case let .failure(error):
                weakSelf.failure?(NetError.httpError(error))
                //                self.failure = nil
            }
        }
    }
}

extension UIViewController {
    
    class func current(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return current(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return current(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return current(base: presented)
        }
        return base
    }
}
