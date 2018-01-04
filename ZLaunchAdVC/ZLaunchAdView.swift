//
//  ZLaunchAdView.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2018/1/1.
//  Copyright © 2018年 MQZHot. All rights reserved.
//

import UIKit

protocol ZLaunchAdDelegate {
    func launchAdRequest() -> (ZLaunchAdViewConfig, ZLaunchSkipButtonConfig)
}

public class ZLaunchAdView: UIView {
    
    static var `default` = ZLaunchAdView()
    var waitTime: Int = 3
    var showEnterForeground: Bool = false
    fileprivate var adViewConfig: ZLaunchAdViewConfig = ZLaunchAdViewConfig()
    fileprivate var skipBtnConfig: ZLaunchSkipButtonConfig = ZLaunchSkipButtonConfig()
    fileprivate var originalTimer: DispatchSourceTimer?
    fileprivate var dataTimer: DispatchSourceTimer?
    fileprivate var adTapAction: ZLaunchClosure?
    /// 跳过按钮
    fileprivate lazy var skipBtn: ZLaunchButton = {
        let button = ZLaunchButton(type: .custom)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return button
    }()
    @objc fileprivate func skipBtnClick() {
        launchAdVCRemove()
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let launchImageView = ZLaunchImageView(frame: UIScreen.main.bounds)
        addSubview(launchImageView)
        
        NotificationCenter.default.addObserver(forName: .UIApplicationWillEnterForeground, object: nil, queue: nil) { [unowned self] _ in
            if self.showEnterForeground {
                UIApplication.shared.keyWindow?.addSubview(self)
                self.startTimer()
            }
        }
    }
    
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            startTimer()
        }
    }
    
    @objc func sdsd() {
        
    }
    
    /// 加载网络图片
    ///
    /// - Parameters:
    ///   - url: 图片url
    ///   - duration: 显示秒数
    ///   - options: 缓存方式
    ///   - action: 点击响应事件
    @objc public func setImage(_ url: String, duration: Int, options: ZLaunchAdImageOptions = .readCache, action: ZLaunchClosure?) {
        addSubview(launchAdImgView)
        launchAdImgView.setImage(with: url, options: options) {
            self.setImage(duration: duration, action: action)
        }
    }
    /// 外观配置
    ///
    /// - Parameter config: 跳过按钮配置--广告配置
    /// - Returns: ZLaunchAdVC
    @discardableResult
    public func configure(_ config: ( ZLaunchSkipButtonConfig,  ZLaunchAdViewConfig) -> Void)->Self {
        config(skipBtnConfig, adViewConfig)
        return self
    }
    
    fileprivate func setImage(duration: Int, action: ZLaunchClosure?) {
        let adDuration = duration < 1 ? 1 : duration
        adTapAction = action
        skipBtn.setSkipApperance(skipBtnConfig)
        addSubview(skipBtn)
        if originalTimer?.isCancelled == true { return }
        adStartTimer(adDuration)
    }
    
    fileprivate func launchAdVCRemove(completion: ZLaunchClosure? = nil) {
        if originalTimer?.isCancelled == false { originalTimer?.cancel() }
        if dataTimer?.isCancelled == false { dataTimer?.cancel() }
        ZLaunchAnimation().animationType(adViewConfig.animationType, animationView: self)
        if completion != nil {
            completion!()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("dealloc")
    }
}

extension ZLaunchAdView {
    fileprivate func startTimer() {
        if self.originalTimer?.isCancelled == false { self.originalTimer?.cancel() }
        if self.dataTimer?.isCancelled == false { self.dataTimer?.cancel() }
        var duration: Int = waitTime
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        originalTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(duration))
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
