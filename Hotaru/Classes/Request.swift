//
//  Request.swift
//  Hotaru
//
//  Created by huluobo on 2017/12/26.
//

import Foundation
import Alamofire

final class Request<T: TargetType> {
    
    let paramaters: Parameters?
    let target: T
    let url: URLConvertible
    
    lazy var request: Alamofire.DataRequest = { [unowned self] in
        let request = Alamofire.request(self.url, method: self.target.method, parameters: self.target.paramaters, encoding: self.target.encoding.value, headers: self.target.headers)
        if HotaruServer.shared.enableLog {
            Logger.logDebug(with: request.request, params: self.target.paramaters)
        }
        return request
    }()
    
    
    init(target: T) {
        let s = NSString(string: target.path)
        let urlStr = String(format: "%@%@", target.baseURL.absoluteString, s).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? target.baseURL.absoluteString
        let url = URL(string: urlStr)
        assert(url != nil, "URL 错误")
        self.url = url!
        self.paramaters = target.paramaters
        
        self.target = target
        
    }
}

extension Request {
    func cancel() {
        request.cancel()
    }
}

