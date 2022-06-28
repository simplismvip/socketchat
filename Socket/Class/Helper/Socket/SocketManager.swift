//
//  SocketHandler.swift
//  Socket
//
//  Created by JunMing on 2022/6/20.
//

import UIKit
import ZJMKit
import Starscream

class SocketManager: SocketProtocol {
    let domain: String
    let port: String
    let user: User
    var socket: WebSocket?
    var delegate: ManagerDelegate?
    init(user: User, domain: String, port: String) {
        self.user = user
        self.domain = domain
        self.port = port
        
        self.socket = self.connect()
        socket?.delegate = self
    }
    
    // 链接后首先创建当前用户群组
    public func createRoom(to: User) {
        let msg = MsgMaker.msgWithRoom(text: "create room", to: to)
        send(msg: msg, callback: { desc, state in
            print("send success！")
        })
    }
}

protocol ManagerDelegate {
    func connected(_ header: SoekecHeader?)
    func disconnected(reason: String, code: UInt16)
    func onRecvMessage(_ msg: Message)
    func recvBinary(data: Data)
    func recvPing(data: Data?)
    func recvPong(data: Data?)
    func viabilityChanged(bool: Bool)
    func reconnectSuggested(bool: Bool)
    func cancelled()
    func error(error: Error?)
}

extension SocketManager: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                print("websocket is connected: \(headers)")
                delegate?.connected(SoekecHeader.deserialize(from: headers))
            case .disconnected(let reason, let code):
                print("websocket is disconnected: \(reason) with code: \(code)")
                delegate?.disconnected(reason: reason, code: code)
            case .text(let jsonString):
                print("Received text: \(jsonString)")
                if let msg = Message.deserialize(from: jsonString) {
                    delegate?.onRecvMessage(msg)
                }
            case .binary(let data):
                delegate?.recvBinary(data: data)
            case .ping(let data):
                delegate?.recvPing(data: data)
                break
            case .pong(let data):
                delegate?.recvPong(data: data)
                break
            case .viabilityChanged(let state):
                delegate?.viabilityChanged(bool: state)
            case .reconnectSuggested(let state):
                delegate?.reconnectSuggested(bool: state)
            case .cancelled:
                delegate?.cancelled()
            case .error(let error):
                delegate?.error(error: error)
        }
    }
}

