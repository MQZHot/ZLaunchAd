//
//  AdModel.swift
//  ZLaunchAdSwift
//
//  Created by MQZHot on 2017/11/9.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

struct AdModel {
    
    var imgUrl: String!
    var duration: Int!
    var width: CGFloat!
    var height: CGFloat!
    var animationType: ZLaunchAnimationType!
    var skipBtnType: ZLaunchSkipButtonType!
    
    
    init(_ dic: Dictionary<String, Any>) {
        imgUrl = dic["imgUrl"] as! String
        duration = dic["duration"] as! Int
        width = dic["width"] as! CGFloat
        height = dic["height"] as! CGFloat
        
        let btnType = dic["skipBtnType"] as! Int
        skipBtnType = ZLaunchSkipButtonType(rawValue: btnType)!
        
        let animationType = dic["animationType"] as! Int
        self.animationType = ZLaunchAnimationType(rawValue: animationType)!
    }
    
}
