//
//  FollowViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/17.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController {
    
    private lazy var navigationBarView: FollowNavigationBarView = {
        let navigationBarView = FollowNavigationBarView(frame: CGRect.zero)
        return navigationBarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 22, g: 24, b: 35)
        setupUI()
    }
}

extension FollowViewController {
    private func setupUI() {
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
    }
}
