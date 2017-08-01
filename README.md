![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/ZLaunchAdVC.png)

![](https://img.shields.io/badge/platform-iOS-yellow.svg) ![](https://img.shields.io/badge/language-swift-red.svg) ![](https://img.shields.io/badge/support-iOS%208%2B-blue.svg) ![](https://img.shields.io/cocoapods/v/ZLaunchAdVC.svg?style=flat) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)

## swift 集成app启动页广告，切换rootViewController，支持LaunchImage和LaunchScreen.storyboard，支持GIF图片显示，支持视图过渡动画

## 不足之处，欢迎交流，欢迎star✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨


![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic1.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic2.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic3.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic4.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic5.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic6.gif)

## 功能

- [x] 圆形跳过按钮、倒计时+跳过
- [x] 全屏广告、广告距离底部距离设置
- [x] 跳过按钮位置： 屏幕右上角、右下角，广告图右下角
- [x] 支持GIF图片显示
- [x] 支持状态栏颜色设置、显示与隐藏

## 使用

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    window = UIWindow.init(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.white
    let homeVC = ViewController()
    let nav = UINavigationController.init(rootViewController: homeVC)

    if launchOptions != nil {

        /// 通过推送等启动
        window?.rootViewController = nav

    } else {
        /// 正常点击icon启动页，加载广告
        let adVC = ZLaunchAdVC.init(defaultDuration: 6, completion: {
    
            self.window?.rootViewController = nav

        })
        /// 延时模拟网络请求
        /// 网络超过vc默认显示时间（可设置），不加载图片
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {

            let url = "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170725165329728.jpg"
            let adDuartion = 4

            /// 设置参数
            adVC.setAdParams(url: url, adDuartion: adDuartion, skipBtnType: .circle, adViewBottomDistance: 0, transitionType: .flipFromTop, adImgViewClick: {

                let vc = UIViewController()
                vc.view.backgroundColor = UIColor.yellow
                homeVC.navigationController?.pushViewController(vc, animated: true)

            })
        })
        window?.rootViewController = adVC
    }
    window?.makeKeyAndVisible()
    return true
}
```
## 安装

* 1.pod 'ZLaunchAdVC'

* 2.pod install / pod update

## CocoaPods更新日志

```
• 2017.08.01(0.0.3):
  1.修复无网络崩溃

• 2017.07.25(0.0.2):
  1.新增GIF图片显示
  2.去除kingfisher
  3.修复过渡动画重复执行
```

## Author

* Email: mqz1228@163.com
* 简 书 : http://www.jianshu.com/u/9e39ec4000e9

## LICENSE

ZLaunchAdVC is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZLaunchAdVC/blob/master/LICENSE) for details.


