//
//  SocketProtocol.swift
//  Socket
//
//  Created by JunMing on 2022/6/20.
//

import UIKit
import Starscream

typealias MsgHandle = (_ desc: String, _ state: Bool) -> Void

protocol SocketProtocol {
    var domain: String { get }
    var port: String { get }
    var user: User { get }
    var socket: WebSocket? { get }
    func connect() -> WebSocket
    func disConnect()
    func send(msg: Message?, callback: @escaping MsgHandle)
    func login(callback: @escaping MsgHandle)
    func logout(callback: @escaping MsgHandle)
}

extension SocketProtocol {
    
    public func connect() -> WebSocket {
        let url = URL(string: domain + "\(user.uid)")!
        let resuest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        let socket = WebSocket(request: resuest)
        socket.connect()
        print(domain + ":" + port)
        return socket
    }
    
    public func disConnect() {
        socket?.disconnect()
    }
    
    public func send(msg: Message?, callback: @escaping MsgHandle) {
        if let jsonStr = msg?.toJSONString() {
            print(jsonStr)
            socket?.write(string: jsonStr, completion: {
                callback("success!", true)
            })
        }
    }
    
    public func login(callback: @escaping MsgHandle) {
        let _ = connect()
    }
    
    public func logout(callback: @escaping MsgHandle) {
        disConnect()
    }
}

protocol SocketHandleProtocol {
    func recive(msg: Message, type: SocketType)
}
