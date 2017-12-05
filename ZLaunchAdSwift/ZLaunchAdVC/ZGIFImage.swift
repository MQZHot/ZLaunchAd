//
//  ZGIFImage.swift
//  ZGIFImage
//
//  Created by mengqingzheng on 2017/11/9.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit
import ImageIO

public class ZGIFImage {
    
    /// set image with name
    ///
    /// - Parameter name: image name
    /// - Returns: UIImage
    public class func image(name: String) -> UIImage? {
        return UIImage(named: name)
    }
    
    /// load image with url , also gif url
    ///
    /// - Parameter url: image url
    /// - Returns: UIImage
    public class func image(url: URL) -> UIImage? {
        guard let imageData = try? Data(contentsOf: url) else { return nil }
        let image = ZGIFImage.image(data: imageData)
        return image
    }
    
    /// set image with data
    ///
    /// - Parameter data: image data
    /// - Returns: UIImage
    public class func image(data: Data) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let totalCount = CGImageSourceGetCount(imageSource)
        var image: UIImage?
        if totalCount == 1 {
            image = UIImage(data: data)
        } else {
            image = ZGIFImage.gif(data: data)
        }
        return image
    }
    
    /// load GIF
    ///
    /// - Parameter name: gif's name, include `.gif` or not
    /// - Returns: UIImage
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
    
    /// load GIF with Data
    ///
    /// - Parameter data: data
    /// - Returns: UIImage
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
