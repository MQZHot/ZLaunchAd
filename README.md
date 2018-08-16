
## ZLaunchAd

 ![image](https://img.shields.io/badge/support-iOS%208%2B-blue.svg)   ![image](https://img.shields.io/cocoapods/v/ZLaunchAd.svg?style=flat)    [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

ZLaunchAd集成启动广告，支持`LaunchImage`和`LaunchScreen`，支持GIF，支持本地图片，支持视图过渡动画


![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic0.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic2.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic3.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic4.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic5.gif) ![image](https://github.com/MQZHot/ZLaunchAd/raw/master/Picture/pic6.gif)

### 功能
- [x] 支持进入前台广告显示，设定时间间隔，进入后台后返回的时间大于间隔才进行显示
- [x] 接收自定义通知控制图片显示
- [x] 支持Objective-C/Swift
- [x] 自带图片缓存，清除缓存
- [x] 自定义跳过按钮外观、位置
- [x] 支持网络/本地资源，支持GIF图片显示
- [x] 支持LaunchImage和LaunchScreen.storyboard.
- [x] 支持广告点击事件，支持广告完成动画设置

### 安装

#### CocoaPods

```ruby
platform :ios, '8.0'
use_frameworks!

target 'YourTargetName' do
pod 'ZLaunchAd'
end
```

#### Carthage

```ogdl
github "MQZHot/ZLaunchAd"
```

### 使用

```swift
/// 进入前台时显示
func create(waitTime: Int = 3, showEnterForeground: Bool = false, timeForWillEnterForeground: Double = 10, adNetRequest: ((ZLaunchAdView)->())? = nil) -> ZLaunchAdView
```
```swift
/// 自定义通知控制出现
func create(waitTime: Int = 3, customNotificationName: String?, adNetRequest: ((ZLaunchAdView)->())? = nil) -> ZLaunchAdView
```
#### 配置图片资源----配置跳过按钮
```swift
func setImageResource(_ imageResource: ZLaunchAdImageResourceConfigure, buttonConfig: ZLaunchSkipButtonConfig? = nil, action: ZLaunchClosure?)
```

#### 页面配置
 * `ZLaunchSkipButtonConfig`：跳过按钮配置
 * `ZLaunchAdImageResourceConfigure`：配置广告图


### 清除缓存
```swift
/// 清除全部缓存
ZLaunchAd.clearDiskCache()

/// 清除指定url的缓存
let array = ["http://..", "http://..", "http://..", "http://.."]
ZLaunchAd.clearDiskCacheWithImageUrlArray(array)
```

### 联系

* Email: mqz1228@163.com

### LICENSE

ZLaunchAd is released under the MIT license. See [LICENSE](https://github.com/MQZHot/ZLaunchAd/blob/master/LICENSE) for details.


