//
//  ZLaunchImageView.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2017/4/5.
//  Copyright © 2017年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAd
//

import UIKit
/// 启动图
class ZLaunchImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = getLaunchImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 获取启动页
extension ZLaunchImageView {
    fileprivate func getLaunchImage() -> UIImage {
        if (assetsLaunchImage() != nil) || (storyboardLaunchImage() != nil) {
            return assetsLaunchImage() == nil ? storyboardLaunchImage()! : assetsLaunchImage()!
        }
        return UIImage()
    }
    
    /// From Assets
    private func assetsLaunchImage() -> UIImage? {
        if let image = assetsLaunchImage("Portrait") { return image }
        if let image = assetsLaunchImage("Landscape") { return image }
        return nil
    }
    private func assetsLaunchImage(_ orientation: String) -> UIImage? {
        let size = UIScreen.main.bounds.size
        guard let launchImages = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else { return nil }
        for dict in launchImages {
            let imageSize = NSCoder.cgSize(for: dict["UILaunchImageSize"] as! String)
            if __CGSizeEqualToSize(imageSize, size) && orientation == (dict["UILaunchImageOrientation"] as! String) {
                let launchImageName = dict["UILaunchImageName"] as! String
                let image = UIImage(named: launchImageName)
                return image
            }
        }
        return nil
    }
    /// Form LaunchScreen.Storyboard
    private func storyboardLaunchImage() -> UIImage? {
        guard let storyboardLaunchName = Bundle.main.infoDictionary?["UILaunchStoryboardName"] as? String,
            let launchVC = UIStoryboard(name: storyboardLaunchName, bundle: nil).instantiateInitialViewController() else {
                return nil
        }
        let view = launchVC.view
        view?.frame = UIScreen.main.bounds
        let image = viewConvertImage(view: view!)
        return image
    }
    
    /// view convert image
    private func viewConvertImage(view: UIView) -> UIImage? {
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

