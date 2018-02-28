//
//  HotaruError.swift
//  Hotaru
//
//  Created by huluobo on 2018/1/18.
//

import Foundation

fileprivate let ErrorMap: [Int: String] = [ -200: "请求失败", -301: "数据解析错误", -100: "No request"]

class HotaruError: NSError {
    init(code: Int) {
        let info = ErrorMap[code] ?? "未知错误"
        super.init(domain: "com.jewelz.hotarn.error", code: code, userInfo: ["description":  info])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
