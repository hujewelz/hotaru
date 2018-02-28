//
//  Cancelable.swift
//  Hotaru
//
//  Created by huluobo on 2017/12/25.
//

import Foundation

public protocol Cancelable {
    var isCanceled: Bool { get set }
    
    mutating func cancel()
    
    /// Add a Cancelabel to the default Cancel bag
    func addToCancelBag()
    
    /// Add a Cancelabel to Cancel bag
    func addTo(_ cancelBag: CancelBag)
}

public extension Cancelable {
    
    public mutating func cancel() {
        isCanceled = true
    }
    
    public func addToCancelBag() {}
    
    public func addTo(_ cancelBag: CancelBag) {
        cancelBag.addToCancelBag(self)
    }
}


public protocol CancelBag: class {
    func addToCancelBag(_ cancelable: Cancelable)
}

final class Cancel {
    typealias Canceled = () -> Void
    
    var isCanceled: Bool = false
    
    fileprivate weak var obj: CancelBag?
    
    fileprivate var canceled: Canceled
    
    static func create(obj: CancelBag? = nil, _ canceled: @escaping Canceled) -> Cancel {
        return Cancel(obj: obj, canceled)
    }
    
    init(obj: CancelBag? = nil,  _ canceled: @escaping Canceled) {
        self.obj = obj
        self.canceled = canceled
    }
    
    deinit {
        canceled()
    }
    
    
}

extension Cancel: Cancelable {
    func addToCancelBag() {
        obj?.addToCancelBag(self)
    }
    
    func cancel() {
        isCanceled = true
        canceled()
    }
}
