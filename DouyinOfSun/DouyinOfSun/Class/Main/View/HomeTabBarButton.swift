//
//  HomeTabBarButton.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/17.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

private let kLineW: CGFloat = 30.0
private let kLineH: CGFloat = 3.0

class HomeTabBarButton: UIButton {
    
    private lazy var lineIndicator: UIView = {
        let lineIndicator = UIView(frame: CGRect.zero)
        lineIndicator.backgroundColor = UIColor.white
        lineIndicator.layer.masksToBounds = true
        lineIndicator.layer.cornerRadius = kLineH / 2.0
        return lineIndicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        adjustsImageWhenDisabled = false
        setTitleColor(UIColor.lightGray, for: .normal)
        setTitleColor(UIColor(r: 252, g: 252, b: 252), for: .selected)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        addSubview(lineIndicator)
        lineIndicator.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lineIndicator.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(2.0)
            make.width.equalTo(40.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonStatusSelected(_ isSelected: Bool) {
        self.isSelected = isSelected
        lineIndicator.isHidden = !isSelected
        titleLabel?.font = isSelected ? UIFont.boldSystemFont(ofSize: 16.0) : UIFont.boldSystemFont(ofSize: 15.0)
    }
}
