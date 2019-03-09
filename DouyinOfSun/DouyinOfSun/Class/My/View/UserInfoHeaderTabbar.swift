//
//  UserInfoHeaderTabbar.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/1.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

protocol UserInfoHeaderTabbarDelegate: class {
    func userInfoHeaderTabbar(headerTabbar: UserInfoHeaderTabbar, didSelectedWithType type: UserInfoHeaderTabbarType)
}

enum UserInfoHeaderTabbarType: Int {
    case productions = 10001
    case favorites = 10002
}

class UserInfoHeaderTabbar: UIView {
    
    private var buttonArray = [UIButton]()
    private var isIndicatorAnimating: Bool = false
    weak var delegate: UserInfoHeaderTabbarDelegate?
    
    private lazy var line: UIView = {
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor(r: 255, g: 255, b: 255, alpha: 0.2)
        return line
    }()
    
    private lazy var indicator: UIView = {
        let indicator = UIView(frame: CGRect.zero)
        indicator.backgroundColor = UIColor(r: 250.0, g: 206.0, b: 21.0, alpha: 1.0)
        return indicator
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAwemeNumber(productionsNum: UInt, favoritesNum: UInt) {
        for button in buttonArray {
            if button.tag == UserInfoHeaderTabbarType.productions.rawValue {
                button.setTitle("作品 \(productionsNum)", for: .normal)
            } else if button.tag == UserInfoHeaderTabbarType.favorites.rawValue {
                button.setTitle("喜欢 \(favoritesNum)", for: .normal)
            }
        }
    }
    
    @objc private func buttonDidSelected(sender: UIButton) {
        if sender.isSelected { return }
        if isIndicatorAnimating == true { return }
        for button in buttonArray {
            if button == sender {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
        
        self.isIndicatorAnimating = true
        self.indicator.snp.remakeConstraints { (make) in
            make.centerX.equalTo(sender)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(kScreenWidth / 4.0)
        }
        self.needsUpdateConstraints()
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }, completion: { (_) in
            self.isIndicatorAnimating = false
        })
        
        self.delegate?.userInfoHeaderTabbar(headerTabbar: self, didSelectedWithType: UserInfoHeaderTabbarType(rawValue: sender.tag)!)
    }
}

extension UserInfoHeaderTabbar {
    private func setupUI() {
        let titleArray = ["作品", "喜欢"]
        for i in 0 ..< 2 {
            let button = UIButton(type: UIButton.ButtonType.custom)
            button.backgroundColor = UIColor.clear
            button.setTitle(titleArray[i], for: .normal)
            button.setTitleColor(UIColor.white, for: .selected)
            button.setTitleColor(UIColor(r: 210, g: 210, b: 210), for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            button.tag = i == 0 ? UserInfoHeaderTabbarType.productions.rawValue : UserInfoHeaderTabbarType.favorites.rawValue
            button.isSelected = i == 0
            button.addTarget(self, action: #selector(buttonDidSelected(sender:)), for: .touchUpInside)
            
            buttonArray.append(button)
            addSubview(button)
            button.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(kScreenWidth / 2.0)
                if i == 0 {
                    make.left.equalToSuperview()
                } else {
                    make.right.equalToSuperview()
                }
            }
        }
        
        addSubview(line)
        addSubview(indicator)
        line.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(16)
        }
        indicator.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(kScreenWidth / 4.0)
            make.centerX.equalTo(kScreenWidth / 4.0)
        }
    }
}
