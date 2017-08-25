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
    
    /// 不加载图片情况下显示时间
    fileprivate var defaultTime = 3
    
    /// 图片距屏幕底部距离
    fileprivate var adViewBottomDistance: CGFloat = 100
    
    /// 控制器过渡类型
    fileprivate var transitionType: TransitionType = .fade
    
    /// 广告时间
    fileprivate var adDuration: Int = 0
    
    /// 默认定时器
    fileprivate var originalTimer: DispatchSourceTimer?
    
    /// 图片显示定时器
    fileprivate var dataTimer: DispatchSourceTimer?
    
    /// 图片点击闭包
    fileprivate var adImgViewClick: ZClosure?
    
    /// layer
    fileprivate var animationLayer: CAShapeLayer?
    
    fileprivate var rootViewController: UIViewController?
    
    /// 启动页
    fileprivate lazy var launchImageView: UIImageView = {
        let imgView = UIImageView(frame: UIScreen.main.bounds)
        imgView.image = self.getLaunchImage()
        return imgView
    }()
    
    /// 广告图
    fileprivate lazy var launchAdImgView: UIImageView = {
        let height = Z_SCREEN_HEIGHT - self.adViewBottomDistance
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: height))
        imgView.isUserInteractionEnabled = true
        imgView.alpha = 0.2
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(launchAdTapAction(sender:)))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    
    /// 跳过按钮
    fileprivate lazy var skipBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(skipBtnClick), for: .touchUpInside)
        return button
    }()
    
    //MARK: - 点击事件
    /// 广告点击
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
    /// 跳过点击
    @objc fileprivate func skipBtnClick() {
        dataTimer?.cancel()
        launchAdVCRemove(completion: nil)
    }
    
//MARK: - 便利构造方法
    
    public convenience init(defaultDuration: Int = 3, adViewBottom: CGFloat = 100, transitionType: TransitionType = .fade, rootViewController: UIViewController) {
        self.init(nibName: nil, bundle: nil)
        self.transitionType = transitionType
        adViewBottomDistance = adViewBottom
        if defaultDuration >= 1 {
            self.defaultTime = defaultDuration
        }
        self.rootViewController = rootViewController
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

// MARK: - 参数设置
extension ZLaunchAdVC {
    
    /// 配置按钮
    @discardableResult
    public func configSkipBtn(_ config: (inout SkipBtnModel) -> Void) -> ZLaunchAdVC {
        config(&skipBtnConfig)
        return self
    }
    
    /// 广告图距离底部的距离
    @discardableResult
    public func adBottom(_ adViewBottom: CGFloat = 100) -> Self {
        adViewBottomDistance = adViewBottom
        return self
    }
    
    /// 切换控制器效果
    @discardableResult
    public func transition(_ transitionType: TransitionType = .fade) -> Self {
        self.transitionType = transitionType
        return self
    }
    
    /// 完成
    @discardableResult
    public func configRootVC(_ rootViewController: UIViewController) -> Self {
        self.rootViewController = rootViewController
        return self
    }
    
    /// 网络图片参数设置
    ///
    /// - Parameters:
    ///   - url: url
    ///   - duration: 持续时间
    ///   - adImgViewClick: 点击闭包
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
    
    
    /// 本地图片
    ///
    /// - Parameters:
    ///   - image: 图片名
    ///   - duration: 持续时间
    ///   - adImgViewClick: 点击闭包
    func configLocalImage(image: UIImage?, duration: Int, adImgViewClick: ZClosure?) {
        
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
    
    /// 本地GIF
    ///
    /// - Parameters:
    ///   - name: 图片名
    ///   - duration: 持续时间
    ///   - adImgViewClick: 点击闭包
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
    
    
    private func configSkipBtn() -> Void {
        
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
            }
            skipBtn.center = CGPoint(x: skipBtnConfig.centerX, y: skipBtnConfig.centerY)
            view.addSubview(skipBtn)
            skipBtn.setTitle(skipBtnConfig.skipBtnType == .timer ? "\(adDuration) 跳过" : "跳过", for: .normal)
        }
    }
    
    /// 添加动画
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

extension ZLaunchAdVC {
    /// 关闭广告
    /// ==============
    fileprivate func launchAdVCRemove(completion: (()->())?) {
        
        if self.originalTimer?.isCancelled == false {
            self.originalTimer?.cancel()
        }
        if self.dataTimer?.isCancelled == false {
            self.dataTimer?.cancel()
        }
        
        if self.rootViewController != nil {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                self.transitionAnimation()
                UIApplication.shared.keyWindow?.rootViewController = self.rootViewController
                if completion != nil {
                    completion!()
                }
            })
            
        }
    }
    
    private func transitionAnimation() -> Void {
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

//MARK: - GCD定时器
/// APP启动后开始默认定时器，默认3s
/// 3s内若网络图片加载完成，默认定时器关闭，开启图片倒计时
/// 3s内若图片加载未完成，执行completion闭包
extension ZLaunchAdVC {
    /// 默认定时器
    fileprivate func startTimer() {
        
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        
        originalTimer?.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(defaultTime))
        
        originalTimer?.setEventHandler(handler: {
            
            printLog("默认定时器" + "\(self.defaultTime)")
            
            if self.defaultTime == 0 {
                
                DispatchQueue.main.async {
                    self.launchAdVCRemove(completion: nil)
                }
            }
            self.defaultTime -= 1
        })
        
        originalTimer?.resume()
    }
    
    /// 图片倒计时
    fileprivate func adStartTimer() {
        
        if self.originalTimer?.isCancelled == false {
            self.originalTimer?.cancel()
        }
        
        dataTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.global())
        
        dataTimer?.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(adDuration))
        
        dataTimer?.setEventHandler(handler: {
            printLog("广告倒计时" + "\(self.adDuration)")
            
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

// MARK: - 状态栏相关
/// 状态栏显示、颜色与General -> Deployment Info中设置一致
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
    
    //获取Assets里LaunchImage
    private func assetsLaunchImage() -> UIImage? {
        
        let size = UIScreen.main.bounds.size
        
        let orientation = "Portrait" //横屏 "Landscape"
        
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
    
    //获取LaunchScreen.Storyboard
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
    
    /// view转换图片
    private func viewConvertImage(view: UIView) -> UIImage? {
        
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
}


