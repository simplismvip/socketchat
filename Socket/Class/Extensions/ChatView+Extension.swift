//
//  ChatView+Extension.swift
//  Socket
//
//  Created by JunMing on 2022/6/28.
//

import UIKit
import SnapKit

/// 屏幕宽度
public let ScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高度
public let ScreenHeight = UIScreen.main.bounds.size.height
/// 屏幕Rect
public let ScreenBounds = UIScreen.main.bounds

public extension UIView {
    /// 快捷添加分割线
    func addLineToView(color: UIColor = .groupTableViewBackground, _ closure: (_ make: ConstraintMaker) -> Void) {
        let line = UIView()
        line.backgroundColor = color
        addSubview(line)
        line.snp.makeConstraints { closure($0)}
    }
}

@objc public extension UIImage {
    class func bundleImage(name:String) -> UIImage? {
        func findBundle(_ bundleName:String,_ podName:String) -> Bundle? {
            if var bundleUrl = Bundle.main.url(forResource: "Frameworks", withExtension: nil) {
                bundleUrl = bundleUrl.appendingPathComponent(podName)
                bundleUrl = bundleUrl.appendingPathExtension("framework")
                if let bundle = Bundle(url: bundleUrl),let url = bundle.url(forResource: bundleName, withExtension: "bundle") {
                    return Bundle(url: url)
                }
                return nil
            }
            return nil
        }
                
        if let bundle = findBundle("MsgResource", "NetMessage") {
            let scare = UIScreen.main.scale
            let imaName = String(format: "%@@%dx.png", name, Int(scare))
            if let imagePath = bundle.path(forResource: imaName, ofType: nil) {
                return UIImage(contentsOfFile: imagePath)
            }
            return nil
        }
        return nil
    }
    
    // 142, 42
    func resizable(isLeft: Bool) -> UIImage {
        let h = size.height
        let edge = UIEdgeInsets(top: h - 10, left: isLeft ? 40 : 0, bottom: h, right: isLeft ? 0 : 40)
        return resizableImage(withCapInsets: edge, resizingMode: .stretch)
    }
}

// MARK: -- UIViewController --
@objc public extension UIViewController {
    /// push
    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// present
    func present(_ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}


public extension Dictionary {
    /// JSON字符串转字典
    func jSONString() -> String? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}

public extension String {
    // 判断是否是空字符串
    var isBlank: Bool {
        let trimmedStr = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
    var intValue: Int? {
        return Int(self)
    }
    
    var image: UIImage? {
        return UIImage(named: self)
    }
    
    var bundleImage: UIImage? {
        return image
    }
    
    /// JSON字符串转字典
    func tojSONObjc() -> Dictionary <String, Any>? {
        if let jsonData:Data = self.data(using: .utf8) {
            if let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) {
                return dict as? Dictionary <String, Any>
            }
        }
        return nil
    }
    
    /// 字符串的匹配范围 方法一
    ///
    /// - Parameters:
    /// - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
    @discardableResult
    func matchStrRange(_ matchStr: String) -> [NSRange] {
        var allLocation = [Int]() //所有起点
        let matchStrLength = (matchStr as NSString).length  //currStr.characters.count 不能正确统计表情

        let arrayStr = self.components(separatedBy: matchStr)//self.componentsSeparatedByString(matchStr)
        var currLoc = 0
        arrayStr.forEach { currStr in
            currLoc += (currStr as NSString).length
            allLocation.append(currLoc)
            currLoc += matchStrLength
        }
        allLocation.removeLast()
        return allLocation.map { NSRange(location: $0, length: matchStrLength) } //可把这段放在循环体里面，同步处理，减少再次遍历的耗时
    }
}

@objc public extension UITableView {
    func scrollToBottom() {
        let deadline = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            let row = self.numberOfRows(inSection: 0) - 1
            if row > 1 {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: row, section: 0)
                    self.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
}

public extension Double {
    /// 时间戳字符串格式化
    func tspString(_ format: String = "yyyy/MM/dd HH:mm:ss") -> String {
        let date = Date(timeIntervalSince1970: self)
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        return dfmatter.string(from: date)
    }
}

public extension UIImageView {
    /// 加载图片
    /// - Parameters:
    ///   - urlStr: 图片地址
    ///   - pImage: 占位图
    ///   - local:  是否是本地路径
    ///   - complate: 结果
    func setImageWith(_ urlStr: String?, pImage: UIImage?, local: Bool = false, _ complate:((_ image: UIImage?)->Void)? = nil) {
        if let urlStr = urlStr {
            let _ = local ? URL(fileURLWithPath: urlStr) : URL(string: urlStr)
            
        }else{
            complate?(nil)
        }
    }
}

public extension CGSize {
    /// 计算照片比例
    /// - Parameters:
    ///   - oriSize: 原始大小
    ///   - minSize: 最小大小
    ///   - maxSize: 最大大小
    /// - Returns: 最终结果大小
    static func sizeWithImageOriginSize(oriSize: CGSize, minSize: CGSize, maxSize: CGSize) -> CGSize{
        var size = CGSize.zero
        let oriWidth = oriSize.width
        let oriHeight = oriSize.height
        
        let minWidth = minSize.width
        let minHeight = minSize.height
        
        let maxWidth = maxSize.width
        let maxHeight = maxSize.height
        
        if oriWidth > oriHeight {//宽图
            size.height = minHeight;  //高度取最小高度
            size.width = oriWidth * minWidth / oriHeight;
            if size.width > maxWidth {
                size.width = maxWidth
            }
        }else if oriWidth < oriHeight {//高图
            size.width = minWidth;
            size.height = oriHeight * minWidth / oriWidth;
            if (size.height > maxHeight) {
                size.height = maxHeight;
            }
        }else {//方图
            if (oriWidth > maxWidth) {
                size.width = maxWidth;
                size.height = maxHeight;
            }else if(oriWidth > minWidth) {
                size.width = oriWidth;
                size.height = oriHeight;
            }else{
                size.width = minWidth;
                size.height = minHeight;
            }
        }
        return size
    }
}

extension Array {
    public func jmRemove(by items: [Element], _ transFrom: (Element, Element)-> Bool) -> [Element] {
        return filter { (model) -> Bool in
            return !items.contains { (item) -> Bool in
                return transFrom(model, item)
            }
        }
    }
}
