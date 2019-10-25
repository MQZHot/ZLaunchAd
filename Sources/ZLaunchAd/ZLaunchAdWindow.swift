//
//  ZLaunchAdWindow.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2018/1/1.
//  Copyright © 2018年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAd
//
import UIKit

extension UIWindow {
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        for sub_view in subviews {
            if sub_view.isKind(of: ZLaunchAdView.self) {
                bringSubviewToFront(sub_view)
            }
        }
    }
}
