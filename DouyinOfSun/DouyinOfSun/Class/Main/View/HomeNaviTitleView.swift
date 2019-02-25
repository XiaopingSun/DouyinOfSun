//
//  HomeNaviTitleView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/19.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

class HomeNaviTitleView: UIView {
    
    private var titles: [String]?
    
    private lazy var line: UIView = {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor(r: 210, g: 210, b: 210)
        addSubview(line)
        return line
    }()
    
    private lazy var leftButton: UIButton = {[weak self] in
        let leftButton = UIButton(type: UIButton.ButtonType.custom)
        leftButton.backgroundColor = UIColor.clear
        leftButton.setTitle(self?.titles![0], for: .normal)
        leftButton.setTitleColor(UIColor(r: 210, g: 210, b: 210), for: .normal)
        leftButton.setTitleColor(UIColor.white, for: .selected)
        leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        leftButton.addTarget(self, action: #selector(leftButtonDidSelected(sender:)), for: .touchUpInside)
        leftButton.isSelected = true
        addSubview(leftButton)
        return leftButton
    }()
    
    private lazy var rightButton: UIButton = {[weak self] in
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.backgroundColor = UIColor.clear
        rightButton.setTitle(self?.titles![1], for: .normal)
        rightButton.setTitleColor(UIColor(r: 210, g: 210, b: 210), for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .selected)
        rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        rightButton.addTarget(self, action: #selector(rightButtonDidSelected(sender:)), for: .touchUpInside)
        rightButton.isSelected = false
        addSubview(rightButton)
        return rightButton
        }()

    init(frame: CGRect, titles: [String]) {
        super.init(frame: frame)
        assert(titles.count != 0, "please input some titles for the custom view")
        self.titles = titles
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height: kNavigationBarH)
    }
    
    @objc private func leftButtonDidSelected(sender: UIButton) {
        guard sender.isSelected == false else {return}
        sender.isSelected = true
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        rightButton.isSelected = false
        rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    @objc private func rightButtonDidSelected(sender: UIButton) {
        guard sender.isSelected == false else {return}
        sender.isSelected = true
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        leftButton.isSelected = false
        leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
}

extension HomeNaviTitleView {
    private func setupUI() {
        line.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(8)
        }
        leftButton.snp.makeConstraints { (make) in
            make.centerY.left.equalToSuperview()
            make.right.equalTo(line.snp.left)
            make.height.equalTo(20)
        }
        rightButton.snp.makeConstraints { (make) in
            make.centerY.right.equalToSuperview()
            make.left.equalTo(line.snp.left)
            make.height.equalTo(20)
        }
    }
}
