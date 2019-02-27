//
//  MyViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/20.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class MyViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.randomColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarHidden = false
        statusBarStyle = .lightContent
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController!.navigationTransitionType = .rightPop
    }
}
