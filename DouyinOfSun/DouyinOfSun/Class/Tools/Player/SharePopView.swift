//
//  SharePopView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/20.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

class SharePopView: UIView {
    
    private let itemWidth: Int = 68
    
    private var topIconsName: [String] = [
        "icon_profile_share_wxTimeline",
        "icon_profile_share_wechat",
        "icon_profile_share_qqZone",
        "icon_profile_share_qq",
        "icon_profile_share_weibo",
        "iconHomeAllshareXitong"
    ]
    
    private var topTexts: [String] = [
        "朋友圈",
        "微信好友",
        "QQ空间",
        "QQ好友",
        "微博",
        "更多分享"
    ]
    
    private var bottomIconsName: [String] = [
        "icon_home_allshare_report",
        "icon_home_allshare_download",
        "icon_home_allshare_copylink",
        "icon_home_all_share_dislike"
    ]
    
    private var bottomTexts: [String] = [
        "举报",
        "保存至相册",
        "复制链接",
        "不感兴趣"
    ]
    
    private lazy var container: UIView = {
        let container = UIView(frame: CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 280))
        container.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.6)
        
        let rounded = UIBezierPath(roundedRect: container.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        container.layer.mask = shape
        
        return container
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = self.bounds
        visualEffectView.alpha = 1.0
        return visualEffectView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 35))
        label.text = "分享到"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    private lazy var topScrollView: UIScrollView = {
        let topScrollView = UIScrollView(frame: CGRect(x: 0, y: 35, width: kScreenWidth, height: 90))
        topScrollView.contentSize = CGSize(width: itemWidth * topIconsName.count, height: 80)
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        return topScrollView
    }()
    
    private lazy var splitLine: UIView = {
        let splitLine = UIView(frame: CGRect(x: 0, y: 130, width: kScreenWidth, height: 0.5))
        splitLine.backgroundColor = UIColor(r: 1, g: 1, b: 1, alpha: 0.1)
        return splitLine
    }()
    
    private lazy var bottomScrollView: UIScrollView = {
        let bottomScrollView = UIScrollView(frame: CGRect(x: 0, y: 135, width: kScreenWidth, height: 90))
        bottomScrollView.contentSize = CGSize(width: itemWidth * bottomIconsName.count, height: 80)
        bottomScrollView.showsHorizontalScrollIndicator = false
        bottomScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        return bottomScrollView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: UIButton.ButtonType.custom)
        cancelButton.frame = CGRect(x: 0, y: 230, width: kScreenWidth, height: 50)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.backgroundColor = UIColor(r: 40.0, g: 40.0, b: 40.0, alpha: 1.0)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        let rounded = UIBezierPath(roundedRect: cancelButton.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10.0, height: 10.0))
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        cancelButton.layer.mask = shape
        return cancelButton
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender:))))
        initSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleGesture(sender: UITapGestureRecognizer) {
        var point = sender.location(in: container)
        if !container.layer.contains(point) {
            dismiss()
            return
        }
        point = sender.location(in: cancelButton)
        if cancelButton.layer.contains(point) {
            dismiss()
        }
    }
    
    @objc private func onShareItemTap(sender: UITapGestureRecognizer) {
        switch (sender.view?.tag) {
        case 0:
            break;
        default:
            break;
        }
        UIApplication.shared.openURL(URL.init(string: "https://github.com/XiaopingSun/DouyinOfSun")!)
        dismiss()
    }
    
    @objc private func onActionItemTap(sender: UITapGestureRecognizer) {
        switch (sender.view?.tag) {
        case 0:
            break;
        default:
            break;
        }
        UIApplication.shared.openURL(URL.init(string: "https://github.com/XiaopingSun/DouyinOfSun")!)
        dismiss()
    }
    
    @objc private func cancelAction() {
        
    }
}

extension SharePopView {
    private func initSubviews() {
        addSubview(container)
        container.addSubview(visualEffectView)
        container.addSubview(label)
        container.addSubview(topScrollView)
        
        for i in 0 ..< topIconsName.count {
            let item = ShareItem(frame: CGRect(x: CGFloat(20 + itemWidth * i), y: 0, width: 48, height: 90))
            item.iconImageView.image = UIImage(named: topIconsName[i])
            item.textLabel.text = topTexts[i]
            item.tag = 1000 + i
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onShareItemTap(sender:))))
            item.startAnimation(delayTime: Double(i) * 0.03)
            topScrollView.addSubview(item)
        }
        
        container.addSubview(bottomScrollView)
        
        for i in 0 ..< bottomIconsName.count {
            let item = ShareItem(frame: CGRect(x: CGFloat(20 + itemWidth * i), y: 0, width: 48, height: 90))
            item.iconImageView.image = UIImage(named: bottomIconsName[i])
            item.textLabel.text = bottomTexts[i]
            item.tag = 1000 + i
            item.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onActionItemTap(sender:))))
            item.startAnimation(delayTime: Double(i) * 0.03)
            bottomScrollView.addSubview(item)
        }
        
        container.addSubview(cancelButton)
    }
    
    func show() {
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self)
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            var frame = self.container.frame
            frame.origin.y = frame.origin.y - frame.size.height
            self.container.frame = frame
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            var frame = self.container.frame
            frame.origin.y = frame.origin.y + frame.size.height
            self.container.frame = frame
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}

class ShareItem: UIView {
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView(frame: CGRect.zero)
        iconImageView.contentMode = .scaleToFill
        iconImageView.isUserInteractionEnabled = true
        return iconImageView
    }()
    
    lazy var textLabel: UILabel = {
        let textLabel = UILabel(frame: CGRect.zero)
        textLabel.text = "text"
        textLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(iconImageView)
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(48)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        textLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation(delayTime: TimeInterval) {
        let originalFrame = self.frame
        self.frame = CGRect(x: originalFrame.minX, y: 35, width: originalFrame.size.width, height: originalFrame.size.height)
        UIView.animate(withDuration: 0.9, delay: delayTime, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
            self.frame = originalFrame
        }, completion: nil)
    }
}
