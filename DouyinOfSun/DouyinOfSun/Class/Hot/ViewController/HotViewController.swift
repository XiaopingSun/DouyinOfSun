//
//  HotViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/17.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

class HotViewController: UIViewController {
    
    private lazy var navigationBarView: HotNavigationBarView = {
        let navigationBarView = HotNavigationBarView(frame: CGRect.zero)
        return navigationBarView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension HotViewController {
    private func setupUI() {
        let imageView = UIImageView(image: UIImage(named: "imageHot"))
        imageView.frame = UIScreen.main.bounds
        view.addSubview(imageView)
        
        view.addSubview(navigationBarView)
        navigationBarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
    }
}

extension HotViewController: UIViewControllerInteractivePushGestureDelegate {
    func destinationViewControllerFrom(fromViewController: UIViewController) -> UIViewController {
        let myVC = MyViewController()
        myVC.hidesBottomBarWhenPushed = true
        return myVC
    }
}
