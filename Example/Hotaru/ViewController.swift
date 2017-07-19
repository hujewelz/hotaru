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
    }
    
    func test() {
        
        Provider<UserApi>(.users).JSONData { (response) in
            let res = response.map{ User($0["data"] as! [String : Any]) }
            guard let user = res.value else {
                return
            }
            
            print(user)
        }
        
    }
    
}

enum UserApi: TargetType {
    case users
    
    var path: String { return "/users" }
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


