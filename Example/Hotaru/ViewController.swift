//
//  ViewController.swift
//  Hotaru
//
//  Created by huluobobo on 07/19/2017.
//  Copyright (c) 2017 huluobobo. All rights reserved.
//

import UIKit
import Hotaru

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        test()
        testJSON()
    }
    
    func testJSON() {
        let dict: [String: Any] = ["name": "jewelz", "age": 23]
        let json = _JSON(dict)
        print("json: ", json.dictionary)
    }
    
    func test() {
//        Provider<UserApi>(.detail("123456")).JSONData { (response) in
//            let res = response.map{ User($0["data"] as! JSON) }
//            guard let user = res.value else {
//                return
//            }
//            print(user)
//        }
        
        Provider<UserApi>(.detail("123456")).flatMap { response -> Provider<UserApi> in
            return Provider(UserApi.users)
        }.JSONData { response in
            print(response)
        }
    }
    
    func testValidate() {
        let userProvider = Provider().request(UserApi.users).validate(statasCode: 404..<405, handler: {
            // Page Not found
            
        }).JSONData { (response) in
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        
        
        // cancel the request
        userProvider.cancel()
    }
    
}

enum UserApi: TargetType {
    case users
    case detail(String)
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .detail(let id):
            return "/detail/\(id)"
        }
    }
}

struct User {
    var name: String = ""
    
    init(_ json: [String: Any]) {
        guard let name = json["name"] as? String else {
            return
        }
        self.name = name
    }
}


