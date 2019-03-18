//
//  FavoriteView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/13.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

private let kFavoriteViewLikeBeforeTag: Int = 0x01001
private let kFavoriteViewLikeAfterTag: Int = 0x01002

class FavoriteView: UIView {
    
    private var isLiked: Bool = false
    
    private lazy var isFavoritedImageView: UIImageView = {
        let isFavoritedImageView = UIImageView(frame: CGRect.zero)
        isFavoritedImageView.contentMode = .center
        isFavoritedImageView.image = UIImage(named: "icon_home_like_after")
        isFavoritedImageView.isUserInteractionEnabled = true
        isFavoritedImageView.tag = kFavoriteViewLikeAfterTag
        isFavoritedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender:))))
        return isFavoritedImageView
    }()
    
    private lazy var unFavoriteImageView: UIImageView = {
        let unFavoriteImageView = UIImageView(frame: CGRect.zero)
        unFavoriteImageView.contentMode = .center
        unFavoriteImageView.image = UIImage(named: "icon_home_like_before")
        unFavoriteImageView.isUserInteractionEnabled = true
        unFavoriteImageView.tag = kFavoriteViewLikeBeforeTag
        unFavoriteImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender:))))
        return unFavoriteImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleGesture(sender: UITapGestureRecognizer) {
        switch sender.view?.tag {
        case kFavoriteViewLikeBeforeTag:
            startLikeAnimation(true)
        case kFavoriteViewLikeAfterTag:
            startLikeAnimation(false)
        default:
            break
        }
    }
}

extension FavoriteView {
    private func setupUI() {
        addSubview(unFavoriteImageView)
        addSubview(isFavoritedImageView)
        unFavoriteImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        isFavoritedImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func startLikeAnimation(_ isLike: Bool) {
        if self.isLiked == isLike {return}
        isFavoritedImageView.isUserInteractionEnabled = false
        unFavoriteImageView.isUserInteractionEnabled = false
        isLiked = isLike
        if isLike {
            let length: CGFloat = 30
            let duration: CGFloat = 0.5
            for i in 0 ..< 5{
                let layer = CAShapeLayer()
                layer.position = unFavoriteImageView.center
                layer.fillColor = UIColor(r: 241.0, g: 47.0, b: 84.0, alpha: 1.0).cgColor
                
                let startPath = UIBezierPath()
                startPath.move(to: CGPoint(x: -2, y: -length))
                startPath.addLine(to: CGPoint(x: 2, y: -length))
                startPath.addLine(to: CGPoint(x: 0, y: 0))
                
                let endPath = UIBezierPath()
                endPath.move(to: CGPoint(x: -2, y: -length))
                endPath.addLine(to: CGPoint(x: 2, y: -length))
                endPath.addLine(to: CGPoint(x: 0, y: -length))
                
                layer.path = startPath.cgPath
                layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi / 3.0 * Double(i)), 0.0, 0.0, 1.0)
                self.layer.addSublayer(layer)
                
                let group = CAAnimationGroup()
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction(name:.easeInEaseOut)
                group.fillMode = .forwards;
                group.duration = CFTimeInterval(duration);
                
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 0.0
                scaleAnimation.toValue = 1.0
                scaleAnimation.duration = CFTimeInterval(duration * 0.2)
                
                let pathAnimation = CABasicAnimation(keyPath: "path")
                pathAnimation.fromValue = layer.path
                pathAnimation.toValue = endPath.cgPath
                pathAnimation.beginTime = CFTimeInterval(duration * 0.2)
                pathAnimation.duration = CFTimeInterval(duration * 0.8)
                
                group.animations = [scaleAnimation, pathAnimation]
                layer.add(group, forKey: nil)
            }
            
            isFavoritedImageView.isHidden = false
            isFavoritedImageView.alpha = 0.0
            isFavoritedImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5).concatenating(CGAffineTransform(rotationAngle: .pi / 3.0 * 2))
            UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseIn, animations: {
                self.unFavoriteImageView.alpha = 0.0
                self.isFavoritedImageView.alpha = 1.0
                self.isFavoritedImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(rotationAngle: 0))
            }) { (_) in
                self.unFavoriteImageView.alpha = 1.0
                self.unFavoriteImageView.isUserInteractionEnabled = true
                self.isFavoritedImageView.isUserInteractionEnabled = true
            }
        } else {
            isFavoritedImageView.alpha = 1.0
            isFavoritedImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform(rotationAngle: 0))
            UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseIn, animations: {
                self.isFavoritedImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).concatenating(CGAffineTransform(rotationAngle: -.pi / 4.0))
            }) { (_) in
                self.isFavoritedImageView.isHidden = true
                self.unFavoriteImageView.isUserInteractionEnabled = true
                self.isFavoritedImageView.isUserInteractionEnabled = true
            }
        }
    }
    
    func reset() {
        isLiked = false
        isFavoritedImageView.isHidden = true
        unFavoriteImageView.isHidden = false
        self.layer.removeAllAnimations()
    }
}
