//
//  AppDelegate.m
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/8/18.
//  Copyright © 2017年 mengqingzheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    return YES;
}


@end
