

![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/ZLaunchAdVC.png)

![](https://img.shields.io/badge/platform-iOS-yellow.svg) ![](https://img.shields.io/badge/language-swift-red.svg) ![](https://img.shields.io/badge/support-iOS%208%2B-blue.svg) ![](https://img.shields.io/cocoapods/v/ZLaunchAdVC.svg?style=flat) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)


## 快速集成启动页广告，切换rootViewController，支持LaunchImage和LaunchScreen.storyboard，支持GIF图片显示，支持视图过渡动画，支持本地图片显示

### 不足之处，欢迎纠正，欢迎star✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨


![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic1.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic2.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic3.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic4.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic5.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic6.gif)

## 功能

- [x] 圆形进度跳过、倒计时跳过
- [x] 广告图大小设置
- [x] 自定义跳过按钮，自定义位置、大小、颜色。。。
- [x] 支持状态栏颜色设置、显示与隐藏
- [x] 支持本地图片显示
- [x] 支持GIF图片显示

## 使用

### 1.基本使用
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
        /// 正常点击icon启动，加载广告
        let adVC = ZLaunchAdVC(completion: {
            self.window?.rootViewController = nav
        })
        /// 延时模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
            let url = "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170725165329728.jpg"
            let duration = 4
            /// 设置参数
            adVC.configNetImage(url: url, duration: duration, adImgViewClick: {
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

### 2. 默认显示时间、广告图大小、过渡类型 配置

```swift
/// defaultDuration: 未设置广告/广告加载不出来时，VC的显示时间，默认3s
/// adViewBottom: 图片距离底部距离，默认100
/// transitionType: 过渡类型，默认fade
let adVC = ZLaunchAdVC(defaultDuration: 3, adViewBottom: 100, transitionType: .filpFromLeft, completion: {
    self.window?.rootViewController = nav
})

/// 或者
let adVC = ZLaunchAdVC().adBottom(200).transition(.filpFromLeft).configEnd({
    self.window?.rootViewController = nav
})

```

### 3. 跳过按钮配置

```swift
adVC.configSkipBtn({ (config) in
    config.backgroundColor = UIColor.red
    config.centerX = 100
    config.centerY = 200
    config.skipBtnType = .circle
    config.strokeColor = UIColor.green
})

```
### 4. 加载本地图片

#### 4.1 本地图片
```swift

adVC.configLocalImage(image: UIImage(named: "222"), duration: 7, adImgViewClick: {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor.yellow
    homeVC.navigationController?.pushViewController(vc, animated: true)
})

```
#### 4.2 本地GIF
```swift
adVC.configLocalGif(name: "111", duration: 7, adImgViewClick: {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor.yellow
    homeVC.navigationController?.pushViewController(vc, animated: true)
})
```

## 安装

* 1.pod 'ZLaunchAdVC'

* 2.pod install / pod update

## CocoaPods更新日志

```
• 2017.08.18(0.0.5):
  1.修复倒计时时间不变
  2.新增本地图片显示，支持GIF
  3.增加跳过按钮配置
  4.代码整理

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


