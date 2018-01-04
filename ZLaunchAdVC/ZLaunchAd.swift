//
//  ZLaunchAd.swift
//  ZLaunchAdSwift
//
//  Created by mengqingzheng on 2017/12/30.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

@discardableResult
public func create(waitTime: Int = 3, showEnterForeground: Bool = false) -> ZLaunchAdView {
    let launchAdView: ZLaunchAdView
    if showEnterForeground {
        launchAdView = ZLaunchAdView.default
    } else {
        launchAdView = ZLaunchAdView()
    }
    launchAdView.waitTime = waitTime
    launchAdView.showEnterForeground = showEnterForeground
    launchAdView.frame = UIScreen.main.bounds
    UIApplication.shared.keyWindow?.addSubview(launchAdView)
    return launchAdView
}
