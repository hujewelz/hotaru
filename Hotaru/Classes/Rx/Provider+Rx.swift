//
//  Provider+Rx.swift
//  Hotaru
//
//  Created by huluobo on 2018/2/28.
//

import RxSwift
import Alamofire

public extension Provider {
    public func data() -> Observable<Data> {
        guard let _request = requests.values.first else { return Observable.error(HotaruError(code: -100)) }
        requests.removeAll()
        return data(target: _request.target)
    }
    
    public func data(target: T) -> Observable<Data> {
        return _request(target: target, hanlder: { response, observer in
            guard let value = response.result.value else {
                observer.onError(response.error!)
                return
            }
            
            observer.onNext(value)
            observer.onCompleted()
        })
    }
}

public extension Provider {
    public func response() -> Observable<Response> {
        guard let _request = requests.values.first else { return Observable.error(HotaruError(code: -100)) }
        requests.removeAll()
        return response(target: _request.target)
    }
    
    public func response(target: T) -> Observable<Response> {
        return _request(target: target, hanlder: { (response, observer) in
            let statusCode = response.response?.statusCode ?? -1
            guard let value = response.result.value else {
                let res = Response(response: response.response, result: Result.failure(response.error!), status: statusCode)
                observer.onNext(res)
                observer.onCompleted()
                return
            }
            
            let res = Response(response: response.response, data: value, status: statusCode)
            observer.onNext(res)
            observer.onCompleted()
        })
    }
}

extension Provider {
    fileprivate func _request<R>(target: T, hanlder: @escaping (DataResponse<Data>, AnyObserver<R>) -> Void) -> Observable<R> {
        let request = Request(target: target)
        
        return Observable.create({ observer in
            request.request.responseData(completionHandler: { response in
                let statusCode = response.response?.statusCode ?? -1
                if let validateStatusCodeRange = self.validateStatusCodeRange, validateStatusCodeRange ~= statusCode {
                    self.validateStatusHandler?()
                    observer.onCompleted()
                }
                
                HotaruServer.shared.beforeResponseClosure?(statusCode)
                
                if HotaruServer.shared.enableLog {
                    Logger.logDebug(with: response, data: response.value)
                }
                
                hanlder(response, observer)
            })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
}

