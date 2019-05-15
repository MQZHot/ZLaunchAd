//
//  ZLaunchLog.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2017/4/5.
//  Copyright © 2017年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAd
//

import Foundation
//Log
func printLog<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
