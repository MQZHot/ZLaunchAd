//
//  ZLaunchAdVC.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/4/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

fileprivate let Z_SCREEN_WIDTH = UIScreen.main.bounds.size.width
fileprivate let Z_SCREEN_HEIGHT = UIScreen.main.bounds.size.height

enum SkipButtonType {
    case none                   /// 无跳过按钮
    case timer                  /// 跳过+倒计时
    case circle                 /// 圆形跳过
}
enum SkipButtonPosition {
    case rightTop               /// 屏幕右上角
    case rightBottom            /// 屏幕右下角
    case rightAdViewBottom      /// 广告图右下角
}

enum TransitionType {
    case none
    case rippleEffect           /// 波纹
    case fade                   /// 交叉淡化
    case flipFromTop            /// 上下翻转
    case filpFromBottom
    case filpFromLeft           /// 左右翻转
    case filpFromRight
}

class ZLaunchAdVC: UIViewController {
    
    /// 默认3s
    /// ===========================
    fileprivate var defaultTime = 3
    
    /// 广告图距底部距离
    ///  ===========================
    fileprivate var AdViewBottomDistance: CGFloat = 100
    
    fileprivate var transitionType: TransitionType = .fade
    
    /// 跳过按钮位置
    /// ===========================
    fileprivate var skipBtnPosition: SkipButtonPosition = .rightTop
    
    /// 跳过按钮类型
    /// ===========================
    fileprivate var skipBtnType: SkipButtonType = .timer {
        didSet {
            
            let btnWidth: CGFloat = 60
            
            let btnHeight: CGFloat = 30
            
            var y: CGFloat = 0
            
            switch skipBtnPosition {
                
            case .rightBottom:
                
                y = Z_SCREEN_HEIGHT - 50
                
            case .rightAdViewBottom:
                
                y = Z_SCREEN_HEIGHT - AdViewBottomDistance - 50
                
            default:
                
                y = 30
                
            }
            
            let timerRect = CGRect(x: Z_SCREEN_WIDTH - 70, y: y, width: btnWidth, height: btnHeight)
            
            let circleRect = CGRect(x: Z_SCREEN_WIDTH - 50, y: y, width: btnHeight, height: btnHeight)
            
            skipBtn.frame = self.skipBtnType == .timer ? timerRect : circleRect
            
            skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: self.skipBtnType == .timer ? 13.5 : 12)
            
            skipBtn.setTitle(self.skipBtnType == .timer ? "\(self.adDuration) 跳过" : "跳过", for: .normal)
        }
    }
    
    /// 广告时间
    /// ===========================
    fileprivate var adDuration: Int = 0
    
    /// 默认定时器
    /// ===========================
    fileprivate var originalTimer: DispatchSourceTimer?
    
    /// 图片显示定时器
    /// ===========================
    fileprivate var dataTimer: DispatchSourceTimer?
    
    /// 图片点击闭包
    /// ===========================
    fileprivate var adImgViewClick: (()->())?
    
    /// 图片倒计时完成闭包
    /// ===========================
    fileprivate var completion:(()->())?
    
    /// layer
    fileprivate var animationLayer: CAShapeLayer?
    
    /// 启动页
    /// ===========================
    fileprivate lazy var launchImageView: UIImageView = {
        let imgView = UIImageView.init(frame: UIScreen.main.bounds)
        imgView.image = self.getLaunchImage()
        return imgView
    }()
    
    /// 广告图
    /// ===========================
    fileprivate lazy var launchAdImgView: UIImageView = {
        let height = Z_SCREEN_HEIGHT - self.AdViewBottomDistance
        let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: Z_SCREEN_WIDTH, height: height))
        imgView.isUserInteractionEnabled = true
        imgView.alpha = 0.2
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(launchAdTapAction(sender:)))
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    
    /// 跳过按钮
    /// ===========================
    fileprivate lazy var skipBtn: UIButton = {
        let button = UIButton.init(type: .custom)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        button.layer.cornerRadius = 15
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
    @objc fileprivate func skipBtnClick() {
        dataTimer?.cancel()
        launchAdVCRemove(completion: nil)
    }
    
    /// 关闭广告
    /// ==============================================================================================================================================================================================================================================================================================================================================================
    fileprivate func launchAdVCRemove(completion: (()->())?) {
        
        if self.originalTimer?.isCancelled == false {
            self.originalTimer?.cancel()
        }
        if self.dataTimer?.isCancelled == false {
            self.dataTimer?.cancel()
        }
        
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
        
        if self.completion != nil {
            self.completion!()
            if completion != nil {

                completion!()
            }
        }
    }
    
    //MARK: - XXXXXXXX
    
    
    /// 初始化    设置默认显示时间
    ///
    /// - Parameter defaultDuration: 默认显示时间，如果不设置，默认3s
    convenience init(defaultDuration: Int = 3, completion: (()->())?) {
        self.init(nibName: nil, bundle: nil)
        if defaultDuration >= 1 {
            self.defaultTime = defaultDuration
        }
        self.completion = completion
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
        
        dataTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.main)
        
        startTimer()
    }
    
    deinit {
        print("byebye")
    }
}

// MARK: - 参数设置

extension ZLaunchAdVC {
    
