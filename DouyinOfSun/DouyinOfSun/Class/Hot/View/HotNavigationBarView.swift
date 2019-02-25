//
//  HotNavigationBarView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/22.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

class HotNavigationBarView: UIView {
    
    private lazy var cameraButton: UIButton = {
        let cameraButton = UIButton(type: UIButton.ButtonType.custom)
        cameraButton.setImage(UIImage(named: "iconProfileAddsuipai_24x24_"), for: .normal)
        cameraButton.backgroundColor = UIColor.clear
        return cameraButton
    }()
    
    private lazy var cameraLabel: UILabel = {
        let cameraLabel = UILabel(frame: CGRect.zero)
        cameraLabel.text = "随拍"
        cameraLabel.textColor = UIColor(r: 210, g: 210, b: 210)
        cameraLabel.font = UIFont.boldSystemFont(ofSize: 15)
        cameraLabel.backgroundColor = UIColor.clear
        return cameraLabel
    }()
    
    private lazy var titleView: HomeNaviTitleView = {
        let titleView = HomeNaviTitleView(frame: CGRect.zero, titles: ["推荐", "同城"])
        return titleView
    }()
    
    private lazy var searchButton: UIButton = {
        let searchButton = UIButton(type: UIButton.ButtonType.custom)
        searchButton.setImage(UIImage(named: "icon_old_search_style_new_36x36_"), for: .normal)
        searchButton.backgroundColor = UIColor.clear
        return searchButton
    }()
    
    private lazy var shootButton: UIButton = {
        let shootButton = UIButton(type: UIButton.ButtonType.custom)
        shootButton.setImage(UIImage(named: "icon_profile_start_shoot_24x24_"), for: .normal)
        shootButton.backgroundColor = UIColor.clear
        return shootButton
    }()

    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HotNavigationBarView {
    private func setupSubviews() {
        addSubview(cameraButton)
        addSubview(cameraLabel)
        addSubview(titleView)
        addSubview(searchButton)
        addSubview(shootButton)
        
        cameraButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(42)
            make.height.equalTo(36)
        }
        cameraLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cameraButton.snp.right).offset(10)
            make.centerY.equalTo(42)
            make.height.equalTo(36)
        }
        titleView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(42)
            make.width.equalTo(120)
        }
        searchButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(42)
            make.height.equalTo(36)
        }
        shootButton.snp.makeConstraints { (make) in
            make.right.equalTo(searchButton.snp.left).offset(-10)
            make.centerY.equalTo(42)
            make.height.equalTo(36)
        }
    }
}
