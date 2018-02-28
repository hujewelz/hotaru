//
//  HotaruServer.swift
//  Hotaru_Example
//
//  Created by jewelz on 2017/7/18.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation

public final class HotaruServer {
    public enum Environment: String {
        case development
        case production
    }
    
    public static let shared = HotaruServer()
    
    public var baseURL: URL? {
        let key = String(describing: "\(HotaruServer.self).\(currentEnvironment.rawValue)")
        return self.urlMap[key]
    }
    
    
    internal var enableLog: Bool {
        return isLogEnable
    }
    
    internal var beforeResponseClosure: ((Int) -> Void)?
    
    private var isLogEnable = true
    
    private var currentEnvironment: HotaruServer.Environment = .development
    private var urlMap: [String: URL] = [:]
    
    // MARK: class Func
    
    public class func setCurrentEnvironment(_ env: HotaruServer.Environment) {
        HotaruServer.shared.currentEnvironment = env
    }
    
    public class func setBaseURL(_ baseURL: URL, for env: HotaruServer.Environment) {
        let key = String(describing: "\(HotaruServer.self).\(env.rawValue)")
        HotaruServer.shared.urlMap[key] = baseURL
    }
    
    public class func enableLog(_ able: Bool) {
        HotaruServer.shared.isLogEnable = able
    }
    
    // MARK: instance Func
    
    public func beforeResponse(_ closure: @escaping (Int) -> Void) {
        beforeResponseClosure = closure
    }
}
