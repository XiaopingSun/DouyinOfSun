//
//  HomeTabBar.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/17.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

private let kRecorderButtonW: CGFloat = 75
private let kRecorderButtonH: CGFloat = 49

enum HomeTabBarItemType: Int {
    case hot        // 热门
    case follow    // 关注
    case recorder  // 短视频
    
    static func getItemTag(itemType: HomeTabBarItemType) -> Int {
        return 1000 + itemType.rawValue
    }
    
    static func getItemType(tag: Int) -> HomeTabBarItemType {
        return HomeTabBarItemType(rawValue: tag - 1000)!
    }
}

protocol HomeTabBarDelegate: class {
    func tabBar(tabBar: HomeTabBar, clickButton index: HomeTabBarItemType)
}

class HomeTabBar: UITabBar {
    
    var homeTabBarDelegate: HomeTabBarDelegate?
    
    private var selectedButton: HomeTabBarButton?
    
    private let titleArray = ["首页", "关注"]
    
    private lazy var recorderButton: UIButton = {
        let recorderButton = UIButton(type: UIButton.ButtonType.custom)
        recorderButton.setImage(UIImage(named: "btn_home_add_75x49_"), for: .normal)
        recorderButton.tag = HomeTabBarItemType.getItemTag(itemType: .recorder)
        recorderButton.addTarget(self, action: #selector(tarbarItemDidSelected(sender:)), for: .touchUpInside)
        return recorderButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        homeTabBarDelegate?.tabBar(tabBar: self, clickButton: .hot)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for view in subviews {
            let barButtonClass: AnyObject.Type = NSClassFromString("UITabBarButton")!
            if view.isMember(of: barButtonClass.self) {
                view.removeFromSuperview()
            }
        }
        
        let width = (kScreenWidth - kRecorderButtonW) / CGFloat(titleArray.count)
        for i in 0..<subviews.count {
            let view = subviews[i]
            if view.isKind(of: UIButton.self) {
                if view.tag == HomeTabBarItemType.getItemTag(itemType: .hot) {
                    view.snp.makeConstraints { (make) in
                        make.top.left.bottom.equalToSuperview()
                        make.width.equalTo(width)
                    }
                } else if view.tag == HomeTabBarItemType.getItemTag(itemType: .follow) {
                    view.snp.makeConstraints { (make) in
                        make.top.right.bottom.equalToSuperview()
                        make.width.equalTo(width)
                    }
                } else if view.tag == HomeTabBarItemType.getItemTag(itemType: .recorder) {
                    view.snp.makeConstraints { (make) in
                        make.top.bottom.centerX.equalToSuperview()
                        make.width.equalTo(kRecorderButtonW)
                    }
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tarbarItemDidSelected(sender: UIButton) {
        if sender.isMember(of: HomeTabBarButton.self) {
            guard let button = sender as? HomeTabBarButton else {return}
            self.selectedButton?.setButtonStatusSelected(false)
            button.setButtonStatusSelected(true)
            self.selectedButton = button
        }
        homeTabBarDelegate?.tabBar(tabBar: self, clickButton: HomeTabBarItemType.getItemType(tag: sender.tag))
    }
    
    private func getTabbarFillImage(withRect frame: CGRect, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(frame)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func updateTabbarBackgroundColor() {
        if HomeTabBarItemType.getItemType(tag: (selectedButton?.tag)!) == .hot {
            backgroundImage = getTabbarFillImage(withRect: CGRect(x: 0, y: 0, width: 1, height: 1), color: UIColor(red: 1, green: 1, blue: 1, alpha: 0))
            shadowImage = getTabbarFillImage(withRect: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.06), color: UIColor(r: 255, g: 255, b: 255))
        } else if HomeTabBarItemType.getItemType(tag: (selectedButton?.tag)!) == .follow {
            backgroundImage = getTabbarFillImage(withRect: CGRect(x: 0, y: 0, width: 1, height: 1), color: UIColor(r: 26, g: 27, b: 32))
            shadowImage = UIImage()
        }
    }
}

extension HomeTabBar {
    private func addSubviews() {
        
        // tabBar透明
        backgroundImage = getTabbarFillImage(withRect: CGRect(x: 0, y: 0, width: 1, height: 1), color: UIColor(red: 1, green: 1, blue: 1, alpha: 0))
        shadowImage = getTabbarFillImage(withRect: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.06), color: UIColor(r: 255, g: 255, b: 255))
        
        // 初始化items
        for i in 0..<titleArray.count {
            let button = HomeTabBarButton(type: UIButton.ButtonType.custom)
            button.setTitle(titleArray[i], for: .normal)
            button.tag = HomeTabBarItemType.getItemTag(itemType: HomeTabBarItemType(rawValue: i)!)
            
            if i == 0 {
                button.isSelected = true
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
                selectedButton = button
                selectedButton?.setButtonStatusSelected(true)
            }
            
            button.addTarget(self, action: #selector(tarbarItemDidSelected(sender:)), for: .touchUpInside)
            addSubview(button)
        }
        
        addSubview(recorderButton)
    }
}
