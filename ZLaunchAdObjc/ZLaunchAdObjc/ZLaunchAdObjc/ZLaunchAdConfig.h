//
//  ZLaunchAdConfig.h
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/8/21.
//  Copyright © 2017年 mengqingzheng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Z_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define Z_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSUInteger, SkipBtnType) {
    SkipBtnTypeNone = 0,                /** 无跳过 */
    SkipBtnTypeTimer,                   /** 跳过+倒计时 */
    SkipBtnTypeCircle,                  /** 动画跳过 */
};

@interface ZLaunchAdConfig : NSObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) SkipBtnType skipBtnType;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
