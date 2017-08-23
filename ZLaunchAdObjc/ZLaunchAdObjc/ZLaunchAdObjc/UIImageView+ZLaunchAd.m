//
//  UIImageView+ZLaunchAd.m
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/8/18.
//  Copyright © 2017年 mengqingzheng. All rights reserved.
//

#import "UIImageView+ZLaunchAd.h"
#import <ImageIO/ImageIO.h>

@implementation UIImageView (ZLaunchAd)

- (void)configImageWithUrl: (NSString *)url completion: (ZImageCompletion)completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *bundleUrl = [NSURL URLWithString:url];
        NSData *imageData = [NSData dataWithContentsOfURL:bundleUrl];
        
        UIImage *image = [UIImage gifWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
            if (image && completion) {
                completion();
            }
        });
    });
}

- (void)gifWithName: (NSString *)name completion: (ZImageCompletion)completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [UIImage gifWithName:name];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
            if (image && completion) {
                completion();
            }
        });
    });
}

@end

@implementation UIImage (GIF)

+ (UIImage *)gifWithName: (NSString *)name {
    NSString *nameStr = name;
    if ([name containsString:@".gif"]) {
        nameStr = [name substringToIndex:name.length - 4];
    }
    NSURL *bunleURL = [[NSBundle mainBundle]URLForResource:nameStr withExtension:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfURL: bunleURL];
    return [UIImage gifWithData:imageData];
}

+ (UIImage *)gifWithData:(NSData *)data{
    if (!data) {return nil;}
    CGImageSourceRef imgSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    return [UIImage gifImageWithSource:imgSource];
}

+ (UIImage *)gifImageWithSource: (CGImageSourceRef)imgSource {
    NSInteger totalCount = CGImageSourceGetCount(imgSource);
    if (imgSource == nil) {
        return nil;
    }
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:totalCount];
    CGFloat gifDuration = 0.0;
    for (NSInteger i = 0; i < totalCount; i++) {
        CGImageRef cgImageRef = CGImageSourceCreateImageAtIndex(imgSource, i, NULL);
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imgSource, 1, NULL);
        CFDictionaryRef gifInfo = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        CFStringRef delayTimeRef = CFDictionaryGetValue(gifInfo, kCGImagePropertyGIFDelayTime);
        gifDuration += [(__bridge NSString *)delayTimeRef doubleValue];
        UIImage *image = [UIImage imageWithCGImage:cgImageRef];
        [images addObject:image];
        CFRelease(properties);
        CFRelease(cgImageRef);
    }
    CFRelease(imgSource);
    UIImage *image = [UIImage animatedImageWithImages:images duration:gifDuration];
    return image;
}

@end
