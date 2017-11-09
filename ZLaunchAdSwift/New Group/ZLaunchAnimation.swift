//
//  ZLaunchAnimation.swift
//  ZLaunchAdSwift
//
//  Created by mengqingzheng on 2017/11/9.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

class ZLaunchAnimation: NSObject, CAAnimationDelegate {
    
    private let animationDuration = 0.5
    private var animationCompletion: ZLaunchClosure?
    private var animationView: UIView!
    private var animationType: ZLaunchAnimationType!
    private var toVC: UIViewController!
    
    func animationType(_ animationType: ZLaunchAnimationType, fromVC: UIViewController, toVC: UIViewController, completion: ZLaunchClosure?) {
        self.animationType = animationType
        self.animationCompletion = completion
        switch animationType {
        case .crossDissolve, .curlUp, .flipFromBottom, .flipFromLeft, .flipFromRight, .flipFromTop:
            let closure = {
                UIView.setAnimationsEnabled(false)
                UIApplication.shared.keyWindow?.rootViewController = toVC
                UIView.setAnimationsEnabled(true)
            }
            UIView.transition(with: UIApplication.shared.keyWindow!, duration: animationDuration, options: animationOptions(animationType), animations: closure) { success in
                if success && completion != nil {
                    completion!()
                }
            }
        case .zoomOut:
            toVC.view.addSubview(fromVC.view)
            UIApplication.shared.keyWindow?.rootViewController = toVC
            animationZoom(fromVC.view)
        case .slideFromTop:
            toVC.view.addSubview(fromVC.view)
            UIApplication.shared.keyWindow?.rootViewController = toVC
            var frame = fromVC.view.frame
            
            UIView.animate(withDuration: animationDuration, animations: {
                frame.origin.y = -frame.size.height
                fromVC.view.frame = frame
            }, completion: { _ in
                if completion != nil { completion!() }
            })
        case .slideFromBottom:
            toVC.view.addSubview(fromVC.view)
            UIApplication.shared.keyWindow?.rootViewController = toVC
            var frame = fromVC.view.frame
            
            UIView.animate(withDuration: animationDuration, animations: {
                frame.origin.y = frame.size.height
                fromVC.view.frame = frame
            }, completion: { _ in
                if completion != nil { completion!() }
            })
        case .slideFromLeft:
            toVC.view.addSubview(fromVC.view)
            UIApplication.shared.keyWindow?.rootViewController = toVC
            var frame = fromVC.view.frame
            
            UIView.animate(withDuration: animationDuration, animations: {
                frame.origin.x = -frame.size.width
                fromVC.view.frame = frame
            }, completion: { _ in
                if completion != nil { completion!() }
            })
        case .slideFromRight:
            toVC.view.addSubview(fromVC.view)
            UIApplication.shared.keyWindow?.rootViewController = toVC
            var frame = fromVC.view.frame
            
            UIView.animate(withDuration: animationDuration, animations: {
                frame.origin.x = frame.size.width
                fromVC.view.frame = frame
            }, completion: { _ in
                if completion != nil { completion!() }
            })
        case .none:
            UIApplication.shared.keyWindow?.rootViewController = toVC
        }
    }
    
    private func animationOptions(_ animationType: ZLaunchAnimationType) -> UIViewAnimationOptions {
        switch animationType {
        case .curlUp:
            return .transitionCurlUp
        case .flipFromBottom:
            return .transitionFlipFromBottom
        case .flipFromTop:
            return .transitionFlipFromTop
        case .flipFromLeft:
            return .transitionFlipFromLeft
        case .flipFromRight:
            return .transitionFlipFromRight
        default:
            return .transitionCrossDissolve
        }
    }
    /// 缩放动画
    private func animationZoom(_ animationView: UIView) {
        self.animationView = animationView
        let center: CGPoint = animationView.center
        let circleCenterRect = CGRect(x: center.x-1, y: center.y-1, width: 2, height: 2)
        let smallCircleBP = UIBezierPath(ovalIn: circleCenterRect)
        let centerX = circleCenterRect.origin.x+circleCenterRect.size.width/2
        let centerY = circleCenterRect.origin.y+circleCenterRect.size.height/2
        //找出到页面4个角最长的半径
        let width = animationView.frame.size.width
        let r1 = (width-centerX)>centerX ? (width-centerX):centerX
        let r2 = (width-centerY)>centerY ? (width-centerY):centerY
        let radius = sqrt((r1 * r1) + (r2 * r2))
        let bigCircleBP = UIBezierPath(ovalIn:CGRect.insetBy(circleCenterRect)(dx: -radius, dy: -radius))
        
        let maskLayer = CAShapeLayer()
        animationView.layer.mask = maskLayer
        maskLayer.path = smallCircleBP.cgPath
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = bigCircleBP.cgPath
        maskLayerAnimation.toValue = smallCircleBP.cgPath
        maskLayerAnimation.duration = animationDuration
        maskLayerAnimation.delegate = self
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
    /// 动画完成
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationView.removeFromSuperview()
        animationView = nil
        if flag && self.animationCompletion != nil {
            self.animationCompletion!()
        }
    }
}

