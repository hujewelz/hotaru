//
//  Request.swift
//  Hotaru
//
//  Created by huluobo on 2017/12/26.
//

import Foundation
import Alamofire

final class Request<T: TargetType> {
    var request: Alamofire.DataRequest
    var paramaters: Parameters?
    var target: T
    
    init(target: T) {
        let url = URL(string: target.baseURL.absoluteString + target.path) ?? target.baseURL
        let method = target.method
        let param = target.paramaters
        let encoding = target.encoding.value
        let headers = target.headers
        
        self.paramaters = param
        request = Alamofire.request(url, method: method, parameters: param, encoding: encoding, headers: headers)
        self.target = target
    }
}

extension Request {
    func cancel() {
        request.cancel()
    }
}

