//
//  Ext.swift
//  Socket
//
//  Created by JunMing on 2022/6/23.
//

import UIKit
import HandyJSON

// 附件消息
struct TestExt: HandyJSON {
    var tp: Int? // 笔划类型
    var ap: Float? // alpha 透明度
    var lw: Int? // 宽度
    var lc: String?
    var dt: String?
    var fl: Int?
    var dash: Int?
    var screen: String?
    
    static func getExt() -> TestExt {
        return TestExt(tp: 0, ap: 0.1, lw: 5, lc: "123,200,14", dt: "sadsdad", fl: 0, dash: 0, screen: "320,480")
    }
}

struct CreateRoomExt: HandyJSON {
    var rid: String? // 笔划类型
    var name: String? // alpha 透明度
    var owner: String? // 宽度
    var users: String?
    var timetsp: String?
    
    static func getExt() -> CreateRoomExt {
        return CreateRoomExt(rid: "100000001", name: "好的", owner: "1000000010", users: nil, timetsp: Date.jmCreateTspString())
    }
}


struct InvateExt: HandyJSON {
    var from: String? // 笔划类型
    var to: String? // alpha 透明度
    var rid: String? // 加入的群组
    var descr: String? // 宽度
    var timetsp: String?

    static func getExt() -> InvateExt {
        return InvateExt(from: "100000002", to: "100000009", descr: "xx邀请你加入群组", timetsp: Date.jmCreateTspString())
    }
}

struct AcceptExt: HandyJSON {
    var from: String? // 笔划类型
    var to: String? // alpha 透明度
    var result: Int? // alpha 透明度
    var descr: String? // 宽度
    var timetsp: String?
    
    static func getExt() -> AcceptExt {
        return AcceptExt(from: "100000009", to: "100000002", result: 1, descr: "xx接受了你的邀请", timetsp: Date.jmCreateTspString())
    }
}

struct SoekecHeader: HandyJSON {
    var Connection: String? // 笔划类型
    var Date: String? // alpha 透明度
    var Upgrade: String? // 宽度
    var Accept: String?
    var Server: String?
    
    mutating func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.Accept <-- "Sec-WebSocket-Accept"
    }
}

