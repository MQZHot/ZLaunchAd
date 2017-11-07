<p align="center">
<img src="https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/ZLaunchAdVC.png" alt="ZLaunchAdVC" title="ZLaunchAdVC" width="408"/>
</p>

<p align="center">
<img src="https://img.shields.io/badge/platform-iOS-yellow.svg">
<img src="https://img.shields.io/badge/language-swift-red.svg">
<img src="https://img.shields.io/badge/support-swift%204%2B-green.svg">
<img src="https://img.shields.io/badge/support-iOS%208%2B-blue.svg">
<img src="https://img.shields.io/badge/license-MIT%20License-brightgreen.svg">
<img src="https://img.shields.io/cocoapods/v/ZLaunchAdVC.svg?style=flat">
</p>


 * ZLaunchAdVC使用viewController做启动页广告，通过切换rootViewController，避免闪出首页控制器，避免处理复杂的层级关系
 * 如有问题，欢迎提出，不足之处，欢迎纠正，欢迎star ✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨


![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic0.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic2.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic3.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic4.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic5.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic6.gif)

## 功能

- [x] 支持自定义跳过按钮
- [x] 支持网络/本地资源，支持GIF图片显示
- [x] 支持LaunchImage和LaunchScreen.storyboard.
- [x] 支持状态栏颜色设置、显示与隐藏
- [x] 支持广告点击事件
- [x] 支持广告完成动画设置

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
        /// 正常点击icon启动
        let adVC = ZLaunchAdVC().waitTime(3).adBottom(200).animationType(.flipFromLeft).rootVC(nav).configSkipButton {
            $0.skipBtnType = .text
            $0.borderColor = UIColor.green
        }
        request {
            adVC.setImage($0, duration: $1, action: {
                /// do something...
            })
        }
        window?.rootViewController = adVC
    }
    window?.makeKeyAndVisible()
    return true
}
/// 网络请求
func request(_ completion: @escaping (_ url: String, _ duration: Int)->()) -> Void {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
        let url = "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif"
        let adDuartion = 8
        completion(url, adDuartion)
    })
}
```

 * 设置等待时间，默认3s
```swift
adVC.waitTime(5)
```
 
 * 设置广告图底部距离，默认100
 ```swift
adVC.adBottom(200)
```

* 设置广告展示完成动画，默认溶解消失`.crossDissolve`
```swift
adVC.animationType(.flipFromLeft)
```

* 设置广告展示完成需要展示的控制器
```swift
adVC.rootVC(nav)
```

 * 设置跳过按钮外观
 ```swift
adVC.configSkipButton {
    $0.skipBtnType = .text
    $0.borderColor = UIColor.green
}
```

 * 加载网络图片
```swift
let url = "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif"
adVC.setImage(url, duration: 5, action: {
    /// do something
})

```

 * 设置本地图片
```swift
adVC.setImage(UIImage(named: "222"), duration: 7, action: {
    /// do something
})

```
 * 设置本地GIF
```swift
adVC.setGif("111", duration: 7, action: {
    /// do something
})
```

## Install
```
1.pod 'ZLaunchAdVC'

2.pod install / pod update
```
## CocoaPods
| version | content |
|:---:|:---|
|0.0.7|支持swift4|
|0.0.5|1.修复倒计时时间不变<br>2.新增本地图片显示，支持GIF<br>3.增加跳过按钮配置|
|0.0.3|1.修复无网络崩溃|
|0.0.2|1.新增GIF图片显示<br>2.去除kingfisher<br>3.修复过渡动画重复执行|

## Author

* Email: mqz1228@163.com
* 简 书 : http://www.jianshu.com/u/9e39ec4000e9

## LICENSE

ZLaunchAdVC is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZLaunchAdVC/blob/master/LICENSE) for details.


