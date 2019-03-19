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
            // 六瓣layer动画
            let length: CGFloat = 30
            let duration: CGFloat = 0.5
            for i in 0 ..< 6 {
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
                self.layer.insertSublayer(layer, below: isFavoritedImageView.layer)
                
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
            
            // 圆环layer动画
            let startCirclePath = UIBezierPath(arcCenter: CGPoint(x: unFavoriteImageView.center.x, y: unFavoriteImageView.center.y - 3), radius: 10, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            let endCirclePath = UIBezierPath(arcCenter: CGPoint(x: unFavoriteImageView.center.x, y: unFavoriteImageView.center.y - 3), radius: 25, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
            let circleLayer = CAShapeLayer()
            circleLayer.frame = self.bounds
            circleLayer.strokeColor = UIColor(r: 241.0, g: 47.0, b: 84.0, alpha: 1.0).cgColor
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.lineWidth = 1.5
            circleLayer.path = startCirclePath.cgPath
            self.layer.insertSublayer(circleLayer, below: unFavoriteImageView.layer)
            
            let group = CAAnimationGroup()
            group.isRemovedOnCompletion = false
            group.timingFunction = CAMediaTimingFunction(name:.easeInEaseOut)
            group.fillMode = .forwards;
            group.duration = CFTimeInterval(duration - 0.1);
            
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.fromValue = startCirclePath.cgPath
            pathAnimation.toValue = endCirclePath.cgPath
            pathAnimation.beginTime = CFTimeInterval(0)
            pathAnimation.duration = CFTimeInterval(duration - 0.1)
            
            let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
            opacityAnimation.values = [0, 1, 0]
            
            group.animations = [pathAnimation, opacityAnimation]
            circleLayer.add(group, forKey: nil)
            
            // heart动画
            isFavoritedImageView.isHidden = false
            isFavoritedImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.1, animations: {
                self.unFavoriteImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.isFavoritedImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.isFavoritedImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: { (_) in
                        self.unFavoriteImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.unFavoriteImageView.isUserInteractionEnabled = true
                        self.isFavoritedImageView.isUserInteractionEnabled = true
                    })
                })
            }
        } else {
            isFavoritedImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.isFavoritedImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
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
