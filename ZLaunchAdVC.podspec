Pod::Spec.new do |s|

s.name         = "ZLaunchAdVC"                              
s.version      = "0.0.4"                                   
s.summary      = "集成app启动页广告，切换rootViewController，支持LaunchImage和LaunchScreen.storyboard，支持GIF图片显示，支持视图过渡动画"
s.homepage     = "https://github.com/MQZHot/ZLaunchAdVC"
s.author       = { "mqz" => "mqz1228@163.com" }     
s.platform     = :ios, "8.0"                     
s.source       = { :git => "https://github.com/MQZHot/ZLaunchAdVC.git", :tag => "0.0.4" }
s.source_files  = "ZLaunchAdDemo/ZLaunchAd", "ZLaunchAdDemo/ZLaunchAd/*.{swift}"                
s.requires_arc = true
s.license      = "MIT"
s.license      = { :type => "MIT", :file => "LICENSE" }
end
