//
//  Image.swift
//  Socket
//
//  Created by JunMing on 2022/6/22.
//

import UIKit
import Kingfisher

public extension UIImageView {
    func setImage(url: String?, placeholder: UIImage? = nil, complate: ((UIImage, URL?) -> Void)? = nil ) {
        if let headerUrl = url {
            self.kf.setImage(with: URL(string: headerUrl), placeholder: placeholder) { (result) in
                switch result {
                case .failure(let error):
                    print("%@", error.errorDescription ?? "")
                case .success(let resultImage):
                    complate?(resultImage.image, resultImage.source.url)
                }
            }
        } else {
            self.image = placeholder
        }
    }
}

extension UUID {
    
    var msgid: String {
        return UUID().uuidString.replacingOccurrences(of: "-", with: "").lowercased()
    }
}
