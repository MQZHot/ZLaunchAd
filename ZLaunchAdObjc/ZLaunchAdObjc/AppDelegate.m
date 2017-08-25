//
//  AppDelegate.m
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/8/18.
//  Copyright © 2017年 mengqingzheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZLaunchAdVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *homeVC = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    
    if (launchOptions) {
        
        self.window.rootViewController = nav;
        
    } else {
        
        ZLaunchAdVC *launchAdVC = [[ZLaunchAdVC alloc]initWithDuration:4 transitionStyle:TransitionStyleFlipFromTop adBottom:200 rootViewController:nav];
       
        [self networkCompletion:^(NSString *url, NSInteger duration) {
            [launchAdVC configNetImageWithURL:url duration:duration adImgViewClick:^{
                UIViewController *VC = [[UIViewController alloc]init];
                VC.view.backgroundColor = [UIColor redColor];
                [homeVC.navigationController pushViewController:VC animated:YES];
            }];
        }];
        self.window.rootViewController = launchAdVC;
        
//        // 配置本地GIF
//        [launchAdVC configLocalGifWithName:@"321" duration:8 adImgViewClick:^{
//            UIViewController *VC = [[UIViewController alloc]init];
//            VC.view.backgroundColor = [UIColor redColor];
//            [homeVC.navigationController pushViewController:VC animated:YES];
//        }];
//
//        // 配置本地图片
//        [launchAdVC configLocalImageWithImage:[UIImage imageNamed:@"222"] duration:8 adImgViewClick:^{
//            UIViewController *VC = [[UIViewController alloc]init];
//            VC.view.backgroundColor = [UIColor redColor];
//            [homeVC.navigationController pushViewController:VC animated:YES];
//        }];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)networkCompletion: (void(^)(NSString *url, NSInteger duration))completion {
    /// 延时模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170725104352981.jpg
        /// http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif
        NSString *url = @"http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170724152928869.gif";
        NSInteger duration = 6;
        completion(url, duration);
    });
}

@end
