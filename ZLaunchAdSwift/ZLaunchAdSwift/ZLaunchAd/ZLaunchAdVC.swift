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
    /// viewController display 3s without ads
    fileprivate var defaultTime = 3
    /// distance of your ad to window's bottom
    fileprivate var adViewBottomDistance: CGFloat = 100
    /// transition type when change rootViewController
    fileprivate var transitionType: TransitionType = .fade
    /// ad's show time
    fileprivate var adDuration: Int = 0
    /// original timer
    fileprivate var originalTimer: DispatchSourceTimer?
    /// ad timer
    fileprivate var dataTimer: DispatchSourceTimer?
    /// click adImg closure
    fileprivate var adImgViewClick: ZClosure?
    /// layer
    fileprivate var animationLayer: CAShapeLayer?
    fileprivate var rootViewController: UIViewController?
    /// the launch imageView
    fileprivate lazy var launchImageView: UIImageView = {
        let imgView = UIImageView(frame: UIScreen.main.bounds)
        imgView.image = self.getLaunchImage()
        return imgView
    }()
    /// your ad imgView
    fileprivate lazy var launchAdImgView: UIImageView = {
        let height = Z_SCREEN_HEIGHT - self.adViewBottomDistance
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: height))
        imgView.isUserInteractionEnabled = true
        imgView.alpha = 0.2
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(launchAdTapAction(sender:)))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    /// the skip button
    fileprivate lazy var skipBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return button
    }()
    
    /// tap your ad action
    @objc fileprivate func launchAdTapAction(sender: UITapGestureRecognizer) {
        dataTimer?.cancel()
        launchAdVCRemove {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                if self.adImgViewClick != nil {
                    self.adImgViewClick!()
                }
            })
        }
    }
    /// skipButton's action
    @objc fileprivate func skipBtnClick() {
        dataTimer?.cancel()
        launchAdVCRemove(completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(launchImageView)
        startTimer()
    }
    deinit {
        print("byebye")
    }
}

// MARK: - API
extension ZLaunchAdVC {
    ///
    @discardableResult
    public func defaultDuration(_ defaultDuration: Int) -> Self {
        if defaultDuration >= 1 {
            self.defaultTime = defaultDuration
        }
        return self
    }
    /// set skip button's params
    @discardableResult
    public func configSkipBtn(_ config: (inout SkipBtnModel) -> Void) -> ZLaunchAdVC {
        config(&skipBtnConfig)
        return self
    }
    /// distance of adImg to launchImage's bottom
    @discardableResult
    public func adBottom(_ adViewBottom: CGFloat) -> Self {
        adViewBottomDistance = adViewBottom
        return self
    }
    /// set transition animation type
    @discardableResult
    public func transition(_ transitionType: TransitionType) -> Self {
        self.transitionType = transitionType
        return self
    }
    /// set app's rootViewController
    @discardableResult
    public func rootVC(_ rootViewController: UIViewController) -> Self {
        self.rootViewController = rootViewController
        return self
    }
    /// set img parametes
    ///
    /// - Parameters:
    ///   - url: url
    ///   - duration: display seconds
    ///   - adImgViewClick: click ad & do something
    public func configNetImage(url: String, duration: Int, adImgViewClick: ZClosure?) {
        if url == "" { return }
        adDuration = duration < 1 ? 1 : duration
        view.addSubview(launchAdImgView)
        launchAdImgView.setImage(with: url, completion: {
            self.configSkipBtn()
            if self.originalTimer?.isCancelled == true { return }
            self.adStartTimer()
            UIView.animate(withDuration: 0.8, animations: {
                self.launchAdImgView.alpha = 1
            })
        })
        self.adImgViewClick = adImgViewClick
    }
    /// set local image
    ///
    /// - Parameters:
    ///   - image: pic name
    ///   - duration: display seconds
    ///   - adImgViewClick: do something click ad
    public func configLocalImage(image: UIImage?, duration: Int, adImgViewClick: ZClosure?) {
        if let image = image {
            adDuration = duration < 1 ? 1 : duration
            view.addSubview(launchAdImgView)
            launchAdImgView.image = image
            self.configSkipBtn()
            if self.originalTimer?.isCancelled == true { return }
            self.adStartTimer()
            UIView.animate(withDuration: 0.8, animations: {
                self.launchAdImgView.alpha = 1
            })
        }
        self.adImgViewClick = adImgViewClick
    }
    
