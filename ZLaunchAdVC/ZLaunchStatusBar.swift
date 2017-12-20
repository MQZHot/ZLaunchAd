//
//  ZLaunchStatusBar.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2017/4/5.
//  Copyright © 2017年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAdVC
//

import UIKit
// MARK: - 状态栏
extension ZLaunchAdVC {
    override public var prefersStatusBarHidden: Bool {
        return Bundle.main.infoDictionary?["UIStatusBarHidden"] as? Bool ?? false
    }
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        let str = Bundle.main.infoDictionary?["UIStatusBarStyle"] as? String ?? "Default"
        return str.contains("Default") ? .default : .lightContent
    }
}
