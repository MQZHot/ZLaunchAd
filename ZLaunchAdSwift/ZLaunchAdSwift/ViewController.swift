//
//  ViewController.swift
//  ZLaunchAdDemo
//
//  Created by MQZHot on 2017/4/5.
//  Copyright © 2017年 MQZHot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        navigationItem.title = "ZLaunchAdVC"
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+20) {
            NotificationCenter.default.post(name: NSNotification.Name.init("myNotification"), object: nil)
        }
    }
    
}