    /// 设置广告参数
    ///
    /// - Parameters:
    ///   - url: 路径
    ///   - adDuartion:             显示时间
    ///   - skipBtnType:            跳过按钮类型，默认 倒计时+跳过
    ///   - skipBtnPosition:        跳过按钮位置，默认右上角
    ///   - adViewBottomDistance:   图片距底部的距离，默认100
    ///   - transitionType:         过渡的类型，默认没有
    ///   - adImgViewClick:         点击广告回调
    ///   - completion:             完成回调
    func setAdParams(url: String, adDuartion: Int, skipBtnType: SkipButtonType = .timer, skipBtnPosition: SkipButtonPosition = .rightTop,  adViewBottomDistance: CGFloat = 100, transitionType: TransitionType = .none, adImgViewClick: (()->())?) {
        
        self.AdViewBottomDistance = adViewBottomDistance
        self.skipBtnPosition = skipBtnPosition
        self.transitionType = transitionType
        self.adDuration = adDuartion
        self.skipBtnType = skipBtnType
        if adDuration < 1 {
            self.adDuration = 1
        }
        
        if url != "" {
            view.addSubview(launchAdImgView)
            
            self.launchAdImgView.setImage(with: url, completion: {
                /// 如果带缓存，并且需要改变按钮状态
                self.skipBtn.removeFromSuperview()
                if self.animationLayer != nil {
                    self.animationLayer?.removeFromSuperlayer()
                    self.animationLayer = nil
                }
                
                if self.skipBtnType != .none {
                    self.view.addSubview(self.skipBtn)
                    if self.skipBtnType == .circle {
                        self.addLayer()
                    }
                }
                self.adStartTimer()
                
                UIView.animate(withDuration: 0.8, animations: {
                    self.launchAdImgView.alpha = 1
                })
            })
        }
        self.adImgViewClick = adImgViewClick
    }
    
    /// 添加动画
    fileprivate func addLayer() {
        let bezierPath = UIBezierPath.init(ovalIn: skipBtn.bounds)
        animationLayer = CAShapeLayer()
        animationLayer?.path = bezierPath.cgPath
        animationLayer?.lineWidth = 2
        animationLayer?.strokeColor = UIColor.red.cgColor
        animationLayer?.fillColor = UIColor.clear.cgColor
        let animation = CABasicAnimation.init(keyPath: "strokeStart")
        animation.duration = Double(adDuration)
        animation.fromValue = 0
        animation.toValue = 1
        animationLayer?.add(animation, forKey: nil)
        skipBtn.layer.addSublayer(animationLayer!)
    }
}

//MARK: - GCD定时器
/// APP启动后开始默认定时器，默认3s
/// 3s内若网络图片加载完成，默认定时器关闭，开启图片倒计时
/// 3s内若图片加载未完成，执行completion闭包
/// =============================================================================================================================================================================================================================================

extension ZLaunchAdVC {
    
    /// 默认定时器
    fileprivate func startTimer() {
        
        originalTimer = DispatchSource.makeTimerSource(flags: [], queue:DispatchQueue.main)
        
        originalTimer?.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(defaultTime))
        
        originalTimer?.setEventHandler(handler: {
            
            printLog("默认定时器" + "\(self.defaultTime)")
            
            if self.defaultTime == 0 {
                
                self.launchAdVCRemove(completion: nil)
                
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
        
        dataTimer?.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.milliseconds(adDuration))
        
        dataTimer?.setEventHandler(handler: {
            
            self.skipBtn.setTitle(self.skipBtnType == .timer ? "\(self.adDuration) 跳过" : "跳过", for: .normal)
            
            if self.adDuration == 0 {
                
                self.launchAdVCRemove(completion: nil)
            }
            
            printLog("广告倒计时" + "\(self.adDuration)")
            
            self.adDuration -= 1
            
        })
        dataTimer?.resume()
    }
}

// MARK: - 状态栏相关
/// 状态栏显示、颜色与General -> Deployment Info中设置一致========================================================================================================================================================================================================================================================================================================================================================================================
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
// ========================================================================================================================================================================================================================================================================================================================================================================================
extension ZLaunchAdVC {
    
    fileprivate func getLaunchImage() -> UIImage {
        if (assetsLaunchImage() != nil) || (storyboardLaunchImage() != nil) {
            return assetsLaunchImage() == nil ? storyboardLaunchImage()! : assetsLaunchImage()!
        }
        return UIImage()
    }
    
    /// 获取Assets里LaunchImage
    /// ===================================
    fileprivate func assetsLaunchImage() -> UIImage? {
        
        let size = UIScreen.main.bounds.size
        
        let orientation = "Portrait" //横屏 "Landscape"
        
        guard let launchImages = Bundle.main.infoDictionary?["UILaunchImages"] as? [[String: Any]] else {
            return nil
        }
        
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
    
    /// 获取LaunchScreen.Storyboard
    /// ===================================
    fileprivate func storyboardLaunchImage() -> UIImage? {
        
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
    fileprivate func viewConvertImage(view: UIView) -> UIImage {
        
        let size = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
        
    }
}

//MARK: - Log日志
// ========================================================================================================================================================================================================================================================================================================================
func printLog<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

