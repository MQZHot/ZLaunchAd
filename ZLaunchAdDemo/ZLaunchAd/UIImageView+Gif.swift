//
//  UIImageView+Gif.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/7/24.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit
import ImageIO

extension UIImageView {
    
    func setImage(with url: String,
                     completion: (()->())?) {
        
        DispatchQueue.global().async {
            
            guard let data = try? Data.init(contentsOf: URL.init(string: url)!) else {
                return
            }
            
            guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
                return
            }
            
            /// 图片帧数
            let totalCount = CGImageSourceGetCount(imageSource)
            
            var images = [UIImage]()
            
            var gifDuration = 0.0
            
            for i in 0 ..< totalCount {
                
                // 获取对应帧的 CGImage
                guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {
                    return
                }
                
                if totalCount == 1 {
                    /// 单张图片
                    gifDuration = Double.infinity
                    guard let imageData = try? Data.init(contentsOf: URL.init(string: url)!),
                        let image = UIImage.init(data: imageData) else {
                            return
                    }
                    images.append(image)
                    
                } else{
                    /// gif
                    guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil),
                        let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                        let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else {
                            return
                    }
                    
                    gifDuration += frameDuration.doubleValue
                    // 获取帧的img
                    let image = UIImage.init(cgImage: imageRef, scale: UIScreen.main.scale, orientation: UIImageOrientation.up)
                    
                    images.append(image)
                }
            }
            
            DispatchQueue.main.async {
                
                self.animationImages = images
                self.animationDuration = gifDuration
                self.animationRepeatCount = 0
                self.startAnimating()
                
                if completion != nil {
                    completion!()
                }
            }
        }
    }

    
}
