//
//  Response.swift
//  Alamofire
//
//  Created by jewelz on 2017/10/26.
//

import Foundation

public struct Response {
    
    public typealias Status = Int
    
    public let response: HTTPURLResponse?
    
    public let result: Result
    
    public let status: Status
    
    public var data: Data? {
        if error != nil { return nil }
        return _data
    }
    
    public var value: JSON? {
        return result.value
    }
    
    public var error: Error? {
        return result.error
    }
    
    public var dictionary: [String: Any] {
        return result.dictionaryValue
    }
    
    public var array: [Any] {
        return result.arrayValue
    }
    
    init(response: HTTPURLResponse?, result: Result, status: Status) {
        self.response = response
        self.result = result
        self.status = status
    }
    
    init(response: HTTPURLResponse?, data: Data, status: Status) {
        self.response = response
        self.result = Result(data: data)
        self.status = status
        _data = data
    }
    
    static func `default`() -> Response {
        return Response(response: nil, result: .failure(NSError()), status: 0)
    }
    
    private var _data: Data?
    
}

extension Response {
//    public func map<T>(_ transform: (JSON) -> T) -> Hotaru.Response<T> {
//
//        guard let value = value else {
//            return Response<T>(response:response, result: .failure(error!), status: status)
//        }
//
//        return Response<T>(response: response, result: .success(transform(value)), status: status)
//    }

}

public enum Result {
    case success(JSON)
    case failure(Error)
    
    init(data: Data) {
        if let json = try? JSON(data: data) {
            self = .success(json)
        } else {
            self = .failure(HotaruError(code: -301))
        }
    }
    
    public var value: JSON? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var arrayValue: [Any] {
        guard var json = value else {
            return []
        }
        return json.array
    }
    
    public var dictionaryValue: [String: Any] {
        guard var json = value else {
            return [:]
        }
        return json.dictionary
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

public protocol KeyPathible {
    var key: String { get }
}
