//
//  ViewController.swift
//  ZLaunchAdDemo
//
//  Created by mengqingzheng on 2017/4/5.
//  Copyright © 2017年 meng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        navigationItem.title = "ZLaunchAdVC"
        
        let ttview = UIView.init(frame: CGRect(x: 0, y: 100, width: 100, height: 100))
        ttview.backgroundColor = UIColor.red
        UIApplication.shared.keyWindow?.addSubview(ttview)
        
    }
    
}

