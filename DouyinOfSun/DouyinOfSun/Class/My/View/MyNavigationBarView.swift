//
//  MyNavigationBarView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/28.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

private let kNaviButtonWeight: CGFloat = 31
private let kTabbarFooterHeight: CGFloat = 36

protocol MyNavigationBarViewDelegate: class {
    func MyNavigationBarViewBackDidSelected(navigationBarView: MyNavigationBarView)
    func MyNavigationBarViewMoreDidSelected(navigationBarView: MyNavigationBarView)
}

class MyNavigationBarView: UIView {
    
    weak var delegate: MyNavigationBarViewDelegate?
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: UIButton.ButtonType.custom)
        backButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0.3)
        backButton.setImage(UIImage(named: "iconTitlebarWhiteback40_20x20_"), for: .normal)
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = kNaviButtonWeight / 2.0
        backButton.addTarget(self, action: #selector(backButtonDidSelected(sender:)), for: .touchUpInside)
        return backButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "抖音"
        titleLabel.alpha = 0
        return titleLabel
    }()
    
    private lazy var moreButton: UIButton = {
        let moreButton = UIButton(type: UIButton.ButtonType.custom)
        moreButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0.3)
        moreButton.setImage(UIImage(named: "iconTitlebarProfileMoreWhite_20x20_"), for: .normal)
        moreButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = kNaviButtonWeight / 2.0
        moreButton.addTarget(self, action: #selector(moreButtonDidSelected(sender:)), for: .touchUpInside)
        return moreButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0)
        
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(moreButton)
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(42)
            make.height.width.equalTo(kNaviButtonWeight)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-12)
            make.centerY.equalTo(backButton)
            make.height.width.equalTo(kNaviButtonWeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func backButtonDidSelected(sender: UIButton) {
        delegate?.MyNavigationBarViewBackDidSelected(navigationBarView: self)
    }
    
    @objc private func moreButtonDidSelected(sender: UIButton) {
        delegate?.MyNavigationBarViewMoreDidSelected(navigationBarView: self)
    }
    
    func updateNavigationBar(contentOffset: CGPoint, headerFrame: CGRect) {
        if contentOffset.y + kStatusBarH + kNavigationBarH + kTabbarFooterHeight - headerFrame.size.height > 0 {
            backButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0)
            moreButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0)
            titleLabel.alpha = 1
        } else {
            if contentOffset.y + kStatusBarH + kNavigationBarH + kTabbarFooterHeight - headerFrame.size.height + 100 > 0 {
                let percent: CGFloat = -(contentOffset.y + kStatusBarH + kNavigationBarH + kTabbarFooterHeight - headerFrame.size.height) / 100
                backButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: percent * 0.3)
                moreButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: percent * 0.3)
                titleLabel.alpha = 1.0 - percent
            } else {
                backButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0.3)
                moreButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0.3)
                titleLabel.alpha = 0
            }
        }
    }
}
