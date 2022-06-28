//
//  SRNetManager+Request.swift
//  SReader
//
//  Created by JunMing on 2021/7/8.
//

import UIKit
import ZJMKit
import Alamofire

// MARK: User
extension NetManager {
    static func login(token: String, callback: Completion<User>?) {
        requestModel(url: .LOGIN, method: .GET, postData: EmptyParameter(), encoder: URLEncodedFormParameterEncoder.default, queueType: .Authorization, modelType: User.self, completion: callback)
    }
    
    static func token(userid: String, passwd: String, callback: Completion<Token>?) {
        let parameter = ["username": userid, "password": passwd]
        let encoder = URLEncodedFormParameterEncoder.default
        requestModel(url: .TOKEN, method: .POST, postData: parameter, encoder: encoder, modelType: Token.self, completion: callback)
    }
    
    static func register(userid: String, passwd: String, callback: Completion<JMResult>?) {
        struct SRParameter: Encodable {
            var userid: String
            var passwd: String
            var userfrom = "ebook"
        }
        let parameter = SRParameter(userid: userid, passwd: passwd)
        requestModel(url: .REGISTER, method: .POST, postData: parameter, modelType: JMResult.self, completion: callback)
    }
    
    static func updateUser(key: String, value: String, callback: Completion<JMResult>?) {
        if let userid = LoginManager.share.user?.uid {
            let parameter = ["userid": userid, "key": key, "value": value]
            requestModel(url: .UPDATE, method: .POST, postData: parameter, modelType: JMResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
    
    static func deleteUser(callback: Completion<JMResult>?) {
        if let userid = LoginManager.share.user?.uid {
            let parameter = ["userid": userid]
            requestModel(url: .DELETE, postData: parameter, modelType: JMResult.self, completion: callback)
        } else {
            callback?(.Error(0))
        }
    }
}

extension NetManager {
    // 下载⏬
    static func downloadbook(url: String, progress: ((String) -> Void)?, callback: Completion<URL>?) {
        download(url: url) { (pro) in
            progress?(String(format: "%.0f%%", pro * 100))
        } completion: { (result) in
            callback?(result)
        }
    }
    
//    // 上传⏫
//    static func upload(image: UIImage, callback: Completion<SRUpload>?) {
//        let url = HTTPTarget.UPLOAD.url
//        uploadFile(url: url, fileObject: image) { (json) in
//            switch json {
//            case .Success(let json):
//                if let model: SRUpload = SRUpload.deserialize(from: json.dictionaryObject) {
//                    callback?(.Success(model))
//                } else {
//                    callback?(.Error(-1))
//                }
//            default:
//                callback?(.Error(-1))
//            }
//        }
//    }
}
