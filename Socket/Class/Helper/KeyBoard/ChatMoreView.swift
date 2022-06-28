//
//  SHChatMore.swift
//  NewKeyBoard
//
//  Created by JunMing on 2020/12/18.
//

import UIKit
import HandyJSON

class ChatMoreView: BaseView, UIScrollViewDelegate {
    private let pageControl = UIPageControl()
    private let content = UIScrollView()
    var dataSource = [[MoreItem]]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dataSource.append(DataTool.parseJson(name: "action"))
        configViews()
        setupViews()
    }
    
    private func configViews() {
        let width = UIScreen.main.bounds.size.width
        content.delegate = self
        content.contentSize = CGSize(width: CGFloat(dataSource.count) * width, height: 0)
        content.isPagingEnabled = true
        content.bounces = false
        content.showsVerticalScrollIndicator = false
        content.showsHorizontalScrollIndicator = false
        pageControl.numberOfPages = dataSource.count
        pageControl.pageIndicatorTintColor = UIColor.jmRGB(130, 130, 130)
        pageControl.currentPageIndicatorTintColor = UIColor.jmRGB(211, 211, 211)
    }
    
    private func setupViews() {
        addSubview(pageControl)
        addSubview(content)
        
        pageControl.snp.makeConstraints { (make) in
            make.width.equalTo(self)
            make.height.equalTo(20)
            if #available(iOS 11, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(snp.bottom)
            }
        }
        
        content.snp.makeConstraints { (make) in
            make.left.width.top.equalTo(self)
            make.bottom.equalTo(pageControl.snp.top)
        }
        
        let width = UIScreen.main.bounds.size.width
        for (index, items) in dataSource.enumerated() {
            let itemView = MoreItemViwe()
            itemView.updateViews(items: items)
            content.addSubview(itemView)
            
            let offset = CGFloat(index) * width
            itemView.snp.makeConstraints { (make) in
                make.left.equalTo(content).offset(offset)
                make.width.equalTo(width)
                make.top.height.equalTo(content)
            }
        }
        
        addLineToView(color: UIColor.jmHexColor("#DCDCDC")) { (make) in
            make.left.width.top.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / jmWidth
        pageControl.currentPage = Int(page)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: 每页8个64x64的Item，2行4列，可以少，多了忽略。
class MoreItemViwe: BaseView {
    func updateViews(items: [MoreItem]) {
        for (index, item) in items.enumerated() {
            let btn = UIButton(type: .system)
            btn.tag = index + 10000
            btn.setTitleColor(UIColor.jmHexColor("#7B7B7B"), for: .normal)
            btn.setTitle(item.title, for: .normal)
            btn.setImage(item.icon?.image?.origin, for: .normal)
            btn.jmAddAction { [weak self](_) in
                self?.jmRouterEvent(eventName: item.event ?? "kEventNameMoreKeyBoardAction", info: item as AnyObject)
            }
            addSubview(btn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let count = CGFloat(subviews.count)
        let width:CGFloat = 64
        let height:CGFloat = 64
        let marginX:CGFloat = (jmWidth - 64 * 4) / 5
        
        let colom = ceil(count/4)
        let marginY:CGFloat = (jmHeight - 64 * colom) / (colom + 1)
        
        for (index, view) in subviews.enumerated() {
            let r = index % 4
            let c = index / 4
            
            let x = marginX + (marginX + width) * CGFloat(r)
            let y = marginY + (marginY + height) * CGFloat(c)
            
            view.frame = CGRect.Rect(x, y, width, height)
            if let btn = view as? UIButton {
                btn.titleLabel?.font = UIFont.jmAvenir(11)
                btn.jmImagePosition(style: .top, spacing: 10)
            }
        }
    }
}

// MARK: MoreItem 模型
struct MoreItem: HandyJSON {
    var icon: String?
    var title: String?
    var event: String?
    var msgtype: Int?
}
