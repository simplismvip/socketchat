//
//  ViewController.swift
//  Socket
//
//  Created by JunMing on 2022/6/17.
//

import UIKit
import ZJMKit
import Starscream

class ViewController: BaseViewController {
    var dataSource: [User] = []
    var loginUser: User?
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0;
        tableView.sectionFooterHeight = 0;
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.append(contentsOf: DataTool.parseJson(name: "users"))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        LoginManager.share.logout { desc, state in
            print(desc)

            self.dataSource.removeAll()
            self.dataSource.append(contentsOf: DataTool.parseJson(name: "users"))
            self.tableView.reloadData()
        }
    }
    
    @IBAction func login(_ sender: Any) {
        let alert = UIAlertController(title: "选择账号登陆", message: nil, preferredStyle: .alert)
        for user in dataSource {
            let sureAction1 = UIAlertAction(title: user.uid, style: UIAlertAction.Style.default) { (action) in
                self.loginUser = user
                LoginManager.share.login(user: user) { desc, state in
                    print(desc)
                    let newUsers = self.dataSource.filter {
                        $0.uid != self.loginUser?.uid
                    }
                    self.dataSource.removeAll()
                    self.dataSource.append(contentsOf: newUsers)
                    self.tableView.reloadData()
                }
            }
            alert.addAction(sureAction1)
        }
        let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(cancleAction)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: -- TableView --
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identify = "ChatViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        if cell == nil {
            tableView.register(ChatViewCell.self, forCellReuseIdentifier: identify)
            cell = tableView.dequeueReusableCell(withIdentifier: identify)
        }
        
        (cell as? ChatViewCell)?.refreshData(data: dataSource[indexPath.row])
        return cell as? ChatViewCell ?? ChatViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ChatController(user: dataSource[indexPath.row]), animated: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: 10)
        UIView.animate(withDuration: 0.3) {
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}

class ChatViewCell: UITableViewCell {
    let photo = UIImageView()
    let name = UILabel()
    let uid = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(photo)
        contentView.addSubview(name)
        contentView.addSubview(uid)
        
        photo.snp.makeConstraints { (make) in
            make.width.height.equalTo(54)
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        name.snp.makeConstraints { (make) in
            make.left.equalTo(photo.snp.right).offset(10)
            make.top.equalTo(photo.snp.top)
            make.height.equalTo(26)
        }
        
        uid.snp.makeConstraints { (make) in
            make.left.equalTo(photo.snp.right).offset(10)
            make.top.equalTo(name.snp.bottom).offset(8)
            make.height.equalTo(20)
        }
        
        name.jmConfigLabel(alig: .center, font: UIFont.jmRegular(12), color: UIColor.jmHexColor("#B2B2B2"))
    }
    
    func refreshData(data: User) {
        name.text = data.name
        uid.text = "\(data.uid)"
        photo.setImage(url: data.photo, placeholder: nil, complate: nil)
    }
    required init?(coder: NSCoder) { fatalError("🆘🆘🆘") }
}

