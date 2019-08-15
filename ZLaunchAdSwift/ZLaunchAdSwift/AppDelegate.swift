//
//  AppDelegate.swift
//  ZLaunchAdDemo
//
//  Created by MQZHot on 2017/4/5.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let homeVC = ViewController()
        let nav = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
//        /// 本地图片
//        launchExample01(homeVC)
//        /// 加载网络图片
//        launchExample02(homeVC)
//        /// 自定义通知控制启动页广告出现
//        launchExample03(homeVC)
        /// 进入前台时显示
        launchExample04(homeVC)
        return true
    }
}

extension AppDelegate {
    
    /// 本地图片
    func launchExample01(_ homeVC: UIViewController) {
        let adView = ZLaunchAd.create(showEnterForeground: true)
        let imageResource = ZLaunchAdImageResourceConfigure()
        imageResource.imageNameOrImageURL = "163yun"
        imageResource.imageDuration = 5
        imageResource.imageFrame = UIScreen.main.bounds
        adView.setImageResource(imageResource, action: {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.yellow
            homeVC.navigationController?.pushViewController(vc, animated: true)
        })
    }
    /// 加载网络图片
    func launchExample02(_ homeVC: UIViewController) {
        let adView = ZLaunchAd.create(waitTime: 5)
        request { model in
            let buttonConfig = ZLaunchSkipButtonConfig()
            buttonConfig.skipBtnType = model.skipBtnType
            let imageResource = ZLaunchAdImageResourceConfigure()
            imageResource.imageNameOrImageURL = model.imgUrl
            imageResource.animationType = model.animationType
            imageResource.imageDuration = model.duration
            imageResource.imageFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_WIDTH*model.height/model.width)
            /// 设置图片、跳过按钮
            adView.setImageResource(imageResource, buttonConfig: buttonConfig, action: {
                let vc = UIViewController()
                vc.view.backgroundColor = UIColor.yellow
                homeVC.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
    
    /// 自定义通知控制启动页广告出现
    /// 如果通知控制显示不同的广告图片，网络请求需要写在`adNetRequest`闭包中
    /// 如果显示的是同一张图片，网络请求不需要写在闭包中，避免重复请求
    func launchExample03(_ homeVC: UIViewController) {
        ZLaunchAd.create(customNotificationName: "myNotification") { (adView) in
            self.request { model in
                let buttonConfig = ZLaunchSkipButtonConfig()
                buttonConfig.skipBtnType = model.skipBtnType
                let imageResource = ZLaunchAdImageResourceConfigure()
                imageResource.imageNameOrImageURL = model.imgUrl
                imageResource.animationType = model.animationType
                imageResource.imageDuration = model.duration
                imageResource.imageFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_WIDTH*model.height/model.width)
                
                adView.setImageResource(imageResource, buttonConfig: buttonConfig, action: {
                    let vc = UIViewController()
                    vc.view.backgroundColor = UIColor.yellow
                    homeVC.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }
    }
    
    /// 进入前台时显示
    /// `showEnterForeground`需要设置为`true`，`timeForWillEnterForeground`为app进入后台到再次进入前台的时间
    /// 如果进入前台时加载不同的广告图片，网络请求需要写在`adNetRequest`闭包中
    /// 如果显示的是同一张图片，网络请求不需要写在闭包中，避免重复请求
    func launchExample04(_ homeVC: UIViewController) {
        ZLaunchAd.create(showEnterForeground: true, timeForWillEnterForeground: 10, adNetRequest: { adView in
            self.request { model in
                let buttonConfig = ZLaunchSkipButtonConfig()
                buttonConfig.skipBtnType = model.skipBtnType
                let imageResource = ZLaunchAdImageResourceConfigure()
                imageResource.imageNameOrImageURL = model.imgUrl
                imageResource.animationType = model.animationType
                imageResource.imageDuration = model.duration
                imageResource.imageFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_HEIGHT-75)
                
                adView.setImageResource(imageResource, buttonConfig: buttonConfig, action: {
                    let vc = UIViewController()
                    vc.view.backgroundColor = UIColor.red
                    homeVC.navigationController?.pushViewController(vc, animated: true)
                })
            }
        }).endOfCountDown {
            printLog("倒计时结束了-----")
        }
    }
}

//MARK: - 模拟请求数据，此处解析json文件
extension AppDelegate {
    func request(_ completion: @escaping (AdModel)->()) -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            if let path = Bundle.main.path(forResource: "data", ofType: "json") {
                let url = URL(fileURLWithPath: path)
                do {
                    let data = try Data(contentsOf: url)
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let dict = json as? [String: Any],
                        let dataArray = dict["data"] as? [[String: Any]] {
                        /// 随机显示
                        let idx = Int(arc4random()) % dataArray.count
                        let model = AdModel(dataArray[idx])
                        completion(model)
                    }
                } catch  {
                    print(error)
                }
            }
        }
    }
}
