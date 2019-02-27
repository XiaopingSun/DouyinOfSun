//
//  BaseViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/27.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
