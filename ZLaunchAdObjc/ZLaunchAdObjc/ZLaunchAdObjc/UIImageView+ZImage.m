//
//  UIImageView+ZImage.m
//  ZLaunchAdObjc
//
//  Created by mengqingzheng on 2017/8/18.
//  Copyright © 2017年 mengqingzheng. All rights reserved.
//

#import "UIImageView+ZImage.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIImageView (ZImage)

- (void)configImageWithUrl: (NSString *)url completion: (ZImageCompletion)completion {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *bundleUrl = [NSURL URLWithString:url];
        NSData *imageData = [NSData dataWithContentsOfURL:bundleUrl];
        
        UIImage *image = [UIImage gifWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
            if (completion) {
                completion(image);
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
    
    UIImage *gifImage;
    CGImageSourceRef imgSource = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    if (imgSource == NULL) {
        fprintf(stderr, "Image source is NULL\n");
    } else {
        
        NSInteger totalCount = CGImageSourceGetCount(imgSource);
        
        if (totalCount > 1) {
            
            NSMutableArray *frames = [NSMutableArray arrayWithCapacity:totalCount];
            NSTimeInterval gifDuration = 0.0;
            for (NSInteger i = 0; i < totalCount; i++) {
                
                CGImageRef cgImageRef = CGImageSourceCreateImageAtIndex(imgSource, i, NULL);
                CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imgSource, 1, NULL);
                CFDictionaryRef gifDic = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
                CFStringRef delayTimeRef = CFDictionaryGetValue(gifDic, kCGImagePropertyGIFDelayTime);
                gifDuration += [(__bridge NSString *)delayTimeRef doubleValue];
                CFRelease(properties);
                UIImage *image = [UIImage imageWithCGImage:cgImageRef];
                [frames addObject:image];
                
            }
            gifImage = [UIImage animatedImageWithImages:frames duration:gifDuration];
        } else if (totalCount == 1) {
            gifImage = [[UIImage alloc] initWithData:data];
        }
        CFRelease(imgSource);
    }
    return gifImage;
}

@end
