//
//  ZLaunchAd.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2017/12/30.
//  Copyright © 2017年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAdVC
//

import UIKit
@objc
public class ZLaunchAd: NSObject {
    
    /// 创建广告View
    ///
    /// - Parameters:
    ///   - waitTime: 加载广告等待的时间，默认3s
    ///   - showEnterForeground: 是否进入前台时显示，默认`false`
    ///   - adNetRequest: 广告网络请求。如果需要每次进入前台是显示不同的广告图片，网络请求写在此闭包中
    /// - Returns: ZLaunchAdView
    @discardableResult
    @objc public class func create(waitTime: Int = 3, showEnterForeground: Bool = false, adNetRequest: ((ZLaunchAdView)->())? = nil) -> ZLaunchAdView {
        let launchAdView: ZLaunchAdView
        if showEnterForeground {
            launchAdView = ZLaunchAdView.default
        } else {
            launchAdView = ZLaunchAdView(frame: UIScreen.main.bounds, showEnterForeground: false)
        }
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
