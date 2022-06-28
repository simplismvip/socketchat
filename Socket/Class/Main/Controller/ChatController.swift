//
//  ChatController.swift
//  Socket
//
//  Created by JunMing on 2022/6/20.
//

import UIKit
import SnapKit
import ZJMKit

class ChatController: BaseViewController {
    let recvLable = UILabel()
    let sendText = UITextView()
    let stackView = UIStackView()
    let photo = UIImageView()
    let manager: SocketManager
    let actions: [Action]
    let keyboard = ChatKeyboard()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.jmHexColor("#FAFBFC")
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        return tableView
    }()
    
    init(user: User) {
        self.actions = DataTool.parseJson(name: "action")
        self.manager = SocketManager(user: user, domain: "ws://127.0.0.1:8000/chat/ws/", port: "8000")
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manager.disConnect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager.delegate = self
        registerEvent()
        setupViews()
    }
    
    func registerEvent() {
        jmRegisterEvent(eventName: "kMsgNameKeyBoardWillChange", block: {[weak self] (height) in
            if let height = height as? CGFloat {
                self?.updateFrame(-height)
            }
        }, next: false)
    }
    
    func updateFrame(_ height: CGFloat) {
        keyboard.snp.updateConstraints({ (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(height)
            }else {
                make.top.equalTo(view.snp.bottom).offset(height)
            }
        })
    }
    
    func setupViews() {
        view.addSubview(keyboard)
        keyboard.snp.makeConstraints { (make) in
            make.width.left.equalTo(view)
            make.height.equalTo(265)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-64)
            }else {
                make.top.equalTo(view.snp.bottom).offset(-64)
            }
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.left.equalTo(view)
            make.bottom.equalTo(keyboard.snp.top)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
        }
    }
    
    @objc func sendAction(_ btn: UIButton) {
        print("start send message！")
        if btn.tag == 1000 {
            if let stext = sendText.text, stext != "\n", stext != "" {
                let msg = MsgMaker.msgWithText(text: stext, to: manager.user)
                manager.send(msg: msg, callback: { desc, state in
                    print("send success！")
                })
                sendText.text = nil
            } else {
                print("发送数据不能为空！")
            }
        } else if btn.tag == 1001 {
            let msg = MsgMaker.msgWithImage(filePath: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2F1114%2F0G020114924%2F200G0114924-15-1200.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1658478624&t=75bbc4dbe1520cb9cd7b0c5d5c9c9cfa", to: manager.user)
            manager.send(msg: msg, callback: { desc, state in
                print("send success！")
            })
        } else if btn.tag == 1002 {
            let msg = MsgMaker.msgWithLocation(lat: 122.232323, lng: 321.232311, title: "世博大道", to: manager.user)
            manager.send(msg: msg, callback: { desc, state in
                print("send success！")
            })
        } else if btn.tag == 1003 {
            let msg = MsgMaker.msgWithCustom(ext: TestExt.getExt(), to: manager.user)
            manager.send(msg: msg, callback: { desc, state in
                print("send success！")
            })
        } else if btn.tag == 1004 {
            let msg = MsgMaker.msgWithImage(filePath: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2F1114%2F0G020114924%2F200G0114924-15-1200.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1658478624&t=75bbc4dbe1520cb9cd7b0c5d5c9c9cfa", to: manager.user)
            manager.send(msg: msg, callback: { desc, state in
                print("send success！")
            })
        } else if btn.tag == 1005 {
            let msg = MsgMaker.msgWithLocation(lat: 122.232323, lng: 321.232311, title: "世博大道", to: manager.user)
            manager.send(msg: msg, callback: { desc, state in
                print("send success！")
            })
        } else if btn.tag == 1006 {
            let msg = MsgMaker.msgWithCustom(ext: TestExt.getExt(), to: manager.user)
            manager.send(msg: msg, callback: { desc, state in
                print("send success！")
            })
        }
        view.endEditing(false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatController: ManagerDelegate {
    func connected(_ header: SoekecHeader?) {
        recvLable.backgroundColor = UIColor.green.jmComponent(0.2)
    }
    
    func disconnected(reason: String, code: UInt16) {
        recvLable.backgroundColor = UIColor.gray.jmComponent(0.2)
    }
    
    func onRecvMessage(_ msg: Message) {
        switch msg.msgtype {
        case .text:
            recvLable.text = String(format: "%@(%d):%@", msg.sendername ?? "", msg.msgfrom, msg.content)
        case .location:
            break
        case .image:
            photo.setImage(url: msg.content, placeholder: nil, complate: nil)
        case .audio:
            break
        case .video:
            break
        case .file:
            break
        case .invite:
            print(msg.toJSON() as Any)
        case .accept:
            break
        case .create:
            break
        case .custom:
            print(msg.toJSON() as Any)
        case .banuser:
            break
        case .broadcast:
            print(msg.toJSON() as Any)
        case .destory:
            break
        }
    }
    
    func recvBinary(data: Data) {
        
    }
    
    func recvPing(data: Data?) {
        
    }
    
    func recvPong(data: Data?) {
        
    }
    
    func viabilityChanged(bool: Bool) {
        
    }
    
    func reconnectSuggested(bool: Bool) {
        
    }
    
    func cancelled() {
        
    }
    
    func error(error: Error?) {
        
    }
}

// MARK: -- TableView --
extension ChatController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify = "zf_time_chat_cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        if cell == nil {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: identify)
            cell = tableView.dequeueReusableCell(withIdentifier: identify)
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}
