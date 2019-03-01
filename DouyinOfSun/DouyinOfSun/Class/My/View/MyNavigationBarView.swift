//
//  MyNavigationBarView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/28.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

private let kBackButtonWeight: CGFloat = 31

protocol MyNavigationBarViewDelegate: class {
    func MyNavigationBarViewBackDidSelected(navigationBarView: MyNavigationBarView)
}

class MyNavigationBarView: UIView {
    
    weak var delegate: MyNavigationBarViewDelegate?
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: UIButton.ButtonType.custom)
        backButton.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0.3)
        backButton.setImage(UIImage(named: "iconTitlebarWhiteback40_20x20_"), for: .normal)
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = kBackButtonWeight / 2.0
        backButton.addTarget(self, action: #selector(backButtonDidSelected(sender:)), for: .touchUpInside)
        return backButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Pursue"
        return titleLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha: 0)
        
        addSubview(backButton)
        addSubview(titleLabel)
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalTo(42)
            make.height.width.equalTo(kBackButtonWeight)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(42)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func backButtonDidSelected(sender: UIButton) {
        delegate?.MyNavigationBarViewBackDidSelected(navigationBarView: self)
    }
    
    func updateNavigationBar(contentOffset: CGPoint) {
        
    }
}
