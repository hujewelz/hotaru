//
//  Request.swift
//  Hotaru
//
//  Created by huluobo on 2017/12/26.
//

import Foundation
import Alamofire

final class Request<T: TargetType> {
    
    var paramaters: Parameters?
    var target: T
    let url: URLConvertible
    
    var request: Alamofire.DataRequest {
        let request = Alamofire.request(url, method: target.method, parameters: target.paramaters, encoding: target.encoding.value, headers: target.headers)
        if HotaruServer.shared.enableLog {
            Logger.logDebug(with: request.request, params: paramaters)
        }
        return request
    }
    
    
    init(target: T) {
        url = URL(string: target.baseURL.absoluteString + target.path) ?? target.baseURL
        self.paramaters = target.paramaters
        
        self.target = target
        
    }
}

extension Request {
    func cancel() {
        request.cancel()
    }
}

