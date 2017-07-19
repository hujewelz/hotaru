//
//  Hotaru.swift
//  Hotaru_Example
//
//  Created by jewelz on 2017/7/14.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire


open class Provider<T: TargetType> {
    
    public typealias Handler = (Response<Any>) -> Void
    
    private var request: Alamofire.DataRequest?
    
    private var params: Hotaru.Parameters?
    
    private var validateStatasCodeRange: Range<Int>?
    
    
    public init() {}
    
    public init(_ target: T) {
        let url = target.baseURL.appendingPathComponent(target.path)
        let method = target.method
        let param = target.paramaters
        let encoding = target.encoding.value
        let headers = target.headers
        
        params = param
        request = Alamofire.request(url, method: method, parameters: param, encoding: encoding, headers: headers)
    }
    
    public func request(_ target: T) -> Self {
        if request != nil {
            return self
        }
        let url = target.baseURL.appendingPathComponent(target.path)
        let method = target.method
        let param = target.paramaters
        let encoding = target.encoding.value
        let headers = target.headers
        
        params = param
        request = Alamofire.request(url, method: method, parameters: param, encoding: encoding, headers: headers)
        
        return self
    }
    
    @discardableResult
    public func responseData(_ handler: @escaping (Response<Data>) -> Void) -> Self {
        
        if HotaruServer.shared.enableLog {
            Logger.logDebug(with: request!, params: params)
        }
        
        request!.responseData(completionHandler: { (response) in
            let statusCode = response.response?.statusCode ?? -1
            
            if let validateStatasCodeRange = self.validateStatasCodeRange, validateStatasCodeRange ~= statusCode {
                return
            }
            
            HotaruServer.shared.beforeResponseClosure?(statusCode)
            
            if HotaruServer.shared.enableLog {
                Logger.logDebug(with: response, data: response.value)
            }
            
            guard let value = response.result.value else {
                
                let res = Response<Data>(result: Result.failure(response.error!), status: statusCode)
                handler(res)
                
                return
            }
            
            let res = Response<Data>(result: Result.success(value), status: statusCode)
            handler(res)
            
        })
        return self
    }
    
    @discardableResult
    public func JSONData(_ handler: @escaping (Response<[String: Any]>) -> Void) -> Self {
        
        if HotaruServer.shared.enableLog {
            Logger.logDebug(with: request!, params: params)
        }
        
        request!.responseJSON(completionHandler: { (response) in
            let statusCode = response.response?.statusCode ?? -1
            
            
            if let validateStatasCodeRange = self.validateStatasCodeRange, validateStatasCodeRange ~= statusCode {
                return
            }
            
            HotaruServer.shared.beforeResponseClosure?(statusCode)
            
            if HotaruServer.shared.enableLog {
                Logger.logDebug(with: response, data: response.value)
            }
            
            guard let value = response.result.value, let json = value as? [String: Any] else {
                
                let res = Response<[String: Any]>(result: Result.failure(response.error!), status: statusCode)
                
                handler(res)
                
                return
            }
            
            let res = Response<[String: Any]>(result: Result.success(json), status: statusCode)
            
            handler(res)
    
        })
        
        return self
    }
    
    @discardableResult
    public func validate(statasCode: Range<Int>) -> Self {
        validateStatasCodeRange = statasCode
        return self
    }
    
    public func cancel() {
        request?.cancel()
    }
}

public struct Response<Value> {
    
    public typealias Status = Int
    
    public let result: Result<Value>
    
    public let status: Status
    
    public var value: Value? {
        return result.value
    }
    
    public var error: Error? {
        return result.error
    }
    
    
    init(result: Result<Value>, status: Status) {
        self.result = result
        self.status = status
    }
    
}

extension Response {
    
    public func map<T>(_ transform: (Value) -> T) -> Hotaru.Response<T> {
        
        guard let value = value else {
            return Response<T>(result: .failure(error!), status: status)
        }
        
        return Response<T>(result: .success(transform(value)), status: status)
        
    }
}

public enum Result<Value> {
    case success(Value)
    case failure(Error)
    
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
