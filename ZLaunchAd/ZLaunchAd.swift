//
//  ZLaunchAd.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2017/12/30.
//  Copyright © 2017年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAd
//

import UIKit

@objc public class ZLaunchAd: NSObject {
    
    /// 创建广告view --- 进入前台时显示
    ///
    /// - Parameters:
    ///   - waitTime: 加载广告等待的时间，默认3s
    ///   - showEnterForeground: 是否进入前台时显示，默认`false`
    ///   - timeForWillEnterForeground: 控制进入后台到前台显示的时间
    ///   - adNetRequest: 广告网络请求。如果需要每次进入前台是显示不同的广告图片，网络请求写在此闭包中
    /// - Returns: ZLaunchAdView
    @discardableResult
    @objc public class func create(waitTime: Int = 3,
                                   showEnterForeground: Bool = false,
                                   timeForWillEnterForeground: Double = 10,
                                   adNetRequest: ((ZLaunchAdView)->())? = nil)
        -> ZLaunchAdView
    {
        let launchAdView: ZLaunchAdView
        if showEnterForeground {
            launchAdView = ZLaunchAdView.default
            launchAdView.appear(showEnterForeground: showEnterForeground, timeForWillEnterForeground: timeForWillEnterForeground)
        } else {
            launchAdView = ZLaunchAdView()
            launchAdView.appear(showEnterForeground: false, timeForWillEnterForeground: timeForWillEnterForeground)
        }
        launchAdView.adRequest = adNetRequest
        launchAdView.waitTime = waitTime
        UIApplication.shared.delegate?.window??.addSubview(launchAdView)
        return launchAdView
    }
    
    
    /// 创建广告view --- 自定义通知控制出现
    ///
    /// - Parameters:
    ///   - waitTime: 加载广告等待的时间，默认3s
    ///   - customNotificationName: 自定义通知名称
    ///   - adNetRequest: 广告网络请求。如果需要每次进入前台是显示不同的广告图片，网络请求写在此闭包中
    /// - Returns: ZLaunchAdView
    @discardableResult
    @objc public class func create(waitTime: Int = 3,
                                   customNotificationName: String?,
                                   adNetRequest: ((ZLaunchAdView)->())? = nil)
        -> ZLaunchAdView
    {
        let launchAdView: ZLaunchAdView = ZLaunchAdView.default
        launchAdView.appear(showEnterForeground: false, customNotificationName: customNotificationName)
        launchAdView.adRequest = adNetRequest
        launchAdView.waitTime = waitTime
        UIApplication.shared.keyWindow?.addSubview(launchAdView)
        return launchAdView
    }
    
    // MARK: - 清除缓存
    /// 清除全部缓存
    @objc public class func clearDiskCache() {
        ZLaunchAdClearDiskCache()
    }
    
    /// 清除指定url缓存
    ///
    /// - Parameter urlArray: url数组
    @objc public class func clearDiskCacheWithImageUrlArray(_ urlArray: Array<String>) {
        ZLaunchAdClearDiskCacheWithImageUrlArray(urlArray)
    }
}
