//
//  HotNavigationBarView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/22.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

protocol HotNavigationBarViewDelegate: class {
    func hotNavigationBarViewWillStartReloading()
}

class HotNavigationBarView: UIView {
    
    private var isReloading: Bool = false
    weak var delegate: HotNavigationBarViewDelegate?
    private lazy var container: UIView = {
        let container = UIView(frame: CGRect.zero)
        container.backgroundColor = UIColor.clear
        return container
    }()
    
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
    
    private lazy var refreshTitle: UILabel = {
        let refreshTitle = UILabel(frame: CGRect.zero)
        refreshTitle.text = "下拉刷新内容"
        refreshTitle.textColor = UIColor.white
        refreshTitle.font = UIFont.boldSystemFont(ofSize: 17)
        refreshTitle.backgroundColor = UIColor.clear
        refreshTitle.alpha = 0.0
        return refreshTitle
    }()
    
    private lazy var loadingView: UIImageView = {
        let loadingView = UIImageView(image: UIImage(named: "icon_loading_40_white_20x20_"))
        loadingView.backgroundColor = UIColor.clear
        loadingView.contentMode = .scaleAspectFit
        loadingView.alpha = 0.0
        return loadingView
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
        addSubview(container)
        addSubview(titleView)
        addSubview(refreshTitle)
        addSubview(loadingView)
        container.addSubview(cameraButton)
        container.addSubview(cameraLabel)
        container.addSubview(searchButton)
        container.addSubview(shootButton)
        
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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
        refreshTitle.snp.makeConstraints { (make) in
            make.center.equalTo(titleView)
        }
        loadingView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-28)
            make.centerY.equalTo(42)
            make.width.height.equalTo(22)
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

extension HotNavigationBarView {
    func updateNavigationBarStatus(offset: CGFloat) {
        print(offset)
        if isReloading == true { return }
        if offset <= 0 {
            self.snp.updateConstraints { (make) in
                make.top.equalToSuperview()
            }
            container.alpha = 1.0
            titleView.alpha = 1.0
            refreshTitle.alpha = 0.0
            loadingView.alpha = 0.0
            loadingView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1.0)
        } else if offset <= 60 {
            self.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(offset / 2.0)
            }
            loadingView.layer.transform = CATransform3DMakeRotation(CGFloat(4 * Double.pi) * offset / 60.0, 0, 0, 1.0)
            if offset <= 30 {
                container.alpha = 1.0 - offset / 30.0
                titleView.alpha = 1.0 - offset / 30.0
                refreshTitle.alpha = 0.0
                loadingView.alpha = 0.0
            } else  {
                container.alpha = 0.0
                titleView.alpha = 0.0
                refreshTitle.alpha = offset / 30.0 - 1
                loadingView.alpha = offset / 30.0 - 1
            }
        } else {
            self.snp.updateConstraints { (make) in
                make.top.equalToSuperview().offset(30)
            }
            loadingView.layer.transform = CATransform3DMakeRotation(CGFloat(4 * Double.pi), 0, 0, 1.0)
            container.alpha = 0.0
            titleView.alpha = 0.0
            refreshTitle.alpha = 1.0
            loadingView.alpha = 1.0
        }
    }
    
    func finishPanGesture(offset: CGFloat) {
        if isReloading == true { return }
        
        self.snp.updateConstraints { (make) in
            make.top.equalToSuperview()
        }
        superview?.setNeedsLayout()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.superview?.layoutIfNeeded()
        }) { (_) in
            
        }
        if offset < 60 {
            isReloading = false
            UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.refreshTitle.alpha = 0.0
                self.loadingView.alpha = 0.0
            }) { (_) in
                UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.container.alpha = 1.0
                    self.titleView.alpha = 1.0
                }, completion: nil)
            }
            if offset <= 30 {
                UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.container.alpha = 1.0
                    self.titleView.alpha = 1.0
                }, completion: nil)
            }
        } else {
            delegate?.hotNavigationBarViewWillStartReloading()
            innerStartReloadingAnimation()
            UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.refreshTitle.alpha = 0.0
            }) { (_) in
                UIView.animate(withDuration: 0.15, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.titleView.alpha = 1.0
                }, completion: nil)
            }
        }
    }
    
    private func innerStartReloadingAnimation() {
        isReloading = true
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = 0.5
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.repeatCount = MAXFLOAT
        loadingView.layer.add(rotateAnimation, forKey: nil)
    }
    
    func startLoading() {
        loadingView.alpha = 1.0
        container.alpha = 0.0
        innerStartReloadingAnimation()
    }
    
    func finishLoading() {
        loadingView.layer.removeAllAnimations()
        loadingView.alpha = 0.0
        container.alpha = 1.0
        isReloading = false
    }
}
