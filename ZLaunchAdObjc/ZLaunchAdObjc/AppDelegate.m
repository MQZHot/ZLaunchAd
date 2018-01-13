//
//  AppDelegate.m
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2018/1/12.
//  Copyright © 2018年 北京聚集科技有限公司. All rights reserved.
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
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    ZLaunchAdView *launchAdView = [ZLaunchAd createWithWaitTime:3 showEnterForeground:YES adNetRequest:nil];
    
    ZLaunchAdImageResourceConfigure *imageResource = [[ZLaunchAdImageResourceConfigure alloc]init];
    imageResource.imageNameOrImageURL =@"http://chatm-icon.oss-cn-beijing.aliyuncs.com/pic/pic_20170725104352981.jpg";
    imageResource.imageDuration = 5;
    imageResource.animationType = ZLaunchAnimationTypeFlipFromLeft;
    [launchAdView setImageResource:imageResource buttonConfig:nil action:^{
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor greenColor];
        [homeVC.navigationController pushViewController:vc animated:YES];
    }];
    
    return YES;
}

@end
