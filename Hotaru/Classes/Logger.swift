//
//  Logger.swift
//  Firefly_Example
//
//  Created by jewelz on 2017/7/18.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire

struct Logger {
    
    static func logDebug(with request: URLRequest?, params: Parameters?) {
        guard let httpRequest = request, let urlString = httpRequest.url?.absoluteString else {
            fatalError("url 错误.")
        }
        
        var log = "\n\n************************* Request Start **********************************\n\n"
        log.append("Http URL: \t\t\(urlString)\n")
        log.append("Http Method: \t\t\(String(describing: httpRequest.httpMethod ?? ""))\n")
        log.append("Http Params: \t\t\(String(describing: params))\n")
        
        let header = String(describing: httpRequest.allHTTPHeaderFields ?? [:])
        
        log.append("\nHttp Header: \n\t\(header)")
        if let httpBody = httpRequest.httpBody, let body = String(data: httpBody, encoding: .utf8)  {
            log.append("\nHttp Body: \n\t\(body)")
        }
        
        log.append("\n\n************************* Request End ************************************\n\n")
        print(log)
    
    }
    
    static func logDebug<T>(with response: Alamofire.DataResponse<T>, data: Any?) {
        guard let httpResponse  = response.response else {
            var log = "\n\n************************* Response Start **********************************\n\n"
            log.append("\tError: \(String(describing: response.error))")
            log.append("\n\n************************ Response End ************************************\n\n")
            print(log)
            return
        }
        var log = "\n\n************************* Response Start **********************************\n\n"
        log.append("Status : \t\t\(httpResponse.statusCode)\t\(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))\n")
        if data != nil {
            var json = JSON(data!)
            log.append("Content: \n\(String(describing: json.dictionary))")
        }
        log.append("\n\n************************ Response End ************************************\n\n")
        print(log)
       
    }
}
