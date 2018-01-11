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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let homeVC = ViewController()
        let nav = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        /// example_01
        setupLaunchAd_01 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.yellow
            homeVC.navigationController?.pushViewController(vc, animated: true)
        }
//        /// example_02
//        setupLaunchAd_02 {
//            let vc = UIViewController()
//            vc.view.backgroundColor = UIColor.yellow
//            homeVC.navigationController?.pushViewController(vc, animated: true)
//        }
        return true
    }
}
extension AppDelegate {
    /// 本地图片
    func setupLaunchAd_01(adClick: @escaping (()->())) {
        let adView = create(waitTime: 3, showEnterForeground: true)
        let imageResource = ZLaunchAdImageResourceConfigure()
        imageResource.imageNameOrImageURL = "163yun"
        imageResource.imageDuration = 5
        imageResource.imageFrame = UIScreen.main.bounds
        adView.setImageResource(imageResource, action: {
            adClick()
        })
    }
}
extension AppDelegate {
    /// 网络图片
    func setupLaunchAd_02(adClick: @escaping (()->())) {
        let adView = create(waitTime: 3, showEnterForeground: true)
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
                adClick()
            })
        }
    }
}

extension AppDelegate {
    /// 模拟请求数据，此处解析json文件
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
