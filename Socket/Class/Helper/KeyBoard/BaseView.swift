//
//  BaseView.swift
//  Socket
//
//  Created by JunMing on 2022/6/28.
//

import UIKit

open class BaseView: UIView {
    deinit {
        print("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
    }
}
