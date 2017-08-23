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

@property (nonatomic, strong) UIColor *backgroundColor;     /// 背景颜色
@property (nonatomic, strong) UIFont *titleFont;            /// 字体大小
@property (nonatomic, assign) SkipBtnType skipBtnType;      /// btn类型
@property (nonatomic, strong) UIColor *titleColor;          /// 字体颜色
@property (nonatomic, strong) UIColor *strokeColor;         /// 圆形按钮进度条颜色
@property (nonatomic, assign) CGFloat cornerRadius;         /// 
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
