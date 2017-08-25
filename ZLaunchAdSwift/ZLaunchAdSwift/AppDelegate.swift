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
            /// 通过推送等启动
            window?.rootViewController = nav
        } else {
            /// 加载广告
            /// http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170725104352981.jpg
            /// http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif
            
            let adVC = ZLaunchAdVC().adBottom(200).transition(.filpFromLeft).configRootVC(nav)
            
            /// 网络图片
            request(completion: { (url, duration) in
                adVC.configNetImage(url: url, duration: duration, adImgViewClick: {
                    let vc = UIViewController()
                    vc.view.backgroundColor = UIColor.yellow
                    homeVC.navigationController?.pushViewController(vc, animated: true)
                })
            })
            
            /// 本地图片
//            adVC.configLocalImage(image: UIImage(named: "222"), duration: 7, adImgViewClick: {
//                let vc = UIViewController()
//                vc.view.backgroundColor = UIColor.yellow
//                homeVC.navigationController?.pushViewController(vc, animated: true)
//            })
            
            /// 本地GIF
//            adVC.configLocalGif(name: "111", duration: 7, adImgViewClick: {
//                let vc = UIViewController()
//                vc.view.backgroundColor = UIColor.yellow
//                homeVC.navigationController?.pushViewController(vc, animated: true)
//            })
            
            window?.rootViewController = adVC
        }
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func request(completion: @escaping (_ url: String, _ duration: Int)->()) -> Void {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            let url = "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif"
            let adDuartion = 8
            completion(url, adDuartion)
        })
    }
    
}
