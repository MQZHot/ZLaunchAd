//
//  ZLaunchAdVC.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/4/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

class ZLaunchAdVC: UIViewController {
    
    fileprivate var skipBtnConfig: SkipBtnModel = SkipBtnModel()
    /// 等待加载时间
    fileprivate var waitTime = 3
    /// 广告图距底部距离
    fileprivate var adViewBottom: CGFloat = 100
    /// 控制器过渡类型
    fileprivate var transitionType: TransitionType = .fade
    /// 广告显示时间
    fileprivate var adDuration: Int = 0
    /// 初始定时器
    fileprivate var originalTimer: DispatchSourceTimer?
    /// 广告定时器
    fileprivate var dataTimer: DispatchSourceTimer?
    /// 广告点击
    fileprivate var tapAction: ZClosure?
    /// layer
    fileprivate var animationLayer: CAShapeLayer?
    fileprivate var rootViewController: UIViewController?
    /// 跳转时是否显示rootVC
    fileprivate var showRootAfterClick: Bool = true
    /// 广告图
    fileprivate lazy var launchAdImgView: UIImageView = {
        let height = Z_SCREEN_HEIGHT - self.adViewBottom
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: height))
        imgView.isUserInteractionEnabled = true
        imgView.alpha = 0.2
        let tap = UITapGestureRecognizer(target: self, action: #selector(launchAdTapAction(sender:)))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    /// 跳过按钮
    fileprivate lazy var skipBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return button
    }()
    /// 广告点击事件
    @objc fileprivate func launchAdTapAction(sender: UITapGestureRecognizer) {
        dataTimer?.cancel()
        launchAdVCRemove {
            let dealy = self.showRootAfterClick ? 0.4 : 0.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + dealy, execute: {
                if self.tapAction != nil { self.tapAction!() }
            })
        }
    }
    /// 跳过事件
    @objc fileprivate func skipBtnClick() {
        dataTimer?.cancel()
        launchAdVCRemove(completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 启动页
        let launchImageView = UIImageView(frame: UIScreen.main.bounds)
        launchImageView.image = getLaunchImage()
        view.addSubview(launchImageView)
        startTimer()
    }
    
    override var shouldAutorotate: Bool { return false }
    
    deinit {
        print("byebye")
    }
}

// MARK: - API
extension ZLaunchAdVC {
    /// 等待加载时间
    @discardableResult
    public func waitTime(_ waitTime: Int) -> Self {
        if waitTime >= 1 { self.waitTime = waitTime }
        return self
    }
    /// 跳转时是否显示rootVC
    @discardableResult
    public func showRootAfterClick(_ showRootAfterClick: Bool) -> Self {
        self.showRootAfterClick = showRootAfterClick
        return self
    }
    /// 设置跳过
    @discardableResult
    public func configSkipBtn(_ config: (inout SkipBtnModel) -> Void) -> ZLaunchAdVC {
        config(&skipBtnConfig)
        return self
    }
    /// 设置广告图底部距离
    @discardableResult
    public func adBottom(_ adViewBottom: CGFloat) -> Self {
        self.adViewBottom = adViewBottom
        return self
    }
    /// 过渡类型
    @discardableResult
    public func transition(_ transitionType: TransitionType) -> Self {
        self.transitionType = transitionType
        return self
    }
    /// app的rootVC
    @discardableResult
    public func rootVC(_ rootViewController: UIViewController) -> Self {
        self.rootViewController = rootViewController
        return self
    }
    /// 加载图片
    public func setImage(_ url: String, duration: Int, action: ZClosure?) {
        if url == "" { return }
        view.addSubview(launchAdImgView)
        launchAdImgView.setImage(with: url, completion: {
            self.setImage(duration: duration, action: action)
        })
    }
    /// 本地图片
    public func setImage(_ image: UIImage?, duration: Int, action: ZClosure?) {
        if let image = image {
            view.addSubview(launchAdImgView)
            launchAdImgView.image = image
            setImage(duration: duration, action: action)
        }
    }
    /// 本地GIF
    public func setGif(_ name: String, duration: Int, action: ZClosure?) {
        view.addSubview(launchAdImgView)
        launchAdImgView.gifImage(named: name) { 
            self.setImage(duration: duration, action: action)
        }
    }
    private func setImage(duration: Int, action: ZClosure?) {
        adDuration = duration < 1 ? 1 : duration
        tapAction = action
        configSkipBtn()
        if originalTimer?.isCancelled == true { return }
        adStartTimer()
        UIView.animate(withDuration: 0.8, animations: {
            self.launchAdImgView.alpha = 1
        })
    }
}

