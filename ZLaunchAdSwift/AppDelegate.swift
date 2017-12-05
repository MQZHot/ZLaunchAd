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
        if launchOptions != nil {
            /// 通过推送等方式启动
            window?.rootViewController = nav
        } else {
            /// 加载广告
            let adVC = ZLaunchAdVC(waitTime: 4,rootVC: nav)
            request { model in
                adVC.configure { button, adView in
                    
                    button.skipBtnType = model.skipBtnType
                    adView.animationType = model.animationType
                    adView.adFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_WIDTH*model.height/model.width)
                    
                }.setImage(model.imgUrl, duration: model.duration, options: .readCache, action: {
                        
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
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
}

extension AppDelegate {
    /// 模拟请求数据，此处解析json文件
    func request(_ completion: @escaping (AdModel)->()) -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
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
