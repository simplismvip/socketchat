//
//  Message.swift
//  Socket
//
//  Created by JunMing on 2022/6/20.
//

import UIKit
import HandyJSON

// 附件消息
struct Attachment: HandyJSON {
    var url: String?
    var thumburl: String?
    var time: Int?
    var size: Int?
    var title: String?
    var latitude: String?
    var longitude: String?
}

struct Message: HandyJSON {
    // 如果消息类型为invite，accept from表示发起邀请，to表示被邀请
    var msgfrom: String = "0"
    var msgto: String =  "0"
    var content: String
    var msgid: String?
    // 0:文本消息，1:语音消息，2:图片消息
    var msgtype: MsgType = .text
    // 0:群组消息，1:点对点消息
    var session: Int = 0
    // 0:群组id，1:点对点消息
    var sessionid: String?
    //  消息时间
    var timetsp: String?
    var msgobject: Attachment?
    var sendername: String?
    var ext: [String: Any]?
    
    init(content: String?, to: User, type: MsgType, sessionType: Int, sessionid: String?, atta: Attachment?, ext: [String: Any]?) {
        self.content = content ?? ""
        self.msgfrom = LoginManager.share.user?.uid ?? "0"
        self.sendername = LoginManager.share.user?.name ?? "0"
        self.msgto = to.uid
        self.msgid = UUID().msgid
        self.msgtype = type
        self.session = sessionType
        self.sessionid = sessionid ?? to.uid
        self.timetsp = Date.jmCreateTspString()
        self.msgobject = atta
        self.ext = ext
    }
    
    init() { self.content = "" }
}
