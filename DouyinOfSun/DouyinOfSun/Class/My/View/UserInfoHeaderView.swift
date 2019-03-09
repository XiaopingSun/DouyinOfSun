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
private let kBottomImageHeight: CGFloat = 340
private let kBottomImageTop: CGFloat = 116
private let kTabbarFooterHeight: CGFloat = 36
private let kAvatarRedius: Double = 54
private let kAvatarTopOffset: Double = 16
private let kButtonRedius: CGFloat = 2.0

protocol UserInfoHeaderViewDelegate: class {
    func userInfoHeaderViewPortraitImageViewDidSelected()
    func userInfoHeaderViewGithubButtonDidSelected()
    func userInfoHeaderViewSendMessageButtonDidSelected()
    func userInfoHeaderView(headerView: UserInfoHeaderView, tabbarDidSelectedWithType type: UserInfoHeaderTabbarType)
}

class UserInfoHeaderView: UICollectionReusableView {
    
    weak var delegate: UserInfoHeaderViewDelegate?
    var user: user? {
        didSet {
            portraitImageV.setImageWithURL(imageUrl: URL(string: user?.avatar_medium?.url_list?.first ?? "")!) {[weak self] (image, error) in
                self?.portraitImageV.image = image
            }
            bottomImageView.setImageWithURL(imageUrl: URL(string: user?.avatar_larger?.url_list?.first ?? "")!) {[weak self] (image, error) in
                self?.bottomImageView.image = image
            }
            let cover_url = user?.cover_url?.first
            topAvatarImageV.setImageWithURL(imageUrl: URL(string: cover_url?.url_list?.first ?? "")!) {[weak self] (image, error) in
                self?.topAvatarImageV.image = image
            }
            nickNameLabel.text = user?.nickname
            douyinNumberLabel.text = "抖音号: " + (user?.short_id ?? "")
            if user?.signature != "" {
                briefLabel.text = user?.signature
            }
            genderButton.setImage(UIImage(named: user?.gender == 2 ? "icon_boy_12x12_" : "icon_girl_12x12_"), for: .normal)
            locationLabel.text = (user?.province ?? "辽宁") + "·" + (user?.city ?? "鞍山")
            likeNumberLabel.attributedText = getStatisticAttributedString(string1: String(user?.total_favorited ?? 0), string2: " 获赞")
            followNumberLabel.attributedText = getStatisticAttributedString(string1: String(user?.following_count ?? 0), string2: " 关注")
            fansNumberLabel.attributedText = getStatisticAttributedString(string1: String(user?.follower_count ?? 0), string2: " 粉丝")
            tabbar.setAwemeNumber(productionsNum: user?.aweme_count ?? 0, favoritesNum: user?.favoriting_count ?? 0)
        }
    }
    
    private lazy var topAvatarImageV: UIImageView = {
        let topAvatarImageV = UIImageView(frame: CGRect.zero)
        topAvatarImageV.contentMode = .scaleToFill
        topAvatarImageV.image = UIImage(named: "cover_default")
        return topAvatarImageV
    }()
    
