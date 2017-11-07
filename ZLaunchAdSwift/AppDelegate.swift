//
//  AppDelegate.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/4/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let homeVC = ViewController()
        let nav = UINavigationController.init(rootViewController: homeVC)
        if launchOptions != nil {
            /// 通过推送等方式启动
            window?.rootViewController = nav
        } else {
            /// 加载广告
            let adVC = ZLaunchAdVC().waitTime(3).adBottom(200).animationType(.flipFromLeft).rootVC(nav).configSkipButton {
                $0.skipBtnType = .text
                $0.borderColor = UIColor.green
            }
            /// 网络图片
            request {
                adVC.setImage($0, duration: $1, action: {
                    let vc = UIViewController()
                    vc.view.backgroundColor = UIColor.yellow
                    homeVC.navigationController?.pushViewController(vc, animated: true)
                })
            }
            window?.rootViewController = adVC
            
        }
        window?.makeKeyAndVisible()
        
        return true
    }
    
    /// http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170725104352981.jpg
    /// http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif
    func request(_ completion: @escaping (_ url: String, _ duration: Int)->()) -> Void {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            let url = "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif"
            let adDuartion = 5
            completion(url, adDuartion)
        })
    }
}

