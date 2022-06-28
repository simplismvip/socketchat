//
//  ChatEncoder.swift
//  Socket
//
//  Created by JunMing on 2022/6/20.
//

import UIKit
import HandyJSON

// 模型转data， data转模型
struct ChatEncoder<T: Codable> {
    
    static func enCoder(_ model: T) -> Data? {
        let encoder = PropertyListEncoder()
        return try? encoder.encode(model)
    }
    
    static func enCoder(list: [T]) -> [Data?] {
        return list.map { enCoder($0) }
    }
    
    static func deCoder(_ data: Data) -> T? {
        let decoder = PropertyListDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    static func deCoder(data: Data) -> [T]? {
        let decoder = PropertyListDecoder()
        do {
            return try decoder.decode([T].self, from: data)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static public func parseJson(name: String, ofType: String = "json") -> [T] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else { return [T]() }
        return deCoder(data: data) ?? [T]()
    }
}

struct DataTool<T: HandyJSON> {
    /// 解析本地[model,model,model,]结构json
    static public func parseJson(name: String, ofType: String = "json") -> [T] {
        guard let path = bundle()?.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj: obj)
    }
    
    /// 解析本地[model,model,model,]结构json
    static public func pathJson(name: String, ofType: String = "json") -> [T] {
        guard let path = Bundle.main.path(forResource: name, ofType: ofType) else { return [T]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [T]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [T]() }
        return parseJson(obj:obj)
    }
    
    /// 解析本地[[model],[model],[model],]结构json
    static public func parseJsonItems(name: String, ofType: String = "json") -> [[T]] {
        guard let path = bundle()?.path(forResource: name, ofType: ofType) else { return [[T]]() }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path),options: .mappedIfSafe) else { return [[T]]() }
        guard let obj = try? JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions()) else { return [[T]]() }
        guard let bookInfoDic = obj as? [[Dictionary<String, Any>]] else { return [[T]]() }
        return bookInfoDic.map {
            return parseJson(obj:$0)
        }
    }
    
    /// 解析整体。例如shelf.json可以整体解析
    static public func parseJson(obj: Any) -> [T] {
        guard let bookInfoDic = obj as? [Dictionary<String, Any>] else { return [T]() }
        return parse(items: bookInfoDic)
    }
    
    /// 解析拆分后的
    static public func parse(items: [Dictionary<String, Any>]) -> [T] {
        var models = [T]()
        for dicInfo in items {
            if let model = T.deserialize(from: dicInfo) {
                models.append(model)
            }
        }
        return models
    }

    static public func bundle() -> Bundle? {
        return Bundle.main
    }
}

extension DataTool {
    /// 解析远程 [Model]结构json
    static func parseModels(data: Data) -> [T]? {
        if let object = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dicList = object as? [[String: Any]] {
                return parse(items: dicList)
            }
        }
        return nil
    }
    
    /// 解析远程Model 结构json
    static func parseModel(data: Data) -> T? {
        if let object = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dic = object as? [String: Any] {
                return T.deserialize(from: dic)
            }
        }
        return nil
    }
}
