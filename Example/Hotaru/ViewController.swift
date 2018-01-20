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

    let provider = Provider<UserApi>(.users)
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hotaru"
        test()
        //testMerge()
//        testFlatMap()
    }
    
    func test() {
        Provider<UserApi>(.users).request { (response) in
            //print("response: ", response)
            print("title: ", self.title ?? "")
        }.addToCancelBag()
        
    }
    
    func testMerge() {
        provider.merge(.users, .detail("1232")) { response in
            
        }.addToCancelBag()
    }
    
    deinit {
        print("----- vc destoried")
    }
    
    func testFlatMap() {
        Provider<UserApi>(.users)
            .flatMap { response -> Provider<UserApi> in
                guard let res = response.array.first as? [String: Any] else { return Provider(UserApi.users) }
                let user = User(res)
                return Provider(.detail(user.name))
            }
            .request { response in
                print(response)
        }.addToCancelBag()
    }
//
//    func testValidate() {
//        let userProvider = Provider()
//            .request(UserApi.users)
//            .validate(statasCode: 404..<405, handler: {
//            // Page Not found
//            
//        }).JSONData { (response) in
//            switch response.result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//        }
//        
//        
//        // cancel the request
//        userProvider.cancel()
//    }
    
}

enum UserApi: TargetType {
    case users
    case detail(String)
    
    var baseURL: URL { return URL(string: "http://localhost:3000")! }
    
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


