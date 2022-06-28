//
//  SHChatToolbar.swift
//  NewKeyBoard
//
//  Created by JunMing on 2020/12/18.
//

import UIKit
import ZJMKit

class SHChatToolbar: BaseView {
    // 输入
    private let textView = ChatInputView()
    // 更多按钮🔘
    private let moreBtn = UIButton(type: .custom)
    // 录音按钮🔘
    private let recordBtn = UIButton(type: .custom)
    // 左侧录音按钮🔘
    private let voiceBtn = UIButton(type: .custom)
    // Emoji按钮🔘
    private let emojiBtn = UIButton(type: .custom)
    var kCurrType = KeyBoardType.typeText
    var kPreviewType = KeyBoardType.typeText
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.jmRandColor
        addActions()
        setupSubViews()
        configViews()
    }
    
    @objc func touchDownAction() {
        recordBtn.backgroundColor = UIColor.jmHexColor("#B2B2B2").jmComponent(0.35)
    }
    
    @objc func touchUpinside() {
        recordBtn.backgroundColor = UIColor.white
    }
    
    @objc func touchUpOutside() {
        recordBtn.backgroundColor = UIColor.white
    }
    
    @objc func touchDragInside() {
        
    }
    
    @objc func touchDragOutside() {
        recordBtn.backgroundColor = UIColor.white
    }
    
    @objc func moreBtnClick(_ sender: UIButton) {
        voiceBtn.isSelected = false
        emojiBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            kCurrType = .typeMore
            textView.textView.resignFirstResponder()
        }else {
            kCurrType = .typeText
            textView.textView.becomeFirstResponder()
        }
    }
    
    @objc func emojiBtnClick(_ sender: UIButton) {
        voiceBtn.isSelected = false
        moreBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            kCurrType = .typeEmoji
            textView.textView.resignFirstResponder()
        }else {
            kCurrType = .typeText
            textView.textView.becomeFirstResponder()
        }
    }
    
    @objc func voiceBtnClick(_ sender: UIButton) {
        moreBtn.isSelected = false
        emojiBtn.isSelected = false
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            kCurrType = .typeVoice
            textView.textView.resignFirstResponder()
        }else {
            kCurrType = .typeText
            textView.textView.becomeFirstResponder()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recordBtn.titleLabel?.font = UIFont.jmMedium(16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI设置相关
extension SHChatToolbar {
    private func addActions() {
        recordBtn.addTarget(self, action: #selector(touchDownAction), for: .touchDown)
        recordBtn.addTarget(self, action: #selector(touchDragInside), for: .touchDragInside)
        recordBtn.addTarget(self, action: #selector(touchDragOutside), for: .touchDragOutside)
        recordBtn.addTarget(self, action: #selector(touchUpinside), for: .touchUpInside)
        recordBtn.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
        
        moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
        emojiBtn.addTarget(self, action: #selector(emojiBtnClick(_:)), for: .touchUpInside)
        voiceBtn.addTarget(self, action: #selector(voiceBtnClick(_:)), for: .touchUpInside)
    }
    
    private func setupSubViews() {
        addSubview(moreBtn)
        addSubview(voiceBtn)
        addSubview(recordBtn)
        addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        voiceBtn.translatesAutoresizingMaskIntoConstraints = false
        recordBtn.translatesAutoresizingMaskIntoConstraints = false
        
        voiceBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(9)
        }
        
        recordBtn.snp.makeConstraints { (make) in
            make.left.equalTo(voiceBtn.snp.right).offset(5)
            make.right.equalTo(moreBtn.snp.left).offset(-5)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-9)
        }
        
        moreBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(34)
            make.centerY.equalTo(snp.centerY)
            make.trailing.equalTo(-9)
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(voiceBtn.snp.right).offset(5)
            make.right.equalTo(moreBtn.snp.left).offset(-5)
            make.top.equalTo(self).offset(10)
            make.bottom.equalTo(self).offset(-9)
        }
    }
    
    private func configViews() {
        voiceBtn.setImage("语音输入".image?.origin, for: .normal)
        moreBtn.setImage("更多".image?.origin, for: .normal)
        recordBtn.setTitle("按住 说话", for: .normal)
        recordBtn.setTitleColor(UIColor.jmHexColor("#333333"), for: .normal)
        recordBtn.layer.cornerRadius = 6
        recordBtn.backgroundColor = UIColor.white
        recordBtn.adjustsImageWhenDisabled = false
        
        textView.textView.delegate = self
        backgroundColor = UIColor.jmHexColor("#F5F5F5")
    }
}

// MARK: - 扩展，设置输入框相关属性
extension SHChatToolbar: UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // 点击发送按钮
            if textView.text.isBlank || textView.text == "" || textView.text == "\n" {
                JMTextToast.share.jmShowString(text: "不能发送空内容", seconds: 1)
                textView.text = ""
            }else{
                let message = textView.text.replacingOccurrences(of: "\n", with: "")
                jmSendMsg(msgName: "kMsgNameSendTextMessage", info: message as MsgObjc)
                jmSendMsg(msgName: "kMsgNameKeyBoardUpdateHeight", info: 59 as MsgObjc)
                textView.text = ""
                return false
            }
        }
        return true
    }
    
    // 计算输入的文字高度
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.isBlank || textView.text == "" || textView.text == "\n" {
            jmSendMsg(msgName: "kMsgNameKeyBoardUpdateHeight", info: 59 as MsgObjc)
            textView.text = ""
        }else {
            var textHeight = textView.sizeThatFits(CGSize(width: ScreenWidth-110, height: CGFloat(MAXFLOAT))).height
            textHeight += 19
            if textHeight > 59 {
                if textHeight >= 100 {
                    // 达到最大时，不再扩大
                    textView.isScrollEnabled = true
                    jmSendMsg(msgName: "kMsgNameKeyBoardUpdateHeight", info: 90 as MsgObjc)
                }else{
                    textView.isScrollEnabled = false
                    jmSendMsg(msgName: "kMsgNameKeyBoardUpdateHeight", info: textHeight as MsgObjc)
                }
            }else{
                textView.isScrollEnabled = false
                jmSendMsg(msgName: "kMsgNameKeyBoardUpdateHeight", info: textHeight as MsgObjc)
            }
        }
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        kCurrType = .typeText
        return true
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        kCurrType = .typeNone
    }
}
