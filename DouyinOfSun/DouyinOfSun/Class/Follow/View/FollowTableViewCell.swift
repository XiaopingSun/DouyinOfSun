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

private let kPortraitHeight: CGFloat = 36
class FollowTableViewCell: UITableViewCell {
    
    var aweme: aweme_list? {
        didSet {
            nicknameLabel.text = "@" + (aweme?.author?.nickname)!
            descriptionLabel.text = aweme?.desc
            portraitImageView.setImageWithURL(imageUrl: URL(string: (aweme?.author?.avatar_thumb?.url_list?.first)!)!) {[weak self] (image, error) in
                if error == nil {
                    self?.portraitImageView.image = image?.drawCircleImage()
                }
            }
            
            guard let videoUrlList = aweme?.video?.play_addr?.url_list else {return}
            var playUrl: String?
            for urlStr in videoUrlList {
                if urlStr.hasPrefix("https://aweme.snssdk.com/aweme/v1/play/") {
                    playUrl = urlStr
                    break
                }
            }
            playerView.loadPlayer(urlStr: playUrl, coverUrlStr: (aweme?.video?.origin_cover?.url_list?.first)!, musicName: (aweme?.music?.title)!, musicAuthor: (aweme?.music?.author)!)
            
            guard let width = aweme?.video?.width else { return }
            guard let height = aweme?.video?.height else { return }
            if width > height {
                playerView.snp.updateConstraints { (make) in
                    make.width.equalTo(kScreenWidth - 2 * 15)
                    make.height.equalTo((kScreenWidth - 2 * 15) / 16.0 * 9.0)
                }
            } else {
                playerView.snp.updateConstraints { (make) in
                    make.width.equalTo(310)
                    make.height.equalTo(415)
                }
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    private lazy var portraitImageView: UIImageView = {
        let portraitImageView = UIImageView(frame: .zero)
        portraitImageView.image = UIImage(named: "img_find_default")
        return portraitImageView
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel(frame: .zero)
        nicknameLabel.text = "@测试nickname"
        nicknameLabel.textColor = UIColor(r: 232, g: 232, b: 234)
        nicknameLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
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
    
    private lazy var playerView: PLFollowPlayerView = {
        let playerView = PLFollowPlayerView(frame: .zero)
//        playerView.delegate = self
        return playerView
    }()
    
    private lazy var repostButton: UIButton = {
        let repostButton = UIButton(type: UIButton.ButtonType.custom)
        repostButton.setImage(UIImage(named: "icon_modern_feed_repost_25x25_"), for: .normal)
        repostButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        repostButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        repostButton.setTitle("转发", for: .normal)
        repostButton.setTitleColor(UIColor(r: 232, g: 232, b: 234), for: .normal)
        repostButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        repostButton.addTarget(self, action: #selector(repostButtonAction(sender:)), for: .touchUpInside)
        return repostButton
    }()
    
    private lazy var commentButton: UIButton = {
        let commentButton = UIButton(type: UIButton.ButtonType.custom)
        commentButton.setImage(UIImage(named: "icon_modern_feed_comment_25x25_"), for: .normal)
        commentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        commentButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        commentButton.setTitle("赞", for: .normal)
        commentButton.setTitleColor(UIColor(r: 232, g: 232, b: 234), for: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        commentButton.addTarget(self, action: #selector(commentButtonAction(sender:)), for: .touchUpInside)
        return commentButton
    }()
    
    private lazy var favoriteButton: UIButton = {
        let favoriteButton = UIButton(type: UIButton.ButtonType.custom)
        favoriteButton.setImage(UIImage(named: "icon_modern_feed_like_before_25x25_"), for: .normal)
        favoriteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        favoriteButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        favoriteButton.setTitle("评论", for: .normal)
        favoriteButton.setTitleColor(UIColor(r: 232, g: 232, b: 234), for: .normal)
        favoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonAction(sender:)), for: .touchUpInside)
        return favoriteButton
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(r: 22, g: 24, b: 35)
        selectionStyle = .none
        initSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    @objc private func repostButtonAction(sender: UIButton) {

    }
    
    @objc private func commentButtonAction(sender: UIButton) {
        
    }
    
    @objc private func favoriteButtonAction(sender: UIButton) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 划线
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let path = CGMutablePath()
        let lineWidth: CGFloat = 0.04
        path.move(to: CGPoint(x: 0, y: bounds.size.height - lineWidth))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height - lineWidth))
        context.addPath(path)
        context.setStrokeColor(UIColor(r: 210, g: 210, b: 210).cgColor)
        context.setLineWidth(lineWidth)
        context.strokePath()
    }
}

extension FollowTableViewCell {
    private func initSubviews() {
        addSubview(portraitImageView)
        addSubview(nicknameLabel)
        addSubview(moreImageView)
        addSubview(descriptionLabel)
        addSubview(playerView)
        addSubview(repostButton)
        addSubview(commentButton)
        addSubview(favoriteButton)
        
        portraitImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(20)
            make.width.height.equalTo(kPortraitHeight)
        }
        nicknameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(portraitImageView.snp.right).offset(8)
            make.centerY.equalTo(portraitImageView)
        }
        moreImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(portraitImageView)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(portraitImageView)
            make.top.equalTo(portraitImageView.snp.bottom).offset(15)
            make.right.equalTo(moreImageView)
        }
        playerView.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.width.equalTo(310)
            make.height.equalTo(415)
        }
        favoriteButton.snp.makeConstraints { (make) in
            make.top.equalTo(playerView.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-20)
        }
        commentButton.snp.makeConstraints { (make) in
            make.right.equalTo(favoriteButton.snp.left).offset(-15)
            make.top.equalTo(favoriteButton)
            make.bottom.equalTo(favoriteButton)
        }
        repostButton.snp.makeConstraints { (make) in
            make.right.equalTo(commentButton.snp.left).offset(-15)
            make.top.equalTo(favoriteButton)
            make.bottom.equalTo(favoriteButton)
        }
    }
}

extension FollowTableViewCell {
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
}
