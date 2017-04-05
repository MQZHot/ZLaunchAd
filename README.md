# ZLaunchAdVC

[![Support](https://img.shields.io/badge/support-iOS%208%2B-brightgreen.svg)](https://github.com/MQZHot/ZLaunchAdVC)
[![Support](https://img.shields.io/badge/support-swift%203%2B-brightgreen.svg)](https://github.com/MQZHot/ZLaunchAdVC)
[![CocoaPods](https://img.shields.io/badge/pod-0.0.1-blue.svg)](http://cocoapods.org/?q=ZLaunchAdVC)&nbsp;

swift快速集成app启动页广告，支持LaunchImage和LaunchScreen.storyboard

1.圆形跳过按钮、倒计时跳过
2.全屏广告、广告距离底部距离设置
3.跳过按钮位置可调： 屏幕右上角、右下角，广告图右下角

![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/gif/1.gif) 
![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/gif/2.gif)
![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/gif/3.gif)
![image](https://github.com/MQZHot/ZLaunchAdVC/raw/master/gif/4.gif)

使用
==============
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

window = UIWindow.init(frame: UIScreen.main.bounds)
window?.backgroundColor = UIColor.white
let homeVC = ViewController()
let nav = UINavigationController.init(rootViewController: homeVC)
if launchOptions != nil {
/// 推送等启动时设置
window?.rootViewController = nav
} else {
/// 设置跳过按钮的位置，距离底部的距离
let adVC = ZLaunchAdVC.init(skipBtnPosition: .rightBottom, setAdParams: { (advc) in

/// 设置图片，等待时间，过度效果等
advc.setAdImgView(url: "http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170331202849335.png", adDuartion: 6, adImgViewClick: {

/// 广告点击
let vc = UIViewController()
vc.view.backgroundColor = UIColor.green
homeVC.navigationController?.pushViewController(vc, animated: true)

}, completion: {
/// 切换跟视图
self.window?.rootViewController = nav
})
})
window?.rootViewController = adVC
}
window?.makeKeyAndVisible()
return true
}
```
安装
==============
1.pod 'ZLaunchAdVC'

2.pod install / pod update
