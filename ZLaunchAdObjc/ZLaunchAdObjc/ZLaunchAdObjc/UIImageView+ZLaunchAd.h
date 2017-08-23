//
//  UIImageView+ZLaunchAd.h
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/8/18.
//  Copyright © 2017年 mengqingzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZImageCompletion)();

@interface UIImageView (ZLaunchAd)

/**
 网络图片

 @param url url
 @param completion completion
 */
- (void)configImageWithUrl: (NSString *)url completion: (ZImageCompletion)completion;

/**
 GIF图片

 @param name 图片名
 @param completion completion
 */
- (void)gifWithName: (NSString *)name completion: (ZImageCompletion)completion;

@end

@interface UIImage(GIF)

+ (UIImage *)gifWithName:(NSString *)name;
+ (UIImage *)gifWithData:(NSData *)data;

@end
