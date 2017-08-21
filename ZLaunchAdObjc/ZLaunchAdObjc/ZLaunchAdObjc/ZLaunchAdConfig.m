//
//  ZLaunchAdConfig.m
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/8/21.
//  Copyright © 2017年 mengqingzheng. All rights reserved.
//

#import "ZLaunchAdConfig.h"

@implementation ZLaunchAdConfig

-(instancetype)init {
    self = [super init];
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.4];
        self.titleFont = [UIFont systemFontOfSize:12];
        self.cornerRadius = 15;
        self.titleColor = [UIColor whiteColor];
        self.skipBtnType = SkipBtnTypeTimer;
        self.strokeColor = [UIColor redColor];
        self.lineWidth = 2;
        self.width = 60;
        self.centerX = Z_SCREEN_WIDTH - 40;
        self.height = 30;
        self.centerY = 45;
    }
    return self;
}


@end
