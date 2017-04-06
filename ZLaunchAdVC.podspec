Pod::Spec.new do |s|

s.name         = "ZLaunchAdVC"                              
s.version      = "0.0.2"                                    
s.summary      = "swift快速集成app启动页广告，支持LaunchImage和LaunchScreen.storyboard"
s.homepage     = "https://github.com/MQZHot/ZLaunchAdVC"
s.author       = { "mqz" => "mqz1228@163.com" }     
s.platform     = :ios, "8.0"                     
s.source       = { :git => "https://github.com/MQZHot/ZLaunchAdVC.git", :tag => "0.0.2" }
s.source_files  = "ZLaunchAdDemo/ZLaunchAd", "ZLaunchAdDemo/ZLaunchAd/*.{swift}"                
s.requires_arc = true
s.dependency 'Kingfisher', '~> 3.5.1'
s.license      = "MIT"
s.license      = { :type => "MIT", :file => "LICENSE" }
end