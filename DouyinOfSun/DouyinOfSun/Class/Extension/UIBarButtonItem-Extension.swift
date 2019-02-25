 //
//  UIBarButtonItem-Extension.swift
//  DouyuTVOfSun
//
//  Created by WorkSpace_Sun on 2018/8/29.
//  Copyright © 2018年 WorkSpace_Sun. All rights reserved.
//

import UIKit
 
 extension UIBarButtonItem {
    
    convenience init(imageName: String, selectedImageName: String = "", size: CGSize = CGSize.zero) {
        let barButton = UIButton()
        barButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        if selectedImageName != "" {
            barButton.setImage(UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal), for: .selected)
        }
        if size == CGSize.zero {
            barButton.sizeToFit()
        } else {
            barButton.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        self.init(customView: barButton)
    }
 }
