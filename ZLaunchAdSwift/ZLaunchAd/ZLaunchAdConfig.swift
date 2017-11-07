//
//  ZLaunchAdVC+Config.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/8/17.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

public let Z_SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let Z_SCREEN_HEIGHT = UIScreen.main.bounds.size.height

public typealias ZLaunchClosure = ()->()
/// 动画
public enum ZLaunchAnimationType {
    /// 缩小
    case zoomOut
    /// 无动画
    case none
    /// 溶解消失
    case crossDissolve
    /// 翻页
    case curlUp
    /// 上方翻转
    case flipFromTop
    /// 左边翻转
    case flipFromLeft
    /// 右边翻转
    case flipFromRight
    /// 底部翻转
    case flipFromBottom
    /// 向上滑动
    case slideFromTop
    /// 向下滑动
    case slideFromBottom
    /// 向左滑动
    case slideFromLeft
    /// 向右滑动
    case slideFromRight
}
/// 跳过按钮
struct ZLaunchSkipButtonConfig {
    /// frame
    var frame = CGRect(x: Z_SCREEN_WIDTH - 70,y: 42, width: 60,height: 30)
    /// 背景颜色
    var backgroundColor = UIColor.black.withAlphaComponent(0.4)
    /// 文字
    var text: NSString = "跳过"
    /// 字体大小
    var textFont = UIFont.systemFont(ofSize: 14)
    /// 字体颜色
    var textColor = UIColor.white
    /// 数字大小
    var timeFont = UIFont.systemFont(ofSize: 15)
    /// 数字颜色
    var timeColor = UIColor.red
    /// 跳过按钮类型
    var skipBtnType: ZLaunchSkipButtonType = .textLeftTimerRight
    /// 圆形进度颜色
    var strokeColor = UIColor.red
    /// 圆形进度宽度
    var lineWidth: CGFloat = 2
    /// 圆角
    var cornerRadius: CGFloat = 5
    /// 边框颜色
    var borderColor: UIColor = UIColor.clear
    /// 边框宽度
    var borderWidth: CGFloat = 1
}


