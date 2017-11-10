//
//  ZLaunchConfig.swift
//  ZLaunchAdSwift
//
//  Created by mengqingzheng on 2017/11/9.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

let Z_SCREEN_WIDTH = UIScreen.main.bounds.size.width
let Z_SCREEN_HEIGHT = UIScreen.main.bounds.size.height

public typealias ZLaunchClosure = ()->()

// MARK: - 完成动画类型
public enum ZLaunchAnimationType: Int {
    /// 缩小
    case zoomOut = 0
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
// MARK: - 跳过按钮类型

public enum ZLaunchSkipButtonType: Int {
    /// 无跳过按钮
    case none = 0
    /// 文字跳过
    case text
    /// 倒计时
    case timer
    /// 文字左、数字右
    case textLeftTimerRight
    /// 文字右、数字左
    case textRightTimerLeft
    /// 圆形文字
    case roundText
    /// 圆形进度文字
    case roundProgressText
}
// MARK: - 缓存方式
public enum ZLaunchAdImageOptions: Int {
    /// 只加载，不缓存
    case onlyLoad = 0
    /// 先读缓存，再加载图片，刷新缓存
    case refreshCache
    /// 有缓存，读取缓存，不重新加载；没缓存先加载，并缓存
    case readCache
}
// MARK: - 配置跳过按钮
public struct ZLaunchSkipButtonConfig {
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
// MARK: - 配置
public struct ZLaunchAdViewConfig {
    /// 广告图大小
    var adFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_HEIGHT-100)
    /// 过渡动画
    var animationType: ZLaunchAnimationType = .crossDissolve
}


