Pod::Spec.new do |s|

s.name         = "ZLaunchAdVC"                              
s.version      = "0.0.8"                                   
s.summary      = "集成启动广告,支持LaunchImage和LaunchScreen,支持GIF,支持本地图片,支持视图过渡动画"
s.homepage     = "https://github.com/MQZHot/ZLaunchAdVC"
s.author       = { "mqz" => "mqz1228@163.com" }     
s.platform     = :ios, "8.0"                     
s.source       = { :git => "https://github.com/MQZHot/ZLaunchAdVC.git", :tag => s.version }
s.source_files  = "ZLaunchAdSwift/ZLaunchAd", "ZLaunchAdSwift/ZLaunchAd/*.{swift}"                
s.requires_arc = true
s.license      = "MIT"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.dependency 'SwiftHash', '~> 2.0.0'
end
