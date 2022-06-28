//
//  JMToast.swift
//  Socket
//
//  Created by JunMing on 2022/6/28.
//

import ZJMKit

// Toast
public struct JMToast {
    static func toast(_ text: String, second: Int = 1) {
        JMTextToast.share.jmShowString(text: text, seconds: TimeInterval(second))
    }
}
