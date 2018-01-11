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

@discardableResult
public func create(waitTime: Int = 3, showEnterForeground: Bool = false, adNetRequest: ((ZLaunchAdView)->())? = nil) -> ZLaunchAdView {
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
