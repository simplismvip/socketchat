//
//  JMResult.swift
//  Socket
//
//  Created by JunMing on 2022/6/28.
//

import HandyJSON

struct JMResult: HandyJSON, ModelProtocol {
    var descr: String?
    var status: Int?
}

struct Token: HandyJSON, ModelProtocol {
    var access_token: String?
    var token_type: String?
}
