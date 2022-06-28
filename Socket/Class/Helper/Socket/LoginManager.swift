//
//  LoginManager.swift
//  Socket
//
//  Created by JunMing on 2022/6/28.
//

import UIKit
import Alamofire

typealias LoginHandle = (_ desc: String, _ state: Bool) -> Void

struct LoginManager {
    public var user: User?
    static var share: LoginManager = {
        return LoginManager()
    }()
    
    mutating func login(user: User, callback: @escaping LoginHandle) {
        self.user = user
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback("login success!", true)
        }
    }
    
    func isLogin() -> Bool {
        return user?.state == .online
    }
    
    func logout(callback: @escaping LoginHandle) {
        
    }
}
