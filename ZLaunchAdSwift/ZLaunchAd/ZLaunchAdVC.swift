//
//  ZLaunchAdVC.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/4/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

protocol ZLaunchAPI {
    /// 设置等待时间
    func waitTime(_ waitTime: Int) -> ZLaunchAdVC
    /// 设置跳过外观
    func configSkipButton(_ config: (inout ZLaunchSkipButtonConfig) -> Void) -> ZLaunchAdVC
    /// 设置广告图底部距离
    func adBottom(_ adViewBottom: CGFloat) -> ZLaunchAdVC
    /// 过渡类型
    func animationType(_ animationType: ZLaunchAnimationType) -> ZLaunchAdVC
    /// rootVC
    func rootVC(_ rootViewController: UIViewController) -> ZLaunchAdVC
    /// 加载图片
    func setImage(_ url: String, duration: Int, action: ZLaunchClosure?)
    /// 本地图片
    func setImage(_ image: UIImage?, duration: Int, action: ZLaunchClosure?)
    /// 本地GIF
    func setGif(_ name: String, duration: Int, action: ZLaunchClosure?)
}

class ZLaunchAdVC: UIViewController {
    
    fileprivate var skipBtnConfig: ZLaunchSkipButtonConfig = ZLaunchSkipButtonConfig()
    fileprivate var waitTime = 3
    fileprivate var adViewBottom: CGFloat = 100
    fileprivate var animationType: ZLaunchAnimationType = .crossDissolve
    fileprivate var originalTimer: DispatchSourceTimer?
    fileprivate var dataTimer: DispatchSourceTimer?
    fileprivate var adTapAction: ZLaunchClosure?
    fileprivate var rootViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let launchImageView = ZLaunchImageView(frame: UIScreen.main.bounds)
        view.addSubview(launchImageView)
        startTimer()
    }
    
    override var shouldAutorotate: Bool { return false }
    
    fileprivate lazy var launchAdImgView: ZLaunchAdImageView = {
        let height = Z_SCREEN_HEIGHT - self.adViewBottom
        let imgView = ZLaunchAdImageView(frame: CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: height))
        imgView.alpha = 0.2
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

extension ZLaunchAdVC: ZLaunchAPI {
    @discardableResult
    public func waitTime(_ waitTime: Int) -> Self {
        if waitTime >= 1 { self.waitTime = waitTime }
        return self
    }
    @discardableResult
    public func configSkipButton(_ config: (inout ZLaunchSkipButtonConfig) -> Void) -> Self {
        config(&skipBtnConfig)
        return self
    }
    @discardableResult
    public func adBottom(_ adViewBottom: CGFloat) -> Self {
        self.adViewBottom = adViewBottom
        return self
    }
    @discardableResult
    public func animationType(_ animationType: ZLaunchAnimationType) -> Self {
        self.animationType = animationType
        return self
    }
    @discardableResult
    public func rootVC(_ rootViewController: UIViewController) -> Self {
        self.rootViewController = rootViewController
        return self
    }
    public func setImage(_ url: String, duration: Int, action: ZLaunchClosure?) {
        view.addSubview(launchAdImgView)
        launchAdImgView.setImage(with: url, completion: {
            self.setImage(duration: duration, action: action)
        })
    }
    public func setImage(_ image: UIImage?, duration: Int, action: ZLaunchClosure?) {
        if let image = image {
            view.addSubview(launchAdImgView)
            launchAdImgView.image = image
            setImage(duration: duration, action: action)
        }
    }
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
        UIView.animate(withDuration: 0.8, animations: {
            self.launchAdImgView.alpha = 1
        })
    }
}

// MARK: - ZLaunchAdVC 移除
extension ZLaunchAdVC {
    fileprivate func launchAdVCRemove(completion: ZLaunchClosure? = nil) {
        if originalTimer?.isCancelled == false { originalTimer?.cancel() }
        if dataTimer?.isCancelled == false { dataTimer?.cancel() }
        guard rootViewController != nil else { return }
        ZLaunchAnimation().animationType(animationType, fromVC: self, toVC: rootViewController!, completion: completion)
    }
}

//MARK: - GCD timer
extension ZLaunchAdVC {
    fileprivate func startTimer() {
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        originalTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(waitTime))
        originalTimer?.setEventHandler(handler: {
            printLog("等待加载计时:" + "\(self.waitTime)")
            if self.waitTime == 0 {
                DispatchQueue.main.async {
                    self.launchAdVCRemove()
                    return
                }
            }
            self.waitTime -= 1
        })
        originalTimer?.resume()
    }
    /// 广告倒计时
    fileprivate func adStartTimer(_ duration: Int) {
        if self.originalTimer?.isCancelled == false { self.originalTimer?.cancel() }
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
