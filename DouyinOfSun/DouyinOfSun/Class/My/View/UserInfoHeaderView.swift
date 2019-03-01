//
//  UserInfoHeaderView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/28.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

private let kTopAvatarImageHeight: CGFloat = 211
private let kBottomImageHeight: CGFloat = 285
private let kBottomImageTop: CGFloat = 116
private let kTabbarFooterHeight: CGFloat = 36
private let kAvatarRedius: Double = 54
private let kAvatarTopOffset: Double = 16

protocol UserInfoHeaderViewDelegate: class {
    func userInfoHeaderViewPortraitImageViewDidSelected()
}

class UserInfoHeaderView: UICollectionReusableView {
    
    weak var delegate: UserInfoHeaderViewDelegate?
    
    private lazy var topAvatarImageV: UIImageView = {
        let topAvatarImageV = UIImageView(frame: CGRect.zero)
        topAvatarImageV.contentMode = .scaleToFill
        topAvatarImageV.image = UIImage(named: "imageFollow")
        return topAvatarImageV
    }()
    
    private lazy var bottomImageView: UIImageView = {
        let bottomImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kBottomImageHeight))
        bottomImageView.image = UIImage(named: "91551426428_.pic.jpg")
        bottomImageView.contentMode = .scaleToFill
        
        return bottomImageView
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.backgroundColor = UIColor(r: 34, g: 36, b: 48, alpha:0.7)
        bottomImageView.addSubview(visualEffectView)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = portraitRediusBezierPath.cgPath
        bottomImageView.layer.mask = maskLayer
        
        return visualEffectView
    }()
    
    private lazy var portraitRediusBezierPath: UIBezierPath = {
        let portraitRediusBezierPath = UIBezierPath()
        portraitRediusBezierPath.move(to: CGPoint(x: 0, y: kAvatarTopOffset))
        portraitRediusBezierPath.addLine(to: CGPoint(x: 28, y: kAvatarTopOffset))
        portraitRediusBezierPath.addArc(withCenter: CGPoint(x: 28 + kAvatarRedius * cos(Double.pi / 4.0), y: kAvatarRedius * sin(Double.pi / 4.0) + kAvatarTopOffset), radius: CGFloat(kAvatarRedius), startAngle: CGFloat(Double.pi * 5 / 4.0), endAngle: CGFloat(Double.pi * 7 / 4.0), clockwise: true)
        portraitRediusBezierPath.addLine(to: CGPoint(x: kScreenWidth, y: CGFloat(kAvatarTopOffset)))
        portraitRediusBezierPath.addLine(to: CGPoint(x: kScreenWidth, y: kBottomImageHeight))
        portraitRediusBezierPath.addLine(to: CGPoint(x: 0, y: kBottomImageHeight))
        portraitRediusBezierPath.close()
        return portraitRediusBezierPath
    }()
    
    private lazy var clearMaskView: UIView = {
        let clearMaskView = UIView(frame: CGRect.zero)
        clearMaskView.backgroundColor = UIColor.clear
        clearMaskView.alpha = 1
        return clearMaskView
    }()
    
    private lazy var portraitImageV: UIImageView = {
        let portraitImageV = UIImageView(frame: CGRect.zero)
        portraitImageV.image = UIImage(named: "img_find_default")
        portraitImageV.layer.masksToBounds = true
        portraitImageV.layer.cornerRadius = CGFloat(kAvatarRedius - 3.5)
        portraitImageV.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(portraitImageViewDidSelected))
        portraitImageV.addGestureRecognizer(tapGesture)
        return portraitImageV
    }()
    
    private lazy var tabbar: UserInfoHeaderTabbar = {
        let tabbar = UserInfoHeaderTabbar(frame: CGRect.zero)
        return tabbar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func heightValue() -> CGFloat {
        return kBottomImageTop + kBottomImageHeight
    }
    
    // 通过collectView的偏移量更新顶部背景图的约束实现放大、递进滑动
    func updateScrollView(contentOffset: CGPoint) {
        if contentOffset.y < 0 {
            topAvatarImageV.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(contentOffset.y)
                make.centerX.equalToSuperview()
                make.height.equalTo(kTopAvatarImageHeight - contentOffset.y)
                make.width.equalTo((-contentOffset.y) / 211 * 375 + kScreenWidth)
            }
        } else {
            if contentOffset.y + kStatusBarH + kNavigationBarH + kTabbarFooterHeight - frame.size.height > 0 {return}
            topAvatarImageV.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(contentOffset.y / 2.0)
            }
        }
    }
    
    @objc private func portraitImageViewDidSelected() {
        delegate?.userInfoHeaderViewPortraitImageViewDidSelected()
    }
}

extension UserInfoHeaderView {
    private func setupUI() {
        addSubview(topAvatarImageV)
        addSubview(bottomImageView)
        addSubview(clearMaskView)
        clearMaskView.addSubview(portraitImageV)
        addSubview(tabbar)
        
        topAvatarImageV.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kTopAvatarImageHeight)
        }
        bottomImageView.snp.makeConstraints { (make) in
            make.top.equalTo(kBottomImageTop)
            make.left.right.equalToSuperview()
            make.height.equalTo(kBottomImageHeight)
        }
        visualEffectView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        clearMaskView.snp.makeConstraints { (make) in
            make.top.equalTo(visualEffectView)
            make.left.right.equalToSuperview()
            make.height.equalTo(visualEffectView)
        }
        portraitImageV.snp.makeConstraints { (make) in
            make.centerX.equalTo(28 + kAvatarRedius * cos(Double.pi / 4.0))
            make.centerY.equalTo(kAvatarRedius * sin(Double.pi / 4.0) + kAvatarTopOffset)
            make.width.height.equalTo((kAvatarRedius - 3.5) * 2)
        }
        tabbar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kTabbarFooterHeight)
        }
    }
}
