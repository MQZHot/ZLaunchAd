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
    
    /// load image
    ///
    /// - Parameters:
    ///   - url: url
    ///   - completion: completion
    public func setImage(with url: String, completion: ZClosure?) {
        DispatchQueue.global().async {
            guard let bundleURL = URL(string: url) else { return }
            guard let imageData = try? Data(contentsOf: bundleURL) else { return }
            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else { return
            }
            let totalCount = CGImageSourceGetCount(imageSource)
            var image: UIImage?
            if totalCount == 1 {
                image = UIImage(data: imageData)
            } else {
                image = UIImage.gif(data: imageData)
            }
            DispatchQueue.main.async {
                self.image = image
                if completion != nil {
                    completion!()
                }
            }
        }
    }

    /// set local gif
    ///
    /// - Parameter name: name
    /// - Returns: void
    public func gifImage(named name: String, completion: ZClosure?) -> Swift.Void {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
                if image != nil,
                    completion != nil {
                    completion!()
                }
            }
        }
    }
}

extension UIImage {
    public class func gif(name: String) -> UIImage? {
        var nameStr = name
        if nameStr.contains(".gif") {
            let temp = nameStr as NSString
            nameStr = temp.substring(to: temp.length - 4)
        }
        guard let bundleURL = Bundle.main.url(forResource: nameStr, withExtension: "gif") else { return nil }
        guard let imageData = try? Data(contentsOf: bundleURL) else { return nil }
        return gif(data: imageData)
    }
    
    public class func gif(data: Data) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return gifImageWithSource(imageSource)
    }
    
    private class func gifImageWithSource(_ source: CGImageSource) -> UIImage? {
        let totalCount = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var gifDuration = 0.0
        for i in 0 ..< totalCount {
            if let cfImage = CGImageSourceCreateImageAtIndex(source, i, nil),
                let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil),
                let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) {
                gifDuration += frameDuration.doubleValue
                let image = UIImage(cgImage: cfImage)
                images.append(image)
            }
        }
        let animation = UIImage.animatedImage(with: images, duration: gifDuration)
        return animation
    }
}
