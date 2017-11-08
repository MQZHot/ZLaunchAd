//
//  ZLaunchAdVC.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/4/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

class ZLaunchAdVC: UIViewController {
    fileprivate var adViewConfig: ZLaunchAdViewConfig = ZLaunchAdViewConfig()
    fileprivate var skipBtnConfig: ZLaunchSkipButtonConfig = ZLaunchSkipButtonConfig()
    fileprivate var waitTime: Int!
    fileprivate var originalTimer: DispatchSourceTimer?
    fileprivate var dataTimer: DispatchSourceTimer?
    fileprivate var adTapAction: ZLaunchClosure?
    fileprivate var rootViewController: UIViewController?
    /// 初始化方法
    convenience init(waitTime: Int = 3, rootVC: UIViewController) {
        self.init()
        if waitTime >= 1 { self.waitTime = waitTime }
        rootViewController = rootVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let launchImageView = ZLaunchImageView(frame: UIScreen.main.bounds)
        view.addSubview(launchImageView)
        startTimer()
    }
    
    fileprivate lazy var launchAdImgView: ZLaunchAdImageView = {
        let imgView = ZLaunchAdImageView(frame: adViewConfig.adFrame)
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
    
    fileprivate lazy var skipBtn: ZLaunchSkipButton = {
        let button = ZLaunchSkipButton(type: .custom)
        button.titleLabel?.numberOfLines = 0;
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func skipBtnClick() {
        launchAdVCRemove()
    }
    
    deinit { print("dealloc") }
}

extension ZLaunchAdVC {
    /// 配置
    @discardableResult
    public func configure(_ config: (inout ZLaunchSkipButtonConfig, inout ZLaunchAdViewConfig) -> Void) -> Self {
        config(&skipBtnConfig, &adViewConfig)
        return self
    }
    /// 加载图片
    public func setImage(_ url: String, duration: Int, options: ZLaunchAdImageOptions = .refreshCache, action: ZLaunchClosure?) {
        view.addSubview(launchAdImgView)
        launchAdImgView.setImage(with: url, options: options) {
            self.setImage(duration: duration, action: action)
        }
    }
    /// 设置本地Gif
    public func setGif(_ name: String, duration: Int, action: ZLaunchClosure?) {
        view.addSubview(launchAdImgView)
        launchAdImgView.setGifImage(named: name) { 
            self.setImage(duration: duration, action: action)
        }
    }
    
    private func setImage(duration: Int, action: ZLaunchClosure?) {
        let adDuration = duration < 1 ? 1 : duration
        adTapAction = action
        skipBtn.setSkipApperance(skipBtnConfig)
        view.addSubview(skipBtn)
        if originalTimer?.isCancelled == true { return }
        adStartTimer(adDuration)
    }
}

// MARK: - ZLaunchAdVC 移除
extension ZLaunchAdVC {
    fileprivate func launchAdVCRemove(completion: ZLaunchClosure? = nil) {
        if originalTimer?.isCancelled == false { originalTimer?.cancel() }
        if dataTimer?.isCancelled == false { dataTimer?.cancel() }
        guard rootViewController != nil else { return }
        ZLaunchAnimation().animationType(adViewConfig.animationType, fromVC: self, toVC: rootViewController!, completion: completion)
    }
}

//MARK: - GCD timer
extension ZLaunchAdVC {
    fileprivate func startTimer() {
        var duration: Int = waitTime
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        originalTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(duration))
        originalTimer?.setEventHandler(handler: {
            printLog("等待加载计时:" + "\(duration)")
            if duration == 0 {
                DispatchQueue.main.async {
                    self.launchAdVCRemove()
                    return
                }
            }
            duration -= 1
        })
        originalTimer?.resume()
    }
    /// 广告倒计时
    fileprivate func adStartTimer(_ duration: Int) {
        if self.originalTimer?.isCancelled == false { self.originalTimer?.cancel() }
        if self.dataTimer?.isCancelled == false { self.dataTimer?.cancel() }
        var adDuration = duration
        dataTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        dataTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(adDuration))
        dataTimer?.setEventHandler(handler: {
            printLog("广告倒计时:" + "\(adDuration)")
            DispatchQueue.main.async {
                self.skipBtn.setDuration(adDuration)
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