    private lazy var bottomImageView: UIImageView = {
        let bottomImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kBottomImageHeight))
        bottomImageView.image = UIImage(named: "img_find_default")
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
    
    private lazy var moreButton: UIButton = {
        let moreButton = UIButton(type: UIButton.ButtonType.custom)
        moreButton.backgroundColor = UIColor(r: 66, g: 66, b: 73, alpha: 1)
        moreButton.layer.masksToBounds = true
        moreButton.layer.cornerRadius = kButtonRedius
        moreButton.setImage(UIImage(named: "icArrowDownHighlight_10x10_"), for: .normal)
        return moreButton
    }()
    
    private lazy var followButton: UIButton = {
        let followButton = UIButton(type: UIButton.ButtonType.custom)
        followButton.setTitle("关注", for: .normal)
        followButton.setImage(UIImage(named: "icon_personal_add_little"), for: .normal)
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        followButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
        followButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        followButton.setTitleColor(UIColor.white, for: .normal)
        followButton.layer.masksToBounds = true
        followButton.layer.cornerRadius = kButtonRedius
        followButton.backgroundColor = UIColor(r: 241, g: 47, b: 84, alpha: 1)
        followButton.isHidden = false
        followButton.alpha = 1
        followButton.addTarget(self, action: #selector(followButtonDidSelected(sender:)), for: .touchUpInside)
        return followButton
    }()
    
    private lazy var isFollowedButton: UIButton = {
        let isFollowedButton = UIButton(type: UIButton.ButtonType.custom)
        isFollowedButton.setImage(UIImage(named: "ic60FollowingProfile_19x19_"), for: .normal)
        isFollowedButton.layer.masksToBounds = true
        isFollowedButton.layer.cornerRadius = kButtonRedius
        isFollowedButton.backgroundColor = UIColor(r: 66, g: 66, b: 73, alpha: 1)
        isFollowedButton.isHidden = true
        isFollowedButton.alpha = 0
        isFollowedButton.addTarget(self, action: #selector(isFollowedButtonDidSelected(sender:)), for: .touchUpInside)
        return isFollowedButton
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let sendMessageButton = UIButton(type: UIButton.ButtonType.custom)
        sendMessageButton.setTitle("发消息", for: .normal)
        sendMessageButton.setTitleColor(UIColor.white, for: .normal)
        sendMessageButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sendMessageButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        sendMessageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 0, right: 0)
        sendMessageButton.setImage(UIImage(named: "im_x_profile_send_msg_btn_icon_19x19_"), for: .normal)
        sendMessageButton.layer.masksToBounds = true
        sendMessageButton.layer.cornerRadius = kButtonRedius
        sendMessageButton.backgroundColor = UIColor(r: 66, g: 66, b: 73, alpha: 1)
        sendMessageButton.isHidden = true
        sendMessageButton.alpha = 0
        sendMessageButton.addTarget(self, action: #selector(sendMessageButtonDidSelected(sender:)), for: .touchUpInside)
        return sendMessageButton
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel(frame: CGRect.zero)
        nickNameLabel.text = "name:"
        nickNameLabel.textColor = UIColor.white
        nickNameLabel.font = UIFont.boldSystemFont(ofSize: 26)
        return nickNameLabel
    }()
    
    private lazy var douyinNumberLabel: UILabel = {
        let douyinNumberLabel = UILabel(frame: CGRect.zero)
        douyinNumberLabel.text = "抖音号："
        douyinNumberLabel.textColor = UIColor.white
        douyinNumberLabel.font = UIFont.boldSystemFont(ofSize: 12)
        return douyinNumberLabel
    }()
    
    private lazy var githubButton: UIButton = {
        let githubButton = UIButton(type: UIButton.ButtonType.custom)
        githubButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        githubButton.setTitle("Github主页", for: .normal)
        githubButton.setTitleColor(UIColor.white, for: .normal)
        githubButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        githubButton.setImage(UIImage(named: "icon_github"), for: .normal)
        githubButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 0)
        githubButton.addTarget(self, action: #selector(githubButtonDidSelected(sender:)), for: .touchUpInside)
        return githubButton
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let arrowImageView = UIImageView(frame: CGRect.zero)
        arrowImageView.image = UIImage(named: "icon_arrow")
        return arrowImageView
    }()
    
    private lazy var splitLine: UIView = {
        let splitLine = UIView(frame: CGRect.zero)
        splitLine.backgroundColor = UIColor(r: 255, g: 255, b: 255, alpha: 0.2)
        return splitLine
    }()
    
    private lazy var briefLabel: UILabel = {
        let briefLabel = UILabel(frame: CGRect.zero)
        briefLabel.text = "本宝宝暂时还没想到个性的签名"
        briefLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        briefLabel.font = UIFont.systemFont(ofSize: 12)
        briefLabel.numberOfLines = 0
        return briefLabel
    }()
    
    private lazy var genderButton: UIButton = {
        let genderButton = UIButton(type: UIButton.ButtonType.custom)
        genderButton.backgroundColor = UIColor(r: 66, g: 66, b: 73, alpha: 1)
        genderButton.setTitle("25岁", for: .normal)
        genderButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 0.6), for: .normal)
        genderButton.setImage(UIImage(named: "icon_boy_12x12_"), for: .normal)
        genderButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        genderButton.layer.masksToBounds = true
        genderButton.layer.cornerRadius = kButtonRedius
        genderButton.isEnabled = false
        return genderButton
    }()
    
    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel(frame: CGRect.zero)
        locationLabel.backgroundColor = UIColor(r: 66, g: 66, b: 73, alpha: 1)
        locationLabel.text = "辽宁·鞍山"
        locationLabel.textAlignment = .center
        locationLabel.layer.masksToBounds = true
        locationLabel.layer.cornerRadius = kButtonRedius
        locationLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        locationLabel.font = UIFont.systemFont(ofSize: 12)
        return locationLabel
    }()
    
    private lazy var likeNumberLabel: UILabel = {
        let likeNumberLabel = UILabel(frame: CGRect.zero)
        likeNumberLabel.text = "获赞"
        likeNumberLabel.textColor = UIColor.white
        likeNumberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return likeNumberLabel
    }()
    
    private lazy var followNumberLabel: UILabel = {
        let followNumberLabel = UILabel(frame: CGRect.zero)
        followNumberLabel.text = "关注"
        followNumberLabel.textColor = UIColor.white
        followNumberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return followNumberLabel
    }()
    
    private lazy var fansNumberLabel: UILabel = {
        let fansNumberLabel = UILabel(frame: CGRect.zero)
        fansNumberLabel.text = "粉丝"
        fansNumberLabel.textColor = UIColor.white
        fansNumberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        return fansNumberLabel
    }()
    
    private lazy var tabbar: UserInfoHeaderTabbar = {
        let tabbar = UserInfoHeaderTabbar(frame: CGRect.zero)
        tabbar.delegate = self
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
    func updateHeaderView(contentOffset: CGPoint) {
        if contentOffset.y < 0 {
            topAvatarImageV.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(contentOffset.y)
                make.centerX.equalToSuperview()
                make.height.equalTo(kTopAvatarImageHeight - contentOffset.y)
                make.width.equalTo((-contentOffset.y) / 211 * 375 + kScreenWidth)
            }
        } else {
            if contentOffset.y + kStatusBarH + kNavigationBarH + kTabbarFooterHeight - frame.size.height > 0 {
                clearMaskView.alpha = 0
            } else {
                topAvatarImageV.snp.updateConstraints { (make) in
                    make.top.equalToSuperview().offset(contentOffset.y / 2.0)
                }
                if contentOffset.y + kStatusBarH + kNavigationBarH + kTabbarFooterHeight - frame.size.height + 120.0 > 0 {
                    let percent: CGFloat = -(contentOffset.y + kStatusBarH + kNavigationBarH + kTabbarFooterHeight - frame.size.height) / 120.0
                    clearMaskView.alpha = percent
                } else {
                    clearMaskView.alpha = 1
                }
            }
        }
    }
    
    @objc private func followButtonDidSelected(sender: UIButton) {
        self.isFollowedButton.isHidden = false
        self.sendMessageButton.isHidden = false
        isFollowedButton.snp.remakeConstraints { (make) in
            make.top.height.width.equalTo(moreButton)
            make.right.equalTo(moreButton.snp.left).offset(-4)
        }
        followButton.snp.makeConstraints { (make) in
            make.top.height.equalTo(moreButton)
            make.right.equalTo(moreButton.snp.left).offset(-4)
            make.width.equalTo(0)
        }
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.25, animations: {
            self.isFollowedButton.alpha = 1
            self.sendMessageButton.alpha = 1
            self.layoutIfNeeded()
        }) {(_) in
            self.followButton.isHidden = true
        }
    }
    
    @objc private func isFollowedButtonDidSelected(sender: UIButton) {
        self.followButton.isHidden = false
        isFollowedButton.snp.remakeConstraints { (make) in
            make.top.height.width.equalTo(moreButton)
            make.right.equalTo(moreButton.snp.left).offset(-80)
        }
        followButton.snp.remakeConstraints { (make) in
            make.top.height.equalTo(moreButton)
            make.right.equalTo(moreButton.snp.left).offset(-4)
            make.width.equalTo(120)
        }
        
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.25, animations: {
            self.isFollowedButton.alpha = 0
            self.sendMessageButton.alpha = 0
            self.layoutIfNeeded()
        }) {(_) in
            self.isFollowedButton.isHidden = true
            self.sendMessageButton.isHidden = true
        }
    }
    
    @objc private func sendMessageButtonDidSelected(sender: UIButton) {
        delegate?.userInfoHeaderViewSendMessageButtonDidSelected()
    }
    
    @objc private func portraitImageViewDidSelected() {
        delegate?.userInfoHeaderViewPortraitImageViewDidSelected()
    }
    
    @objc private func githubButtonDidSelected(sender: UIButton) {
        delegate?.userInfoHeaderViewGithubButtonDidSelected()
    }
}

