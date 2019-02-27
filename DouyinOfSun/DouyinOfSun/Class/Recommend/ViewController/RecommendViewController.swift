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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
