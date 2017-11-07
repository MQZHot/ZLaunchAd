//
//  ZLaunchStatusBar.swift
//  ZLaunchAdSwift
//
//  Created by mengqingzheng on 2017/11/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit
// MARK: - 状态栏
extension ZLaunchAdVC {
    override var prefersStatusBarHidden: Bool {
        return Bundle.main.infoDictionary?["UIStatusBarHidden"] as! Bool
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let str = Bundle.main.infoDictionary?["UIStatusBarStyle"] as! String
        return str.contains("Default") ? .default : .lightContent
    }
}
