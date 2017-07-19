//
//  HotaruTargetType.swift
//  Hotaru_Example
//
//  Created by jewelz on 2017/7/18.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire

public typealias Method = Alamofire.HTTPMethod
public typealias Parameters = [String: Any]
public typealias Headers = Alamofire.HTTPHeaders

public protocol ParameterEncoding {
    var value: Alamofire.ParameterEncoding { get }
}

public enum URLEncoding: ParameterEncoding {
    case `default`
    case queryString
    case httpBody
    
    public var value: Alamofire.ParameterEncoding {
        switch self {
        case .default:
            return Alamofire.URLEncoding.default
        case .queryString:
            return Alamofire.URLEncoding.queryString
        case .httpBody:
            return Alamofire.URLEncoding.httpBody
        }
    }
}

public enum JSONEncoding: ParameterEncoding {
    case `default`
    case prettyPrinted
    
    public var value: Alamofire.ParameterEncoding {
        switch self {
        case .default:
            return Alamofire.JSONEncoding.default
        case .prettyPrinted:
            return Alamofire.JSONEncoding.prettyPrinted
        }
    }
}

public protocol TargetType {
    
    var baseURL: URL { get }
    
    var path: String { get }
    
    var method: Hotaru.Method { get }
    
    var paramaters: Hotaru.Parameters? { get }
    
    var encoding: Hotaru.ParameterEncoding { get }
    
    var headers: Hotaru.Headers? { get }
}

public extension TargetType {
    
    var baseURL: URL {
        guard let base = HotaruServer.shared.baseURL else {
            fatalError("baseURL could not be nill.")
        }
        return base
    }
    
    var method: Hotaru.Method {
        return .get
    }
    
    /**
     当使用 `JSONEncoding` 时， header 必须设置为 `application/json`
     
     */
    var encoding: Hotaru.ParameterEncoding {
        return URLEncoding.default
    }
    
    var paramaters: Hotaru.Parameters?  { return nil }
    
    var headers: Hotaru.Headers? { return nil }
}
