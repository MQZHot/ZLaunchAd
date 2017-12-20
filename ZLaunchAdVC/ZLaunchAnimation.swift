//
//  ZLaunchAnimation.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2017/4/5.
//  Copyright © 2017年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAdVC
//

import UIKit

class ZLaunchAnimation: NSObject, CAAnimationDelegate {
    
    private let animationDuration = 0.8
    private var animationView: UIView!
    
    func animationType(_ animationType: ZLaunchAnimationType, fromVC: UIViewController, toVC: UIViewController, completion: ZLaunchClosure?) {
        
        switch animationType {
        case .crossDissolve, .curlUp, .flipFromBottom, .flipFromLeft, .flipFromRight, .flipFromTop:
            
            let closure = {
                UIView.setAnimationsEnabled(false)
                UIApplication.shared.keyWindow?.rootViewController = toVC
                if  completion != nil { completion!() }
                UIView.setAnimationsEnabled(true)
            }
            UIView.transition(with: UIApplication.shared.keyWindow!, duration: animationDuration, options: animationOptions(animationType), animations: closure, completion: nil)
        default:
            toVC.view.addSubview(fromVC.view)
            UIApplication.shared.keyWindow?.rootViewController = toVC
            if completion != nil { completion!() }
            var frame = fromVC.view.frame
            
            switch animationType {
            case .zoomOut:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    self.animationZoom(fromVC.view)
                })
            case .slideFromTop:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        frame.origin.y = -frame.size.height
                        fromVC.view.frame = frame
                    }, completion: { _ in
                        fromVC.view.removeFromSuperview()
                    })
                })
            case .slideFromBottom:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        frame.origin.y = frame.size.height
                        fromVC.view.frame = frame
                    }, completion: { _ in
                        fromVC.view.removeFromSuperview()
                    })
                })
            case .slideFromLeft:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        frame.origin.x = -frame.size.width
                        fromVC.view.frame = frame
                    }, completion: { _ in
                        fromVC.view.removeFromSuperview()
                    })
                })
                
            case .slideFromRight:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        frame.origin.x = frame.size.width
                        fromVC.view.frame = frame
                    }, completion: { _ in
                        fromVC.view.removeFromSuperview()
                    })
                })
            default: break
            }
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
    }
}
