//
//  ZLaunchAdWindow.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2018/1/1.
//  Copyright © 2018年 MQZHot. All rights reserved.
//

import UIKit

extension UIWindow {
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        /// namespace
        let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        for sub_view in subviews {
            if sub_view.classForCoder.description() == "\(namespace).ZLaunchAdView" {
                bringSubview(toFront: sub_view)
            }
        }
    }
}
