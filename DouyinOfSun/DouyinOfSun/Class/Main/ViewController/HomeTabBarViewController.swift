//
//  HomeTabBarViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/3.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

enum HomeTabBarViewControllerSelectedType {
    case hot
    case follow
}

protocol HomeTabBarViewControllerDelegate: class {
    func homeTabBarViewController(tabBarViewController: HomeTabBarViewController, didSelected type: HomeTabBarViewControllerSelectedType)
}

class HomeTabBarViewController: UITabBarController {
    
    weak var homeTabBarViewControllerDelegate: HomeTabBarViewControllerDelegate?
    var hotVC: HotViewController?
    var followVC: FollowViewController?
    fileprivate lazy var homeTabBar: HomeTabBar = {[weak self] in
        let homeTabBar = HomeTabBar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kTabbarH))
        homeTabBar.homeTabBarDelegate = self
        return homeTabBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        hotVC = HotViewController()
        followVC = FollowViewController()
        setViewControllers([hotVC!, followVC!], animated: false)
        setValue(homeTabBar, forKey: "tabBar")
    }
}

extension HomeTabBarViewController: HomeTabBarDelegate {
    func tabBar(tabBar: HomeTabBar, clickButton index: HomeTabBarItemType) {
        if index == .recorder {
            // 短视频
        } else {
            self.selectedIndex = index.rawValue
            tabBar.updateTabbarBackgroundColor()
            homeTabBarViewControllerDelegate?.homeTabBarViewController(tabBarViewController: self, didSelected: index == .hot ? .hot : .follow)
        }
    }
}

