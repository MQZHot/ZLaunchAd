//
//  AppDelegate.m
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/12/20.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ZLaunchAdObjc-Swift.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *homeVC = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    if (launchOptions != nil) {
        self.window.rootViewController = nav;
    } else {
        ZLaunchAdVC *adVC = [[ZLaunchAdVC alloc]initWithWaitTime:4 rootVC:nav];
        // 广告图
        ZLaunchAdViewConfig *adViewConfig = [[ZLaunchAdViewConfig alloc]init];
        adViewConfig.animationType = ZLaunchAnimationTypeCurlUp;
        // 跳过按钮
        ZLaunchSkipButtonConfig *buttonConfig = [[ZLaunchSkipButtonConfig alloc]init];
        buttonConfig.skipBtnType = ZLaunchSkipButtonTypeRoundProgressText;
        [adVC configureWithButtonConfig:buttonConfig adViewConfig: adViewConfig];
        
        [adVC setImage:@"http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170725104352981.jpg" duration:5 options:ZLaunchAdImageOptionsRefreshCache action:^{
            UIViewController *vc = [[UIViewController alloc]init];
            vc.view.backgroundColor = [UIColor greenColor];
            [homeVC.navigationController pushViewController:vc animated:YES];
        }];
        self.window.rootViewController = adVC;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

@end
