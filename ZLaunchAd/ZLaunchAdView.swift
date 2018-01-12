//
//  ZLaunchAdView.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2018/1/1.
//  Copyright © 2018年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAdVC
//

import UIKit

public class ZLaunchAdView: UIView {
    
// MARK: - API
    
    /// 加载图片，网络图片/本地图片/GIF图片
    ///
    /// - Parameters:
    ///   - imageResource: 配置图片资源
    ///   - buttonConfig:  配置跳过按钮
    ///   - action: 广告点击响应
    @objc
    public func setImageResource(_ imageResource: ZLaunchAdImageResourceConfigure, buttonConfig: ZLaunchSkipButtonConfig? = nil, action: ZLaunchClosure?) {
        if let buttonConfig = buttonConfig { skipBtnConfig = buttonConfig }
        self.imageResource = imageResource
        adTapAction = action
        addAdImageView()
    }
    
    
    
// MARK: - private
    static var `default` = ZLaunchAdView(frame: UIScreen.main.bounds, showEnterForeground: true)
    var adRequest: ((ZLaunchAdView)->())?
    var waitTime: Int = 3
    fileprivate var skipBtnConfig: ZLaunchSkipButtonConfig = ZLaunchSkipButtonConfig()
    fileprivate var originalTimer: DispatchSourceTimer?
    fileprivate var dataTimer: DispatchSourceTimer?
    fileprivate var adTapAction: ZLaunchClosure?
    fileprivate var imageResource: ZLaunchAdImageResourceConfigure?
    fileprivate var skipBtn: ZLaunchAdButton?
    /// 广告图
    fileprivate lazy var launchAdImgView: ZLaunchAdImageView = {
        let imgView = ZLaunchAdImageView(frame: .zero)
        imgView.adImageViewClick = { [weak self] in
            self?.launchAdTapAction()
        }
        return imgView
    }()
    fileprivate func launchAdTapAction() {
        launchAdVCRemove() {
            if self.adTapAction != nil { self.adTapAction!() }
        }
    }
    init(frame: CGRect, showEnterForeground: Bool) {
        super.init(frame: frame)
        let launchImageView = ZLaunchImageView(frame: UIScreen.main.bounds)
        addSubview(launchImageView)
        if showEnterForeground {
            NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil) { _ in
                UIApplication.shared.keyWindow?.addSubview(self)
                self.startTimer()
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            frame = UIScreen.main.bounds
            startTimer()
            if adRequest != nil {
                adRequest!(self)
            } else {
                addAdImageView()
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("dealloc")
    }
}

// MARK: - setup subview
extension ZLaunchAdView {
    fileprivate func addAdImageView() {
        guard let imageResource = imageResource,
            let imageNameOrImageURL = imageResource.imageNameOrImageURL else { return }
        launchAdImgView.frame = imageResource.imageFrame
        addSubview(launchAdImgView)
        if imageNameOrImageURL.contains("http://") || imageNameOrImageURL.contains("https://") {
            launchAdImgView.setImage(with: imageNameOrImageURL, options: imageResource.imageOptions) {
                self.setImage(duration: imageResource.imageDuration)
            }
        } else if imageNameOrImageURL.contains(".gif") {
            launchAdImgView.setGifImage(named: imageNameOrImageURL) {
                self.setImage(duration: imageResource.imageDuration)
            }
        } else {
            launchAdImgView.image = UIImage(named: imageNameOrImageURL)
            setImage(duration: imageResource.imageDuration)
        }
    }
    fileprivate func setImage(duration: Int) {
        let adDuration = max(1, duration)
        skipBtn = ZLaunchAdButton(type: .custom)
        skipBtn?.titleLabel?.textAlignment = .center
        skipBtn?.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        skipBtn?.setSkipApperance(skipBtnConfig)
        addSubview(skipBtn!)
        if originalTimer?.isCancelled == true { return }
        adStartTimer(adDuration)
    }
    @objc fileprivate func skipBtnClick() {
        launchAdVCRemove()
    }
}
// MARK: - remove
extension ZLaunchAdView {
    fileprivate func launchAdVCRemove(completion: ZLaunchClosure? = nil) {
        if originalTimer?.isCancelled == false { originalTimer?.cancel() }
        if dataTimer?.isCancelled == false { dataTimer?.cancel() }
        ZLaunchAdAnimation().animationType(imageResource?.animationType ?? .crossDissolve, animationView: self, animationClosure: {
            for (index, view) in self.subviews.enumerated() {
                if index != 0 {
                    view.removeFromSuperview()
                }
            }
            self.skipBtn = nil
            self.removeFromSuperview()
        })
        if completion != nil {
            completion!()
        }
    }
}

// MARK: - GCD
extension ZLaunchAdView {
    fileprivate func startTimer() {
        var duration: Int = waitTime
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:.global())
        originalTimer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(duration))
        originalTimer?.setEventHandler(handler: {
            printLog("等待加载计时:" + "\(duration)")
            if duration == 0 {
                DispatchQueue.main.async {
                    self.launchAdVCRemove()
                }
                return
            }
            duration -= 1
        })
        originalTimer?.resume()
    }
    fileprivate func adStartTimer(_ duration: Int) {
        var adDuration = duration
        dataTimer = DispatchSource.makeTimerSource(flags: [], queue:.global())
        dataTimer?.schedule(deadline: .now(), repeating: .seconds(1), leeway: .milliseconds(adDuration))
        dataTimer?.setEventHandler(handler: {
            printLog("广告倒计时:" + "\(adDuration)")
            DispatchQueue.main.async {
                if self.originalTimer?.isCancelled == false {
                    self.originalTimer?.cancel()
                }
                self.skipBtn?.setDuration(adDuration)
                if adDuration == 0 {
                    self.launchAdVCRemove()
                    return
                }
                adDuration -= 1
            }
        })
        dataTimer?.resume()
    }
}
