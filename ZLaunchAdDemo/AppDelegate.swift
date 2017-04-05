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
            
            window?.rootViewController = nav
        } else {
            
            let adVC = MLaunchADVC.init(skipBtnPosition: .rightBottom, setAdParams: { (advc) in
                advc.setAdImgView(url: "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170331202849335.png", adDuartion: 6, adImgViewClick: {
                    
                    let vc = UIViewController()
                    vc.view.backgroundColor = UIColor.green
                    homeVC.navigationController?.pushViewController(vc, animated: true)
                    
                }, completion: {
                    self.window?.rootViewController = nav
                })
            })
            window?.rootViewController = adVC
        }
        window?.makeKeyAndVisible()
        
        return true
    }


}

