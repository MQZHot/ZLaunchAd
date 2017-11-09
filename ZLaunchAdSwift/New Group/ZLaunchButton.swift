//
//  ZLaunchButton.swift
//  ZLaunchAdSwift
//
//  Created by mengqingzheng on 2017/11/9.
//  Copyright © 2017年 meng. All rights reserved.
//

import Foundation
import UIKit

class ZLaunchButton: UIButton {
    
    fileprivate var config: ZLaunchSkipButtonConfig!
    fileprivate var adDuration: Int!
    
    func setDuration(_ duration: Int) {
        adDuration = duration
        isHidden = false
        let time = "\(duration)" as NSString
        switch config.skipBtnType {
        case .none:
            isHidden = true
            
        case .text:
            setTitle("\(config.text)", for: .normal)
            setTitleColor(config.textColor, for: .normal)
            titleLabel?.font = config.textFont
            
        case .timer:
            setTitle("\(time)", for: .normal)
            setTitleColor(config.timeColor, for: .normal)
            titleLabel?.font = config.timeFont
            
        case .textLeftTimerRight:
            let title = NSMutableAttributedString(string: "\(config.text) \(time)")
            title.addAttributes([.foregroundColor: config.textColor, .font: config.textFont], range: NSMakeRange(0, config.text.length))
            title.addAttributes([.foregroundColor: config.timeColor, .font: config.timeFont], range: NSMakeRange(config.text.length+1, time.length))
            setAttributedTitle(title, for: .normal)
            
        case .textRightTimerLeft:
            let time = "\(time)" as NSString
            let title = NSMutableAttributedString(string: "\(time) \(config.text)")
            title.addAttributes([.foregroundColor: config.timeColor, .font: config.timeFont], range: NSMakeRange(0, time.length))
            title.addAttributes([.foregroundColor: config.textColor, .font: config.textFont], range: NSMakeRange(time.length+1, config.text.length))
            setAttributedTitle(title, for: .normal)
            
        case .roundText:
            setTitle("\(config.text)", for: .normal)
            setTitleColor(config.textColor, for: .normal)
            titleLabel?.font = config.textFont
            
        case .roundProgressText:
            
            setTitle("\(config.text)", for: .normal)
            setTitleColor(config.textColor, for: .normal)
            titleLabel?.font = config.textFont
            layer.addSublayer(animationLayer)
        }
    }
    
    func setSkipApperance(_ config: ZLaunchSkipButtonConfig) {
        self.config = config
        backgroundColor = config.backgroundColor
        
        var frame = config.frame
        switch config.skipBtnType {
        case .roundText:
            frame.size.width = frame.size.height
            self.frame = frame
            layer.cornerRadius = frame.size.height * 0.5
            layer.borderColor = config.borderColor.cgColor
            layer.borderWidth = config.borderWidth
            layer.cornerRadius = config.cornerRadius
        case .roundProgressText:
            frame.size.width = frame.size.height
            self.frame = frame
            layer.cornerRadius = frame.size.height * 0.5
            layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0
        default:
            self.frame = frame
            layer.borderColor = config.borderColor.cgColor
            layer.borderWidth = config.borderWidth
            layer.cornerRadius = config.cornerRadius
        }
    }
    
    private lazy var animationLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.strokeColor = config.strokeColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = config.lineWidth
        layer.lineCap = kCALineCapRound
        layer.lineJoin = kCALineJoinRound
        let bezierPath = UIBezierPath(ovalIn: bounds)
        layer.path = bezierPath.cgPath
        layer.strokeStart = 0
        layer.strokeEnd = 1
        
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.duration = Double(adDuration)
        animation.fromValue = 0
        animation.toValue = 0.98
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        layer.add(animation, forKey: "strokeStartAnimation")
        return layer
    }()
}
