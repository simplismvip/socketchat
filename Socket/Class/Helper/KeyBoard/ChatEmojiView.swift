//
//  SHChatEmoji.swift
//  NewKeyBoard
//
//  Created by JunMing on 2020/12/18.
//

import UIKit

class ChatEmojiView: BaseView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRandColor
        label.text = "这是Emoji"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        label.center = self.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
