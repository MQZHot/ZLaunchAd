
## ZLaunchAd

![image](https://travis-ci.org/MQZHot/ZLaunchAd.svg?branch=master)   ![image](https://img.shields.io/badge/support-swift%204-green.svg)  ![image](https://img.shields.io/badge/support-iOS%208%2B-blue.svg)  ![image](https://img.shields.io/cocoapods/v/ZLaunchAd.svg?style=flat)

ZLaunchAd集成启动广告，支持`LaunchImage`和`LaunchScreen`，支持GIF，支持本地图片，支持视图过渡动画
***ZLaunchAdVC替换为ZLaunchAd***
![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic0.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic2.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic3.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic4.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic5.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic6.gif)

### 功能
- [x] 支持进入前台广告显示
- [x] 支持Objective-C/Swift
- [x] 自带图片缓存，清除缓存
- [x] 自定义跳过按钮外观、位置
- [x] 支持网络/本地资源，支持GIF图片显示
- [x] 支持LaunchImage和LaunchScreen.storyboard.
- [x] 支持广告点击事件，支持广告完成动画设置

### 使用
```swift
let adView = ZLaunchAd.create()
let imageResource = ZLaunchAdImageResourceConfigure()
imageResource.imageNameOrImageURL = "163yun"
imageResource.imageDuration = 5
imageResource.imageFrame = UIScreen.main.bounds
adView.setImageResource(imageResource, action: {
    /// 广告点击
})
```

### 创建广告View
```swift
/// 创建广告View
///
/// - Parameters:
///   - waitTime: 加载广告等待的时间，默认3s
///   - showEnterForeground: 是否进入前台时显示，默认`false`
///   - adNetRequest: 广告网络请求。如果需要每次进入前台是显示不同的广告图片，网络请求写在此闭包中
/// - Returns: ZLaunchAdView
func create(waitTime: Int = 3, showEnterForeground: Bool = false, adNetRequest: ((ZLaunchAdView)->())? = nil) -> ZLaunchAdView
```

### 设置图片
```swift
/// 加载图片，网络图片/本地图片/GIF图片
///
/// - Parameters:
///   - imageResource: 配置图片资源
///   - buttonConfig:  配置跳过按钮
///   - action: 广告点击响应
func setImageResource(_ imageResource: ZLaunchAdImageResourceConfigure, buttonConfig: ZLaunchSkipButtonConfig? = nil, action: ZLaunchClosure?)
```

 ### 页面配置
 * `ZLaunchSkipButtonConfig`：跳过按钮配置
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
 * `ZLaunchAdImageResourceConfigure`：配置广告图
```swift
/// image本地图片名(jpg/gif图片请带上扩展名)或网络图片URL
var imageNameOrImageURL: String?
/// 广告显示时间
var imageDuration: Int = 3
/// 图片缓存策略
var imageOptions: ZLaunchAdImageOptions = .readCache
/// 广告图大小
var imageFrame = CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: Z_SCREEN_HEIGHT-100)
/// 过渡动画
var animationType: ZLaunchAnimationType = .crossDissolve
```

### 清除缓存
```swift
/// 清除全部缓存
ZLaunchAd.clearDiskCache()

/// 清除指定url的缓存
let array = ["http://..", "http://..", "http://..", "http://.."]
ZLaunchAd.clearDiskCacheWithImageUrlArray(array)
```

### 依赖

* 使用 [SwiftHash](https://github.com/onmyway133/SwiftHash)进行md5加密

### 安装

* 1.pod 'ZLaunchAd'

* 2.pod install / pod update

* 3.如果使用`ZLaunchAdVC`，pod 'ZLaunchAdVC'


### 联系

* Email: mqz1228@163.com

### LICENSE

ZLaunchAd is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZLaunchAd/blob/master/LICENSE) for details.


