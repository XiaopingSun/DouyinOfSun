//
//  RecommendViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/3.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class RecommendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "WechatIMG240.jpeg"))
        imageView.frame = UIScreen.main.bounds
        view.addSubview(imageView)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
