//
//  MyCollectionViewCell.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/28.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

private let kItemWidth: CGFloat = (kScreenWidth - 1 * 2) / 3.0
private let kItemHeight: CGFloat = kItemWidth * 1.326

class MyCollectionViewCell: UICollectionViewCell {
    
    var aweme_list: aweme_list? {
        didSet {
            guard let dynamic_cover = aweme_list?.video?.dynamic_cover?.url_list?.first else {return}
            if (dynamic_cover.hasSuffix("jpeg")) {
                imageView.setImageWithURL(imageUrl: URL(string: dynamic_cover ?? "")!) { (image, error) in
                    if error == nil {
                        self.imageView.image = image
                    }
                }
            } else {
                imageView.setWebPImageWithURL(imageUrl: URL(string: dynamic_cover ?? "")!) {[weak self] (image, error) in
                    if error == nil {
                        if let img = image as? WebPImage {
                            self?.imageView.image = img
                        }
                    }
                }
            }

            favoriteNumButton.setTitle(String.formatCount(count: NSInteger(aweme_list?.statistics?.digg_count ?? 0)), for: .normal)
        }
    }
    
    private lazy var imageView: WebPImageView = {
        let imageView = WebPImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor(r: 92.0, g: 93.0, b: 102.0, alpha: 1.0)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(r: 0.0, g: 0.0, b: 0.0, alpha: 0.2).cgColor, UIColor(r: 0.0, g: 0.0, b: 0.0, alpha: 0.6).cgColor]
        gradientLayer.locations = [0.3, 0.6, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = CGRect(x: 0, y: self.frame.size.height - 100, width: self.frame.size.width, height: 100)
        return gradientLayer
    }()
    
    private lazy var isTopImageView: UIImageView = {
        let isTopImageView = UIImageView(frame: CGRect.zero)
        isTopImageView.isHidden = true
        return isTopImageView
    }()
    
    private lazy var favoriteNumButton: UIButton = {
        let favoriteNumButton = UIButton(type: UIButton.ButtonType.custom)
        favoriteNumButton.contentHorizontalAlignment = .left
        favoriteNumButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 2, bottom: 0, right: 0)
        favoriteNumButton.setTitle("0", for: .normal)
        favoriteNumButton.setTitleColor(UIColor.white, for: .normal)
        favoriteNumButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        favoriteNumButton.setImage(UIImage.init(named: "icon_home_likenum_14x12_"), for: .normal)
        favoriteNumButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -2, bottom: 0, right: 0)
        return favoriteNumButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    class func sizeForCell() -> CGSize {
        return CGSize(width: kItemWidth, height: kItemHeight)
    }
}

extension MyCollectionViewCell {
    private func setupUI() {
        addSubview(imageView)
        imageView.layer.addSublayer(gradientLayer)
        addSubview(isTopImageView)
        addSubview(favoriteNumButton)
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        isTopImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(4)
        }
        favoriteNumButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-6)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
    }
}
