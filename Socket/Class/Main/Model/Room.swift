//
//  Room.swift
//  Socket
//
//  Created by JunMing on 2022/6/22.
//

import UIKit
import HandyJSON

struct Tasks: HandyJSON {
    var allRooms = [String: Room]()
    // 总数
    var count: Int = 0
    // 活跃的
    var active: Int = 0
    // 不活跃的
    var deActice: Int = 0
}

// 群组详情
struct Room: HandyJSON {
    var rid: String = "0"
    var name: String?
    var owner: String =  "0"
    var users = [User]()
    var timetsp: Date? // 创建日期
}


