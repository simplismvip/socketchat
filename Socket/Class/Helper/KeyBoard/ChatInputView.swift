//
//  SHChatInputView.swift
//  SaleHouseSwift
//
//  Created by JunMing on 2020/11/9.
//  Copyright © 2020 sujp01. All rights reserved.
//

import UIKit
import ZJMKit

public class ChatInputView: BaseView {
    public let textView = UITextView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
        textView.returnKeyType = .send
        textView.font = UIFont.jmRegular(16)
        textView.isEditable = true
        textView.isSelectable = true
        textView.layer.cornerRadius = 6
        textView.backgroundColor = UIColor.white
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
