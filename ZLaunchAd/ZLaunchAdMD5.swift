//
//  ZLaunchAdMD5.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2018/8/6.
//  Copyright © 2018年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAd
//
import UIKit

import CommonCrypto

/// md5
func MD5(_ str: String) -> String {
    let cStr = str.cString(using: String.Encoding.utf8);
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
    CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
    let md5String = NSMutableString()
    for i in 0 ..< 16{
        md5String.appendFormat("%02x", buffer[i])
    }
    free(buffer)
    return md5String as String
}
