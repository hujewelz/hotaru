//
//  Hotaru.swift
//  Hotaru_Example
//
//  Created by jewelz on 2017/7/14.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire

public typealias JSON = [String: Any]

open class Provider<T: TargetType> {
    
    public typealias Handler = (Response<Any>) -> Void
    
    private var request: Alamofire.DataRequest?
    
    private var params: Hotaru.Parameters?
    
    private var validateStatasCodeRange: Range<Int>?
    
    private var validateStatasHandler: (() -> Void)?
    
    
    public init() {}
    
    public init(_ target: T) {
         let url = URL(string: target.baseURL.absoluteString + target.path) ?? target.baseURL
        let method = target.method
        let param = target.paramaters
        let encoding = target.encoding.value
        let headers = target.headers
        
        params = param
        request = Alamofire.request(url, method: method, parameters: param, encoding: encoding, headers: headers)
    }
    
    /// Create a request.
    /// - parameter target: The target of request.
    /// - returns: return the provider
    
    public func request(_ target: T) -> Self {
        if request != nil {
            return self
        }
        let url = URL(string: target.baseURL.absoluteString + target.path) ?? target.baseURL
        let method = target.method
        let param = target.paramaters
        let encoding = target.encoding.value
        let headers = target.headers
        
        params = param
        request = Alamofire.request(url, method: method, parameters: param, encoding: encoding, headers: headers)
        
        return self
    }
    
    /// Send request with a response hanlder
    /// - parameter handler: a response callback handler, you can get a `Response<Data>` object
    
    @discardableResult
    public func responseData(_ handler: @escaping (Response<Data>) -> Void) -> Self {
        
        if HotaruServer.shared.enableLog {
            Logger.logDebug(with: request!, params: params)
        }
        
        request!.responseData(completionHandler: { (response) in
            let statusCode = response.response?.statusCode ?? -1
            
            if let validateStatasCodeRange = self.validateStatasCodeRange, validateStatasCodeRange ~= statusCode {
                self.validateStatasHandler?()
                self.clearnRequest()
                return
            }
            
            HotaruServer.shared.beforeResponseClosure?(statusCode)
            
            if HotaruServer.shared.enableLog {
                Logger.logDebug(with: response, data: response.value)
            }
            
            guard let value = response.result.value else {
                let res = Response<Data>(response: response.response, result: Result.failure(response.error!), status: statusCode)
                handler(res)
                self.clearnRequest()
                return
            }
            
            let res = Response<Data>(response: response.response, result: Result.success(value), status: statusCode)
            handler(res)
            self.clearnRequest()
            
        })
        return self
    }
    
    /// Send request with a response hanlder
    /// - parameter handler: a response callback handler, you can get a `Response<[String: Any]>` object
    
    @discardableResult
    public func JSONData(_ handler: @escaping (Response<Hotaru.JSON>) -> Void) -> Self {
        
        if HotaruServer.shared.enableLog {
            Logger.logDebug(with: request!, params: params)
        }
        
        request!.responseJSON(completionHandler: { (response) in
            let statusCode = response.response?.statusCode ?? -1
            
            if let validateStatasCodeRange = self.validateStatasCodeRange, validateStatasCodeRange ~= statusCode {
                self.validateStatasHandler?()
                self.clearnRequest()
                return
            }
            
            HotaruServer.shared.beforeResponseClosure?(statusCode)
            
            if HotaruServer.shared.enableLog {
                Logger.logDebug(with: response, data: response.value)
            }
            
            guard let value = response.result.value, let json = value as? Hotaru.JSON else {
                let res = Response<Hotaru.JSON>(response: response.response, result: Result.failure(response.error!), status: statusCode)
                handler(res)
                self.clearnRequest()
                return
            }
            
            let res = Response(response: response.response, result: Result.success(json), status: statusCode)
            handler(res)
            self.clearnRequest()
    
        })
        
        return self
    }
    
    @discardableResult
    public func validate(statasCode: Range<Int>, handler: (() -> Void)? = nil) -> Self {
        validateStatasCodeRange = statasCode
        validateStatasHandler = handler
        return self
    }
    
    /// Cancel the request
    
    public func cancel() {
        request?.cancel()
    }
    
    // MARK: - Private
    
    private func clearnRequest() {
        request = nil
    }
}


