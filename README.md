

![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/ZLaunchAdVC.png)

![](https://img.shields.io/badge/platform-iOS-yellow.svg) ![](https://img.shields.io/badge/language-swift-red.svg) ![](https://img.shields.io/badge/support-swift%204%2B-red.svg) ![](https://img.shields.io/badge/support-iOS%208%2B-blue.svg) ![](https://img.shields.io/cocoapods/v/ZLaunchAdVC.svg?style=flat) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)

> ### 使用view制作启动页广告，总存在一些问题
> * 启动图出现之前总是会先闪出rootViewController，再出现广告图
> * 首页需要弹出一些视图：版本更新、弹窗广告、新手引导等，层级关系复杂。

## ZLaunchAdVC 快速集成启动页广告，切换rootViewController，支持LaunchImage和LaunchScreen.storyboard，支持GIF图片，支持视图过渡动画，支持本地图片

### 不足之处，欢迎纠正，欢迎star✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨


![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic0.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic2.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic3.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic4.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic5.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic6.gif)

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
        let adVC = ZLaunchAdVC().waitTime(3).adBottom(200).transition(.rippleEffect).rootVC(nav)
        request {
            adVC.configNetImage(url: $0, duration: $1, adImgViewClick: {
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

### 2. 广告配置

```swift

/// 等待加载时间
func waitTime(_ waitTime: Int) -> Self
/// 跳转时是否显示rootVC
func showRootAfterClick(_ showRootAfterClick: Bool) -> Self
/// 配置跳过按钮
func configSkipBtn(_ config: (inout SkipBtnModel) -> Void) -> ZLaunchAdVC
/// 设置广告图底部距离
func adBottom(_ adViewBottom: CGFloat) -> Self
/// 控制器过渡类型
func transition(_ transitionType: TransitionType) -> Self
/// app的rootVC
func rootVC(_ rootViewController: UIViewController) -> Self

let adVC = ZLaunchAdVC().waitTime(3).adBottom(200).transition(.rippleEffect).rootVC(nav)
adVC.configSkipBtn({ (config) in
    config.backgroundColor = UIColor.red
    config.centerX = 100
    config.centerY = 200
    config.skipBtnType = .circle
    config.strokeColor = UIColor.green
})

```

### 3. 加载图片
```swift
let url = "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif"
adVC.setImage(url, duration: 5, action: {
    /// do something
})

```
### 4. 加载本地图片

#### 4.1 本地图片
```swift

adVC.setImage(UIImage(named: "222"), duration: 7, action: {
    /// do something
})

```
#### 4.2 本地GIF
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
| date | version | content |
|:---:|:---:|:---|
|2017.09.16|0.0.7|支持swift4|
|2017.08.18|0.0.5|1.修复倒计时时间不变<br>2.新增本地图片显示，支持GIF<br>3.增加跳过按钮配置<br>4.代码整理|
|2017.08.01|0.0.3|1.修复无网络崩溃|
|2017.07.25|0.0.2|1.新增GIF图片显示<br>2.去除kingfisher<br>3.修复过渡动画重复执行|

## Author

* Email: mqz1228@163.com
* 简 书 : http://www.jianshu.com/u/9e39ec4000e9

## LICENSE

ZLaunchAdVC is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZLaunchAdVC/blob/master/LICENSE) for details.


