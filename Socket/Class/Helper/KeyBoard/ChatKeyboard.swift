//
//  SHChatKeyboard.swift
//  NewKeyBoard
//
//  Created by JunMing on 2020/12/18.
//

import UIKit
import ZJMKit

class ChatKeyboard: BaseView {
    @objc dynamic let toolbar = SHChatToolbar()
    let more = ChatMoreView()
    let emoji = ChatEmojiView()
    let router = JMRouter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.green
        setupSubViews()
        setupRouter()
        addObserver()
    }
    
    private func setupRouter() {
        jmSetAssociatedMsgRouter(router: router)
        toolbar.jmSetAssociatedMsgRouter(router: router)
        more.jmSetAssociatedMsgRouter(router: router)
        emoji.jmSetAssociatedMsgRouter(router: router)
    }
    
    private func addObserver() {
        // 添加键盘弹出、隐藏监听
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChnage(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        addObserver(self, forKeyPath: "self.toolbar.frame", options: [.new,.old], context: nil)
    }
    
    override class func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        if observer.isKind(of: self) && keyPath == "self.toolbar.frame" {
            print("addObserver")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        removeObserver(self, forKeyPath: "self.toolbar.frame")
    }
}

// MARK: - 键盘弹出监听通知
extension ChatKeyboard {
    @objc public func keyboardWillChnage(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        guard let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        if toolbar.kCurrType == .typeText {
            if (beginFrame.size.height > 0) && (beginFrame.origin.y-endFrame.origin.y > 0) {
                let targetY = endFrame.size.height + TOOLBAR_HEIGHT - IPhoneXBottomHeight
                jmRouterEvent(eventName: "kMsgNameKeyBoardWillChange", info: targetY as MsgObjc)
                print("didBecomeActive--KEYBOARD---SHOW")
            }else {
                let targetY = 64
                jmRouterEvent(eventName: "kMsgNameKeyBoardWillChange", info: targetY as MsgObjc)
                print("didBecomeActive--KEYBOARD---HIDE")
            }
        }else if toolbar.kCurrType == .typeMore {
            let targetY = 201 + TOOLBAR_HEIGHT - IPhoneXBottomHeight
            jmRouterEvent(eventName: "kMsgNameKeyBoardWillChange", info: targetY as MsgObjc)
            print("didBecomeActive--KEYBOARD---SHOW")
        }else if (toolbar.kCurrType == .typeNone) || (toolbar.kCurrType == .typeVoice) {
            let targetY = 64
            jmRouterEvent(eventName: "kMsgNameKeyBoardWillChange", info: targetY as MsgObjc)
            print("didBecomeActive--KEYBOARD---HIDE")
        }
        print("didBecomeActive--KEYBOARD---SHOW\(endFrame.origin.y)")
    }
}

// MARK: - UI设置相关
extension ChatKeyboard {
    private func setupSubViews() {
        addSubview(toolbar)
        addSubview(more)
        addSubview(emoji)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        more.translatesAutoresizingMaskIntoConstraints = false
        emoji.translatesAutoresizingMaskIntoConstraints = false
        emoji.isHidden = true
        toolbar.snp.makeConstraints { (make) in
            make.width.left.top.equalTo(self)
            make.height.equalTo(64)
        }
        
        more.snp.makeConstraints { (make) in
            make.width.left.equalTo(self)
            make.top.equalTo(toolbar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(snp.bottom)
            }
        }
        
        emoji.snp.makeConstraints { (make) in
            make.edges.equalTo(more)
        }
    }
}

