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
        let nav = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        /// 加载广告
        let adView = create(waitTime: 5, showEnterForeground: true)
        request { model in
            adView.configure { button, adView in
                button.skipBtnType = model.skipBtnType
                adView.animationType = model.animationType
                adView.adFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_WIDTH*model.height/model.width)
            }
            adView.setImage(model.imgUrl, duration: model.duration, options: .refreshCache, action: {
                let vc = UIViewController()
                vc.view.backgroundColor = UIColor.yellow
                homeVC.navigationController?.pushViewController(vc, animated: true)
            })
        }
        return true
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("已经进入后台")
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        print("---")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("将要进入前台")
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        return true
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