extension UserInfoHeaderView {
    private func setupUI() {
        addSubview(topAvatarImageV)
        addSubview(bottomImageView)
        addSubview(clearMaskView)
        clearMaskView.addSubview(portraitImageV)
        clearMaskView.addSubview(moreButton)
        clearMaskView.addSubview(followButton)
        clearMaskView.addSubview(isFollowedButton)
        clearMaskView.addSubview(sendMessageButton)
        clearMaskView.addSubview(nickNameLabel)
        clearMaskView.addSubview(douyinNumberLabel)
        clearMaskView.addSubview(githubButton)
        clearMaskView.addSubview(arrowImageView)
        clearMaskView.addSubview(splitLine)
        clearMaskView.addSubview(briefLabel)
        clearMaskView.addSubview(genderButton)
        clearMaskView.addSubview(locationLabel)
        clearMaskView.addSubview(likeNumberLabel)
        clearMaskView.addSubview(followNumberLabel)
        clearMaskView.addSubview(fansNumberLabel)
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
        moreButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(40)
            make.height.equalTo(38)
        }
        followButton.snp.makeConstraints { (make) in
            make.top.height.equalTo(moreButton)
            make.right.equalTo(moreButton.snp.left).offset(-4)
            make.width.equalTo(120)
        }
        isFollowedButton.snp.makeConstraints { (make) in
            make.top.height.width.equalTo(moreButton)
            make.right.equalTo(moreButton.snp.left).offset(-80)
        }
        sendMessageButton.snp.makeConstraints { (make) in
            make.top.height.equalTo(moreButton)
            make.right.equalTo(isFollowedButton.snp.left).offset(-4)
            make.width.equalTo(84)
        }
        nickNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(portraitImageV)
            make.top.equalTo(portraitImageV.snp.bottom).offset(12)
        }
        douyinNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(portraitImageV)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(8)
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(moreButton)
            make.centerY.equalTo(douyinNumberLabel)
            make.height.width.equalTo(10)
        }
        githubButton.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImageView.snp.left).offset(2)
            make.centerY.equalTo(douyinNumberLabel)
            make.width.equalTo(82)
        }
        splitLine.snp.makeConstraints { (make) in
            make.top.equalTo(douyinNumberLabel.snp.bottom).offset(12)
            make.left.equalTo(douyinNumberLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(0.2)
        }
        briefLabel.snp.makeConstraints { (make) in
            make.left.equalTo(splitLine)
            make.top.equalTo(splitLine.snp.bottom).offset(12)
        }
        genderButton.snp.makeConstraints { (make) in
            make.left.equalTo(briefLabel)
            make.top.equalTo(briefLabel.snp.bottom).offset(12)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        locationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(genderButton.snp.right).offset(4)
            make.top.height.equalTo(genderButton)
            make.width.equalTo(68)
        }
        likeNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(genderButton)
            make.top.equalTo(genderButton.snp.bottom).offset(18)
        }
        followNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(likeNumberLabel.snp.right).offset(18)
            make.top.equalTo(likeNumberLabel)
        }
        fansNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(followNumberLabel.snp.right).offset(18)
            make.top.equalTo(followNumberLabel)
        }
        tabbar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(kTabbarFooterHeight)
        }
    }
    
    private func getStatisticAttributedString(string1: String, string2: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let attributedString1 = NSAttributedString(string: string1, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        let attributedString2 = NSAttributedString(string: string2, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
        attributedString.append(attributedString1)
        attributedString.append(attributedString2)
        return attributedString
    }
}

extension UserInfoHeaderView: UserInfoHeaderTabbarDelegate {
    func userInfoHeaderTabbar(headerTabbar: UserInfoHeaderTabbar, didSelectedWithType type: UserInfoHeaderTabbarType) {
        self.delegate?.userInfoHeaderView(headerView: self, tabbarDidSelectedWithType: type)
    }
}
