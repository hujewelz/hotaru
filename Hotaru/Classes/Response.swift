//
//  Response.swift
//  Alamofire
//
//  Created by jewelz on 2017/10/26.
//

import Foundation

public struct Response<Value> {
    
    public typealias Status = Int
    
    public let response: HTTPURLResponse?
    
    public let result: Result<Value>
    
    public let status: Status
    
    public var value: Value? {
        return result.value
    }
    
    public var error: Error? {
        return result.error
    }
    
    init(response: HTTPURLResponse?, result: Result<Value>, status: Status) {
        self.response = response
        self.result = result
        self.status = status
    }
    
}

extension Response {
    public func map<T>(_ transform: (Value) -> T) -> Hotaru.Response<T> {
        
        guard let value = value else {
            return Response<T>(response:response, result: .failure(error!), status: status)
        }
        
        return Response<T>(response: response, result: .success(transform(value)), status: status)
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
