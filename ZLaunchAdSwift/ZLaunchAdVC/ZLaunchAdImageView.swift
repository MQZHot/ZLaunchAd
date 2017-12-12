//
//  ZLaunchAdImageView.swift
//  ZLaunchAdSwift
//
//  Created by mengqingzheng on 2017/11/9.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit
import ImageIO
/// 广告图
class ZLaunchAdImageView: UIImageView {
    
    var adImageViewClick: ZLaunchClosure?
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(adImageViewTapAction))
        addGestureRecognizer(tap)
    }
    
    @objc func adImageViewTapAction(_ sender: UITapGestureRecognizer) -> Void {
        if adImageViewClick != nil {
            adImageViewClick!()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZLaunchAdImageView {
    
    func setImage(with url: String, options: ZLaunchAdImageOptions, completion: ZLaunchClosure?) {
        guard let bundleURL = URL(string: url) else { return }
        var cache = false
        switch options {
        case .onlyLoad:
            printLog("----")
        case .readCache:
            if let imageData = getCacheImageWithURL(bundleURL) {
                self.image = ZGIFImage.image(data: imageData)
                if completion != nil { completion!() }
                return
            }
            cache = true
        default:
            cache = true
            if let imageData = getCacheImageWithURL(bundleURL) {
                self.image = ZGIFImage.image(data: imageData)
//                if completion != nil { completion!() }
            }
        }
        image(url: bundleURL, cache: cache, completion: { (image) in
            self.image = image
            if completion != nil { completion!() }
        })
    }
    
    /// 设置Gif图片
    func setGifImage(named name: String, completion: ZLaunchClosure?) {
        DispatchQueue.global().async {
            let image = ZGIFImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
                if image != nil,
                    completion != nil {
                    completion!()
                }
            }
        }
    }
    
    private func image(url: URL, cache: Bool, completion:@escaping (UIImage?)->()) {
        guard let imageData = try? Data(contentsOf: url) else { return }
        if cache {
            saveImage(imageData, url: url, completion: nil)/// 存储
        }
        let image = ZGIFImage.image(data: imageData)
        completion(image)
    }
}
