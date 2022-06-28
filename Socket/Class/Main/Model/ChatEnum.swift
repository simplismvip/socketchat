//
//  ChatEnum.swift
//  Socket
//
//  Created by JunMing on 2022/6/20.
//

import UIKit
import HandyJSON

enum State: Int, HandyJSONEnum {
    case online
    case offline
    case besy
}

enum SocketType: Int, HandyJSONEnum {
    case sString
    case sData
    case sPing
    case sPong
}

enum MsgType: Int, HandyJSONEnum {
    case text = 0
    case image = 1
    case audio = 2
    case video = 3
    case file = 4
    case location = 5
    case custom = 6
    case create = 7 // 创建群组
    case invite = 8 // 邀请好友
    case accept = 9 // 接受好友
    case broadcast = 10 // 广播消息
    case destory = 11 // 解散群
    case banuser = 12 // 禁言用户
    
    var name: String {
        switch self {
        case .text:
            return "文本"
        case .image:
            return "图片"
        case .audio:
            return "语音"
        case .video:
            return "视频"
        case .file:
            return "文件"
        case .location:
            return "位置"
        case .custom:
            return "自定义"
        case .create:
            return "创建群组"
        case .invite:
            return "邀请"
        case .accept:
            return "接受邀请"
        case .broadcast:
            return "广播"
        case .destory:
            return "解散群"
        case .banuser:
            return "禁言"
        }
    }
}

enum MsgState: Int, HandyJSONEnum {
    case sending
    case sendDone
    case recving
    case recvDone
    case faild
}
