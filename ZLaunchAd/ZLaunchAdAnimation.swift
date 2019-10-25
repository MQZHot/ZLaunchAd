//
//  ZLaunchAnimation.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2017/4/5.
//  Copyright © 2017年 MQZHot. All rights reserved.
//
//  https://github.com/MQZHot/ZLaunchAd
//

import UIKit

class ZLaunchAdAnimation: NSObject, CAAnimationDelegate {
    
    private let animationDuration = 0.8
    private var animationView: UIView!
    
    func animationType(_ animationType: ZLaunchAnimationType, animationView: UIView, animationClosure: @escaping ZLaunchClosure) {
        
        switch animationType {
        case .crossDissolve, .curlUp, .flipFromBottom, .flipFromLeft, .flipFromRight, .flipFromTop:
            
            let closure = {
                UIView.setAnimationsEnabled(false)
                animationClosure()
                UIView.setAnimationsEnabled(true)
            }
            UIView.transition(with: UIApplication.shared.keyWindow!, duration: animationDuration, options: animationOptions(animationType), animations: closure, completion: nil)
        default:
            
            var frame = animationView.frame
            switch animationType {
            case .slideFromTop:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        frame.origin.y = -frame.size.height
                        animationView.frame = frame
                    }, completion: { _ in
                        animationClosure()
                    })
                })
            case .slideFromBottom:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        frame.origin.y = frame.size.height
                        animationView.frame = frame
                    }, completion: { _ in
                        animationClosure()
                    })
                })
            case .slideFromLeft:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        frame.origin.x = -frame.size.width
                        animationView.frame = frame
                    }, completion: { _ in
                        animationClosure()
                    })
                })
                
            case .slideFromRight:
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
                    UIView.animate(withDuration: self.animationDuration, animations: {
                        frame.origin.x = frame.size.width
                        animationView.frame = frame
                    }, completion: { _ in
                        animationClosure()
                    })
                })
            default: break
            }
        }
    }
    
    private func animationOptions(_ animationType: ZLaunchAnimationType) -> UIView.AnimationOptions {
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
}
