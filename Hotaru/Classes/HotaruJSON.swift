//
//  HotaruJSON.swift
//  Hotaru
//
//  Created by huluobo on 2017/11/23.
//

import Foundation

public struct _JSON {
    
    public var array: [Any] {
        return rawArray
    }
    
    public var dictionary: [String: Any] {
        return rawDictionary
    }
    
    public init(_ obj: Any) {
        switch obj {
        case let obj as Data:
            do {
                try self.init(data: obj)
            } catch {
                self.init(jsonObj: NSNull())
            }
        default:
            self.init(jsonObj: obj)
        }
    }
    
    public init(data: Data, options: JSONSerialization.ReadingOptions = []) throws {
        let obj = try JSONSerialization.jsonObject(with: data, options: options)
        self.init(jsonObj: obj)
    }
    
    public init(jsonString aString: String) {
        if let data = aString.data(using: .utf8) {
            self.init(data)
        } else {
            self.init(NSNull())
        }
    }
    
    fileprivate init(jsonObj: Any) {
        object = jsonObj
    }
    
    var object: Any {
        didSet  {
            switch object {
            case let array as [Any]:
                self.rawArray = array
            case let dict as [String: Any]:
                self.rawDictionary = dict
            case let null as NSNull:
                self.rawNull = null
            default:
                break
            }
        }
    }
    
    fileprivate var rawArray: [Any] = []
    fileprivate var rawDictionary: [String: Any] = [:]
    fileprivate var rawNull: NSNull = NSNull()
}
