//
//  SRConfig.swift
//  SReader
//
//  Created by JunMing on 2020/9/11.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

// 标记当前控制器类型
enum SRVCType: String {
    case JINGXUAN    = "JING_XUAN"
    case XSMI        = "XSMI"
    case TUSHU       = "TUSHU"
}

// MARK: Domain URL Enum
enum Domain: String {
    case local = "http://127.0.0.1:8000/"
    // 正式接口
    case remote = "http://119.23.41.43/"
}

enum HTTPTarget: String {
    // 登陆
    case LOGIN        = "user/login"
    // 请求token
    case TOKEN        = "user/jwt/token"
    // 注册
    case REGISTER     = "user/register"
    // 更新
    case UPDATE       = "user/update"
    // 删除
    case DELETE       = "user/delete"
    
    public var url: String {
        return Domain.local.rawValue + self.rawValue
    }
}
