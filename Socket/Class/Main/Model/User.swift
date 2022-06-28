//
//  User.swift
//  Socket
//
//  Created by JunMing on 2022/6/20.
//

import UIKit
import HandyJSON

struct User: HandyJSON, ModelProtocol {
    var uid: String = "0"
    var name: String?
    var photo: String?
    var state: State = .online
    var timetsp: Date?
    
    mutating func change(state: State) {
        self.state = state
    }
}
