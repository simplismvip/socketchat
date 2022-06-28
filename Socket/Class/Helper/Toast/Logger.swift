//
//  Logger.swift
//  Socket
//
//  Created by JunMing on 2022/6/28.
//

import UIKit

public struct Logger {
    enum Level: String {
        case debug = "🐝 "
        case info = "ℹ️ "
        case warning = "⚠️ "
        case error = "🆘 "
    }
    
    static func debug(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Logger.eBookPrint(items, separator: separator, terminator: terminator, level: .debug)
    }
    
    static func info(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Logger.eBookPrint(items, separator: separator, terminator: terminator, level: .info)
    }
    
    static func warning(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Logger.eBookPrint(items, separator: separator, terminator: terminator, level: .warning)
    }
    
    static func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        Logger.eBookPrint(items, separator: separator, terminator: terminator, level: .error)
    }
    
    private static func eBookPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", level: Level){
        #if DEBUG
        print("\(level.rawValue)：\(items)", separator: separator, terminator: terminator)
        #endif
    }
    
    /// 写入本地错误logger
    static func writeError(_ error: String) {
        
    }
}
