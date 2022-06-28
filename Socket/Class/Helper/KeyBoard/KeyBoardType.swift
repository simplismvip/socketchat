//
//  KeyBoardType.swift
//  NewKeyBoard
//
//  Created by JunMing on 2020/12/18.
//

import UIKit

public let TOOLBAR_HEIGHT: CGFloat = 64.0
/// 状态栏高度  20  44
public let StatusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.size.height

/// 底部TabBar高度
public let TabBarHeight:CGFloat = (StatusBarHeight>20 ? 83:49)

/// 导航整体高度 64 88
public let NavBarHeight:CGFloat = (StatusBarHeight + 44)

/// iPhone X底部需要适配的高度
public let IPhoneXBottomHeight:CGFloat = (StatusBarHeight>20 ? 34:0)

enum KeyBoardType {
    case typeMore
    case typeEmoji
    case typeText
    case typeVoice
    case typeNone
}
