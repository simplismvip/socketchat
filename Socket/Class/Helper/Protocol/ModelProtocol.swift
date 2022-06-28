//
//  ModelProtocol.swift
//  Socket
//
//  Created by JunMing on 2022/6/28.
//

import Foundation

protocol ModelProtocol { }

extension ModelProtocol {
    static func attachment(model: ModelProtocol) -> Self? {
        return CLNimAttachment.deserialize(model: model)
    }
}

struct CLNimAttachment<T: ModelProtocol> {
    static func deserialize(model: ModelProtocol) -> T? {
        return model as? T
    }
}
