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

public typealias ZClosure = ()->()

public enum SkipButtonType {
    case none                   /// 无跳过按钮
    case timer                  /// 跳过+倒计时
    case circle                 /// 圆形跳过
}

public enum TransitionType {
    case none
    case rippleEffect           /// 涟漪波纹
    case fade                   /// 交叉淡化
    case flipFromTop            /// 上下翻转
    case filpFromBottom
    case filpFromLeft           /// 左右翻转
    case filpFromRight
}

public protocol SkipBtnConfig {
    var skipBtnType: SkipButtonType { get }         /// 按钮类型
    var backgroundColor: UIColor { get }            /// 背景颜色
    var titleFont: UIFont { get }                   /// 标题字体
    var titleColor: UIColor { get }                 /// 字体颜色
    var cornerRadius: CGFloat { get }               /// 圆角
    var strokeColor: UIColor { get }                /// 圆形按钮进度条颜色
    var lineWidth: CGFloat { get }                  /// 圆形按钮进度条宽度
    var width: CGFloat { get }
    var height: CGFloat { get }
    var centerX: CGFloat { get }
    var centerY: CGFloat { get }
}

struct SkipBtnModel: SkipBtnConfig {
    
    var cornerRadius: CGFloat = 15
    var backgroundColor = UIColor.black.withAlphaComponent(0.4)
    var titleFont = UIFont.systemFont(ofSize: 12)
    var titleColor = UIColor.white
    var skipBtnType: SkipButtonType = .timer
    var strokeColor = UIColor.red
    var lineWidth: CGFloat = 2
    var width: CGFloat = 60
    var centerX: CGFloat = Z_SCREEN_WIDTH - 40
    var height: CGFloat = 30
    var centerY: CGFloat = 45
    
}

//MARK: - Log日志
func printLog<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
