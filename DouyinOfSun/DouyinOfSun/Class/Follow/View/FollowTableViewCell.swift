//
//  FollowTableViewCell.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/29.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit
import HandyJSON

private let kPortraitHeight: CGFloat = 40
class FollowTableViewCell: UITableViewCell {
    
    private lazy var portraitImageView: UIImageView = {
        let portraitImageView = UIImageView(frame: .zero)
        portraitImageView.layer.masksToBounds = true
        portraitImageView.layer.cornerRadius = kPortraitHeight / 2.0
        return portraitImageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel(frame: .zero)
        nicknameLabel.text = "@测试nickname"
        nicknameLabel.textColor = UIColor(r: 232, g: 232, b: 234)
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        return nicknameLabel
    }()
    
    private lazy var moreImageView: UIImageView = {
        let moreImageView = UIImageView(frame: .zero)
        moreImageView.image = UIImage(named: "icon_modern_feed_more_25x25_")
        return moreImageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.text = "测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述测试描述"
        descriptionLabel.textColor = UIColor(r: 232, g: 232, b: 234)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        return descriptionLabel
    }()
    
    private lazy var playerView: UIView = {
        let playerView = UIView(frame: .zero)
        return playerView
    }()
    
    private lazy var repostButton: UIButton = {
        let repostButton = UIButton(type: UIButton.ButtonType.custom)
        repostButton.setImage(UIImage(named: "icon_modern_feed_repost_25x25_"), for: .normal)
        repostButton.setTitle("转发", for: .normal)
        repostButton.setTitleColor(UIColor(r: 232, g: 232, b: 234), for: .normal)
        repostButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        repostButton.addTarget(self, action: #selector(repostButtonAction(sender:)), for: .touchUpInside)
        return repostButton
    }()
    
    private lazy var commentButton: UIButton = {
        let commentButton = UIButton(type: UIButton.ButtonType.custom)
        commentButton.setImage(UIImage(named: "icon_modern_feed_comment_25x25_"), for: .normal)
        commentButton.setTitle("评论", for: .normal)
        commentButton.setTitleColor(UIColor(r: 232, g: 232, b: 234), for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        commentButton.addTarget(self, action: #selector(commentButtonAction(sender:)), for: .touchUpInside)
        return commentButton
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton(type: UIButton.ButtonType.custom)
        favoriteButton.setImage(UIImage(named: "icon_modern_feed_like_before_25x25_"), for: .normal)
        favoriteButton.setTitle("评论", for: .normal)
        favoriteButton.setTitleColor(UIColor(r: 232, g: 232, b: 234), for: .normal)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction(sender:)), for: .touchUpInside)
        return favoriteButton
    }()
    
    private lazy var line: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = UIColor(r: 232, g: 232, b: 234)
        return line
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func repostButtonAction(sender: UIButton) {
        
    }
    
    @objc private func commentButtonAction(sender: UIButton) {
        
    }
    
    @objc private func favoriteButtonAction(sender: UIButton) {
        
    }
}

extension FollowTableViewCell {
    private func initSubviews() {
        
    }
}
