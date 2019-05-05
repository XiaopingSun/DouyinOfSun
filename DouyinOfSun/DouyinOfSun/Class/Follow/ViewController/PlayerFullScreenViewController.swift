//
//  PlayerFullScreenViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/4/18.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class PlayerFullScreenViewController: UIViewController {
    
    var isVertical: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return isVertical ? .portrait : .landscapeRight
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return isVertical ? .portrait : .landscape
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
