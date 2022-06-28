//
//  MsgMaker.swift
//  Socket
//
//  Created by JunMing on 2022/6/20.
//

import UIKit

func getRid(from: User, to: User) -> String {
    return from.uid + "r" + to.uid
}

struct MsgMaker {
    static func msgWithText(text: String, to: User) -> Message? {
        let message =  Message(content: text, to: to, type: .text, sessionType: 1, sessionid: to.uid, atta: nil, ext: nil)
        configMsg(message: message)
        return message
    }
    
    static func msgWithImage(filePath: String, to: User) -> Message? {
        let url = filePath
        let thumUrl = filePath
        let att = Attachment(url: url, thumburl: thumUrl)
        let message =  Message(content: filePath, to: to, type: .image, sessionType: 1, sessionid: to.uid, atta: att, ext: nil)
        configMsg(message: message)
        return message
    }
    
    static func msgWithLocation(lat: Double, lng: Double, title: String?, to: User) -> Message {
        let att = Attachment(title: title, latitude: "\(lat)", longitude: "\(lng)")
        let message = Message(content: "位置消息", to: to, type: .location, sessionType: 1, sessionid: to.uid, atta: att, ext: nil)
        configMsg(message: message)
        return message
    }
    
    static func msgWithCustom(ext: TestExt, to: User) -> Message {
        let message = Message(content: "自定义消息", to: to, type: .custom, sessionType: 1, sessionid: to.uid, atta: nil, ext: ext.toJSON())
        configMsg(message: message)
        return message
    }
    
    static func msgWithRoom(text: String, to: User) -> Message? {
        if let from = LoginManager.share.user {
            let rid = getRid(from: from, to: to)
            let ext = CreateRoomExt(rid: rid, name: to.name, owner: from.uid, users: nil, timetsp: Date.jmCreateTspString())
            let message = Message(content: text, to: to, type: .text, sessionType: 1, sessionid: rid, atta: nil, ext: ext.toJSON())
            configMsg(message: message)
            return message
        } else {
            return nil
        }
    }
    
    static func msgWithInvite(text: String, to: User) -> Message? {
        if let from = LoginManager.share.user {
            let rid = getRid(from: from, to: to)
            let descr = (from.name ?? "") + "邀请加入" + (to.name ?? "")
            let ext = InvateExt(from: from.uid, to: to.uid, rid: rid, descr: descr, timetsp: Date.jmCreateTspString())
            let message = Message(content: text, to: to, type: .text, sessionType: 1, sessionid: rid, atta: nil, ext: ext.toJSON())
            configMsg(message: message)
            return message
        } else {
            return nil
        }
    }
    
    static func msgWithAccept(text: String, to: User) -> Message? {
        if let from = LoginManager.share.user {
            let ext = CreateRoomExt(rid: to.uid, name: to.name, owner: from.uid, users: nil, timetsp: Date.jmCreateTspString())
            let message = Message(content: text, to: to, type: .text, sessionType: 1, sessionid: to.uid, atta: nil, ext: ext.toJSON())
            configMsg(message: message)
            return message
        } else {
            return nil
        }
    }
    
    static func msgWithDestory(text: String, to: User) -> Message? {
        if let from = LoginManager.share.user {
            let ext = CreateRoomExt(rid: to.uid, name: to.name, owner: from.uid, users: nil, timetsp: Date.jmCreateTspString())
            let message = Message(content: text, to: to, type: .text, sessionType: 1, sessionid: to.uid, atta: nil, ext: ext.toJSON())
            configMsg(message: message)
            return message
        } else {
            return nil
        }
    }
    
    static func msgWithBanuser(text: String, to: User) -> Message? {
        if let from = LoginManager.share.user {
            let ext = CreateRoomExt(rid: to.uid, name: to.name, owner: from.uid, users: nil, timetsp: Date.jmCreateTspString())
            let message = Message(content: text, to: to, type: .text, sessionType: 1, sessionid: to.uid, atta: nil, ext: ext.toJSON())
            configMsg(message: message)
            return message
        } else {
            return nil
        }
    }
    
    static func msgWithBroadcast(text: String, to: User) -> Message? {
        if let from = LoginManager.share.user {
            let ext = CreateRoomExt(rid: to.uid, name: to.name, owner: from.uid, users: nil, timetsp: Date.jmCreateTspString())
            let message = Message(content: text, to: to, type: .text, sessionType: 1, sessionid: to.uid, atta: nil, ext: ext.toJSON())
            configMsg(message: message)
            return message
        } else {
            return nil
        }
    }
    
    static func configMsg(message: Message) {
        
    }
}
