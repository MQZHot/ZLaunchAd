//
//  ZLaunchCache.swift
//  ZLaunchAdSwift
//
//  Created by mengqingzheng on 2017/11/9.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit
import SwiftHash

// MARK: - 清除缓存
public func clearDiskCache() {
    DispatchQueue.global().async {
        do {
            try FileManager.default.removeItem(atPath: cacheImagePath())
            checkDirectory(cacheImagePath())
        } catch {
            printLog(error)
        }
    }
}
// MARK: - 清除指定url缓存
public func clearDiskCacheWithImageUrlArray(_ urlArray: Array<String>) {
    if urlArray.count == 0 { return }
    DispatchQueue.global().async {
        for url in urlArray {
            let path = "\(cacheImagePath())/\(MD5(url))"
            if FileManager.default.fileExists(atPath: MD5(path)) {
                do{
                    try FileManager.default.removeItem(atPath: MD5(path))
                }catch {
                    printLog(error)
                }
            }
        }
    }
}





/// 缓存图片
func saveImage(_ data: Data, url: URL, completion: ((Bool)->())?) {
    DispatchQueue.global().async {
        let path = "\(cacheImagePath())/\(MD5(url.absoluteString))"
        let isOk = FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        DispatchQueue.main.async {
            if completion != nil { completion!(isOk) }
        }
    }
}
/// 获取图片缓存
func getCacheImageWithURL(_ url: URL) -> Data? {
    let path = "\(cacheImagePath())/\(MD5(url.absoluteString))"
    do {
        let data = try NSData(contentsOfFile: path) as Data
        return data
    } catch  {
        printLog(error)
        return nil
    }
}

// MARK: - 目录
func cacheImagePath() -> String {
    let path = (NSHomeDirectory() as NSString).appendingPathComponent("Library/ZLaunchAdCache")
    checkDirectory(path)
    return path
}
// MARK: - 目录创建文件
func createBaseDirectoryAtPath(_ path: String) {
    do {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        let url = URL(fileURLWithPath: path) as NSURL
        try url.setResourceValue(NSNumber(value: true), forKey: .isExcludedFromBackupKey)
        printLog("ZLaunchAd cache directory = \(path)")
    } catch {
        printLog("create cache directory failed, error = \(error)")
    }
}
// MARK: - 检查目录
func checkDirectory(_ path: String) {
    var isDir: ObjCBool = false
    if !FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
        createBaseDirectoryAtPath(path)
    } else {
        if !isDir.boolValue {
            do {
                try FileManager.default.removeItem(atPath: path)
                createBaseDirectoryAtPath(path)
            } catch {
                printLog(error)
            }
        }
    }
}


