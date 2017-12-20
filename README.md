
## ZLaunchAdVC

![image](https://travis-ci.org/MQZHot/ZLaunchAdVC.svg?branch=master)   ![image](https://img.shields.io/badge/support-swift%204-green.svg)  ![image](https://img.shields.io/badge/support-iOS%208%2B-blue.svg)  ![image](https://img.shields.io/cocoapods/v/ZLaunchAdVC.svg?style=flat)

ZLaunchAdVC集成启动广告，支持`LaunchImage`和`LaunchScreen`，支持GIF，支持本地图片，支持视图过渡动画，使用`viewController`做启动页广告，通过切换`rootViewController`，避免闪出首页控制器，避免处理复杂的层级关系

![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic0.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic2.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic3.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic4.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic5.gif) ![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/Picture/pic6.gif)

### 功能
- [x] 支持Objective-C/Swift
- [x] 自带图片缓存，清除缓存
- [x] 自定义跳过按钮外观、位置
- [x] 支持网络/本地资源，支持GIF图片显示
- [x] 支持LaunchImage和LaunchScreen.storyboard.
- [x] 状态栏颜色设置同Deployment Info一致
- [x] 支持广告点击事件，支持广告完成动画设置

### 使用
* `didFinishLaunchingWithOptions`中设置`ZLaunchAdVC`为`rootViewController`，指定广告完成后展示的控制器，并配置广告的参数使用
* 每次广告展示的配置可以统一，也可以通过网络数据配置，如按钮外观、图片大小、完成动画等
* 通过推送、DeepLink等启动时，是否需要展示广告也可以灵活配置
```swift
/// 加载广告
let adVC = ZLaunchAdVC(waitTime: 4,rootVC: nav)
request { model in
    adVC.configure { button, adView in
        button.skipBtnType = model.skipBtnType
        adView.animationType = model.animationType
        adView.adFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_WIDTH*model.height/model.width)
    }
    adVC.setImage(model.imgUrl, duration: model.duration, options: .readCache, action: {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.yellow
        homeVC.navigationController?.pushViewController(vc, animated: true)
    })
}
window?.rootViewController = adVC
```
 ### 页面配置
 * 通过`configure`方法配置广告参数，`configure`为闭包
 * 闭包参数1：跳过按钮配置
 ```swift
 /// 按钮位置
 var frame = CGRect(x: Z_SCREEN_WIDTH - 70,y: 42, width: 60,height: 30)
 /// 背景颜色
 var backgroundColor = UIColor.black.withAlphaComponent(0.4)
 /// 文字
 var text: NSString = "跳过"
 /// 字体大小
 var textFont = UIFont.systemFont(ofSize: 14)
 /// 字体颜色
 var textColor = UIColor.white
 /// 数字大小
 var timeFont = UIFont.systemFont(ofSize: 15)
 /// 数字颜色
 var timeColor = UIColor.red
 /// 跳过按钮类型
 var skipBtnType: ZLaunchSkipButtonType = .textLeftTimerRight
 /// 圆形进度颜色
 var strokeColor = UIColor.red
 /// 圆形进度宽度
 var lineWidth: CGFloat = 2
 /// 圆角
 var cornerRadius: CGFloat = 5
 /// 边框颜色
 var borderColor: UIColor = UIColor.clear
 /// 边框宽度
 var borderWidth: CGFloat = 1
 ```
 * 闭包参数2：配置广告图
```swift
/// 广告图大小
var adFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_HEIGHT-100)
/// 过渡动画
var animationType: ZLaunchAnimationType = .crossDissolve
```
### 加载图片
 * 加载网络图片
```swift
let url = "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif"
adVC.setImage(url, duration: 5, options: .readCache, action: {
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

### 清除缓存
```swift
/// 清除全部缓存
ZLaunchAdVC.clearDiskCache()

/// 清除指定url的缓存
let array = ["http://..", "http://..", "http://..", "http://.."]
ZLaunchAdVC.clearDiskCacheWithImageUrlArray(array)
```

### 依赖

* 使用 [SwiftHash](https://github.com/onmyway133/SwiftHash)进行md5加密

### 安装

* 1.pod 'ZLaunchAdVC'

* 2.pod install / pod update

### 联系

* Email: mqz1228@163.com

### LICENSE

ZLaunchAdVC is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZLaunchAdVC/blob/master/LICENSE) for details.