// MARK: - 配置跳过按钮
extension ZLaunchAdVC {
    fileprivate func configSkipBtn() -> Void {
        skipBtn.removeFromSuperview()
        if animationLayer != nil {
            animationLayer?.removeFromSuperlayer()
            animationLayer = nil
        }
        if skipBtnConfig.skipBtnType != .none {
            skipBtn.backgroundColor = skipBtnConfig.backgroundColor
            skipBtn.setTitleColor(skipBtnConfig.titleColor, for: .normal)
            skipBtn.titleLabel?.font = skipBtnConfig.titleFont
            
            if skipBtnConfig.skipBtnType == .circle {
                skipBtn.frame = CGRect(x: 0, y: 0, width: skipBtnConfig.height, height: skipBtnConfig.height)
                skipBtn.layer.cornerRadius = skipBtnConfig.height*0.5
                circleBtnAddLayer(strokeColor: skipBtnConfig.strokeColor, lineWidth: skipBtnConfig.lineWidth)
            } else {
                skipBtn.frame = CGRect(x: 0, y: 0, width: skipBtnConfig.width, height: skipBtnConfig.height)
                skipBtn.layer.cornerRadius = skipBtnConfig.cornerRadius
                skipBtn.layer.borderColor = skipBtnConfig.borderColor.cgColor
                skipBtn.layer.borderWidth = skipBtnConfig.borderWidth
            }
            skipBtn.center = CGPoint(x: skipBtnConfig.centerX, y: skipBtnConfig.centerY)
            skipBtn.setTitle(skipBtnConfig.skipBtnType == .timer ? "\(adDuration) 跳过" : "跳过", for: .normal)
            view.addSubview(skipBtn)
        }
    }
    
    /// circle button add animation
    fileprivate func circleBtnAddLayer(strokeColor: UIColor, lineWidth: CGFloat) {
        let bezierPath = UIBezierPath(ovalIn: skipBtn.bounds)
        animationLayer = CAShapeLayer()
        animationLayer?.path = bezierPath.cgPath
        animationLayer?.lineWidth = lineWidth
        animationLayer?.strokeColor = strokeColor.cgColor
        animationLayer?.fillColor = UIColor.clear.cgColor
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.duration = Double(adDuration)
        animation.fromValue = 0
        animation.toValue = 1
        animationLayer?.add(animation, forKey: nil)
        skipBtn.layer.addSublayer(animationLayer!)
    }
}
// MARK: - ZLaunchAdVC 移除
extension ZLaunchAdVC {
    fileprivate func launchAdVCRemove(completion: ZClosure? = nil) {
        if originalTimer?.isCancelled == false { originalTimer?.cancel() }
        if dataTimer?.isCancelled == false { dataTimer?.cancel() }
        guard rootViewController != nil else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
            self.transitionAnimation()
            UIApplication.shared.keyWindow?.rootViewController = self.rootViewController
            guard completion != nil else { return }
            completion!()
        })
    }
    private func transitionAnimation() {
        let trans = CATransition()
        trans.duration = 0.5
        switch transitionType {
        case .rippleEffect:
            trans.type = "rippleEffect"
        case .filpFromLeft:
            trans.type = "oglFlip"
            trans.subtype = kCATransitionFromLeft
        case .filpFromRight:
            trans.type = "oglFlip"
            trans.subtype = kCATransitionFromRight
        case .flipFromTop:
            trans.type = "oglFlip"
            trans.subtype = kCATransitionFromTop
        case .filpFromBottom:
            trans.type = "oglFlip"
            trans.subtype = kCATransitionFromBottom
        default:
            trans.type = "fade"
        }
        UIApplication.shared.keyWindow?.layer.add(trans, forKey: nil)
    }
}

//MARK: - GCD timer
/// APP启动后开始默认定时器，默认3s
/// 3s内若网络图片加载完成，默认定时器关闭，开启图片倒计时
/// 3s内若图片加载未完成，执行completion闭包
extension ZLaunchAdVC {
    fileprivate func startTimer() {
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        originalTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(waitTime))
        originalTimer?.setEventHandler(handler: {
            printLog("original timer:" + "\(self.waitTime)")
            if self.waitTime == 0 {
                DispatchQueue.main.async { self.launchAdVCRemove() }
            }
            self.waitTime -= 1
        })
        originalTimer?.resume()
    }
    /// start your ad's timer
    fileprivate func adStartTimer() {
        if self.originalTimer?.isCancelled == false {
            self.originalTimer?.cancel()
        }
        dataTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        dataTimer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(adDuration))
        dataTimer?.setEventHandler(handler: {
            printLog("ad timer:" + "\(self.adDuration)")
            DispatchQueue.main.async {
                self.skipBtn.setTitle(self.skipBtnConfig.skipBtnType == .timer ? "\(self.adDuration) 跳过" : "跳过", for: .normal)
                if self.adDuration == 0 { self.launchAdVCRemove() }
                self.adDuration -= 1
            }
        })
        dataTimer?.resume()
    }
}

// MARK: - 状态栏
extension ZLaunchAdVC {
    override var prefersStatusBarHidden: Bool {
        return Bundle.main.infoDictionary?["UIStatusBarHidden"] as! Bool
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let str = Bundle.main.infoDictionary?["UIStatusBarStyle"] as! String
        return str.contains("Default") ? .default : .lightContent
    }
}

// MARK: - 获取启动页
extension ZLaunchAdVC {
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
            let imageSize = CGSizeFromString(dict["UILaunchImageSize"] as! String)
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