    /// set local GIF
    ///
    /// - Parameters:
    ///   - name: pic's name
    ///   - duration: display seconds
    ///   - adImgViewClick: do something when click ad
    public func configLocalGif(name: String, duration: Int, adImgViewClick: ZClosure?) {
        adDuration = duration < 1 ? 1 : duration
        view.addSubview(launchAdImgView)
        launchAdImgView.gifImage(named: name) { 
            self.configSkipBtn()
            if self.originalTimer?.isCancelled == true { return }
            self.adStartTimer()
            UIView.animate(withDuration: 0.8, animations: {
                self.launchAdImgView.alpha = 1
            })
        }
        self.adImgViewClick = adImgViewClick
    }
}

// MARK: - configure skip button
extension ZLaunchAdVC {
    /// setup skip button
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
// MARK: - ZLaunchAdVC remove
extension ZLaunchAdVC {
    /// remove the launch viewController, change rootViewController or do something
    fileprivate func launchAdVCRemove(completion: (()->())?) {
        if self.originalTimer?.isCancelled == false {
            self.originalTimer?.cancel()
        }
        if self.dataTimer?.isCancelled == false {
            self.dataTimer?.cancel()
        }
        guard self.rootViewController != nil else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
            self.transitionAnimation()
            UIApplication.shared.keyWindow?.rootViewController = self.rootViewController
            guard completion != nil else { return }
            completion!()
        })
    }
    
    /// add tansition animation to window when viewController will dealloc
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
    /// start original timer
    fileprivate func startTimer() {
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        originalTimer?.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(defaultTime))
        originalTimer?.setEventHandler(handler: {
            printLog("original timer:" + "\(self.defaultTime)")
            if self.defaultTime == 0 {
                DispatchQueue.main.async {
                    self.launchAdVCRemove(completion: nil)
                }
            }
            self.defaultTime -= 1
        })
        originalTimer?.resume()
    }
    /// start your ad's timer
    fileprivate func adStartTimer() {
        if self.originalTimer?.isCancelled == false {
            self.originalTimer?.cancel()
        }
        dataTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        dataTimer?.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(adDuration))
        dataTimer?.setEventHandler(handler: {
            printLog("ad timer:" + "\(self.adDuration)")
            DispatchQueue.main.async {
                self.skipBtn.setTitle(self.skipBtnConfig.skipBtnType == .timer ? "\(self.adDuration) 跳过" : "跳过", for: .normal)
                if self.adDuration == 0 {
                    self.launchAdVCRemove(completion: nil)
                }
                self.adDuration -= 1
            }
        })
        dataTimer?.resume()
    }
}

// MARK: - StatusBar's Color
/// You can set statusBar by General -> Deployment Info
extension ZLaunchAdVC {
    override var prefersStatusBarHidden: Bool {
        return Bundle.main.infoDictionary?["UIStatusBarHidden"] as! Bool
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let str = Bundle.main.infoDictionary?["UIStatusBarStyle"] as! String
        return str.contains("Default") ? .default : .lightContent
    }
}

// MARK: - Get LaunchImage
extension ZLaunchAdVC {
    fileprivate func getLaunchImage() -> UIImage {
        if (assetsLaunchImage() != nil) || (storyboardLaunchImage() != nil) {
            return assetsLaunchImage() == nil ? storyboardLaunchImage()! : assetsLaunchImage()!
        }
        return UIImage()
    }
    
    /// From Assets
    private func assetsLaunchImage() -> UIImage? {
        let size = UIScreen.main.bounds.size
        let orientation = "Portrait" // "Landscape"
        guard let launchImages = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else { return nil }
        for dict in launchImages {
            let imageSize = CGSizeFromString(dict["UILaunchImageSize"] as! String)
            if __CGSizeEqualToSize(imageSize, size) && orientation == (dict["UILaunchImageOrientation"] as! String) {
                let launchImageName = dict["UILaunchImageName"] as! String
                let image = UIImage.init(named: launchImageName)
                return image
            }
        }
        return nil
    }
    
    /// Form LaunchScreen.Storyboard
    private func storyboardLaunchImage() -> UIImage? {
        guard let storyboardLaunchName = Bundle.main.infoDictionary?["UILaunchStoryboardName"] as? String,
            let launchVC = UIStoryboard.init(name: storyboardLaunchName, bundle: nil).instantiateInitialViewController() else {
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


