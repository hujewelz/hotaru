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
    
    public typealias Handler = (Response) -> Void
    
    public init() {}
    
    public init(_ target: T) {
        let uuid = UUID()
        requests[uuid] = Request(target: target)
    }
    
    internal var requests: [UUID: Request<T>] = [:]
    
    internal var validateStatusCodeRange: Range<Int>?
    
    internal var validateStatusHandler: (() -> Void)?
    
    // MARK: - Private
    
    fileprivate var _handler: Handler?

    fileprivate var needSend = true
    
    fileprivate var objects: [Any] = []
    
    fileprivate func call(with response: Response) {
        _handler?(response)
    }
    
    /// Send the Request
    fileprivate func send(request: Request<T>, _ handler: @escaping (Response) -> Void) {
        
        let uuid = UUID()
        requests[uuid] = request
        
        request.request.responseData(completionHandler: { (response) in
            let statusCode = response.response?.statusCode ?? -1
            
            if let validateStatusCodeRange = self.validateStatusCodeRange, validateStatusCodeRange ~= statusCode {
                self.validateStatusHandler?()
                self.clearnHandler()
                return
            }
            
            HotaruServer.shared.beforeResponseClosure?(statusCode)
            
            if HotaruServer.shared.enableLog {
                Logger.logDebug(with: response, data: response.value)
            }
            
            guard let value = response.result.value else {
                let res = Response(response: response.response, result: Result.failure(response.error!), status: statusCode)
                handler(res)
                self.clearnHandler()
                return
            }
            
            let res = Response(response: response.response, data: value, status: statusCode)
            handler(res)
            self.clearnHandler()
            
        })
    }
    
    /// Clearn the Request and Handler
    fileprivate func clearnHandler() {
        _handler = nil
    }
    
    /// Cancel the request
    fileprivate func cancel() {
        requests.values.forEach {
            $0.cancel()
        }
        _handler = nil
        print("cancel is calling")
    }
    
    /// Keep the objc alive
    fileprivate func keepAlive(_ obj: Any) {
        objects.append(obj)
    }
}

public extension Provider {
    
    /// Send request with a request Target
    /// - parameter target: A request Target
    /// - parameter handler: A response callback handler, you can get a `Response` object
    /// - returns: The cancelable, which cancel the request
    
    @discardableResult
    public func request(_ target: T, handler: @escaping Handler) -> Cancelable {
        _handler = handler
        if needSend {
            send(request: Request(target: target), handler)
        }
        
        return Cancel(obj: self, { [weak self] in
            self?.cancel()
        })
    }
    
    /// Send request with a response hanlder
    /// - parameter handler: A response callback handler, you can get a `Response<[String: Any]>` object
    /// - returns: The cancelable, which cancel the request
    
    @discardableResult
    public func request(_ handler: @escaping Handler) -> Cancelable {
        guard let _request = requests.values.first else { fatalError("Target can not be empty") }
        requests.removeAll()
        return request(_request.target, handler: handler)
    }
    
    @discardableResult
    public func validate(statusCode: Range<Int>, handler: (() -> Void)? = nil) -> Self {
        validateStatusCodeRange = statusCode
        validateStatusHandler = handler
        return self
    }
    
    
}

public extension Provider {
    public func flatMap<B>(_ transform: @escaping (Response) -> Provider<B> ) -> Provider<B> {
        let provider = Provider<B>()
        provider.needSend = false
        request { response in
            let p = transform(response)
            p.request({ response in
                provider.call(with: response)
            }).addToCancelBag()
            }.addToCancelBag()
        return provider
    }
    
    public func merge(_ targets: T..., handler: @escaping ([Response]) -> Void) -> Cancelable {
        var _handler: (([Response]) -> Void)? = handler
        var targets = targets
        var responses: [Response] = Array(repeating: Response.default(), count: targets.count)
        let group = DispatchGroup()
        if let first = requests.values.first {
            responses = Array(repeating: Response.default(), count: targets.count+1)
            targets.insert(first.target, at: 0)
        }
        
        for (index, target) in targets.enumerated() {
            group.enter()
            let request = Request(target: target)
            requests[UUID()] = request
            
            request.request.responseData(completionHandler: { response in
                let statusCode = response.response?.statusCode ?? -1
                
                if HotaruServer.shared.enableLog {
                    Logger.logDebug(with: response, data: response.value)
                }
                
                guard let value = response.result.value else {
                    let res = Response(response: response.response, result: Result.failure(response.error!), status: statusCode)
                    responses[index] = res
                    group.leave()
                    return
                }
                
                let res = Response(response: response.response, data: value, status: statusCode)
                responses[index] = res
                group.leave()
            })
        }
       
        group.notify(queue: DispatchQueue.main) {
            handler(responses)
            _handler = nil
        }
        
        return Cancel(obj: self, { [weak self] in
            self?.cancel()
        })
    }
}

extension Provider: CancelBag {
    public func addToCancelBag(_ cancelable: Cancelable) {
        keepAlive(cancelable)
    }
}



