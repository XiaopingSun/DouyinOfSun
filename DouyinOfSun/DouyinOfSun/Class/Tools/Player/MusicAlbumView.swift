//
//  MusicAlbumView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/13.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

class MusicAlbumView: UIView {
    
    private var noteLayers = [CAShapeLayer]()
    
    private lazy var albumContainer: UIImageView = {
        let albumContainer = UIImageView(frame: CGRect.zero)
        albumContainer.image = UIImage(named: "music_cover")
        return albumContainer
    }()
    
    lazy var albumImageView: UIImageView = {
        let albumImageView = UIImageView(frame: CGRect.zero)
        albumImageView.contentMode = .scaleAspectFill
        return albumImageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MusicAlbumView {
    private func setupUI() {
        addSubview(albumContainer)
        albumContainer.addSubview(albumImageView)
        
        albumContainer.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        albumImageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(28)
        }
    }
    
    func startAnimation() {
        reset()

        let rate: CGFloat = 12
        initMusicNotoAnimation(imageName: "icon_home_musicnote1", delayTime: 0.0, rate: rate)
        initMusicNotoAnimation(imageName: "icon_home_musicnote2", delayTime: 1.0, rate: rate)
        initMusicNotoAnimation(imageName: "icon_home_musicnote1", delayTime: 2.0, rate: rate)
        initBackgroundRotationAnimation()
    }
    
    func pauseAnimation() {
        for layer in noteLayers {
            layer.pauseLayer()
        }
        albumContainer.layer.pauseLayer()
    }
    
    func resumeAnimation() {
        for layer in noteLayers {
            layer.resumeLayer()
        }
        albumContainer.layer.resumeLayer()
    }
    
    func reset() {
        for layer in noteLayers {
            layer.removeFromSuperlayer()
        }
        noteLayers.removeAll()
        albumContainer.layer.removeAllAnimations()
        self.layer.removeAllAnimations()
    }
    
    private func initMusicNotoAnimation(imageName: String, delayTime: TimeInterval, rate: CGFloat) {
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = CFTimeInterval(rate / 4.0)
        animationGroup.beginTime = CACurrentMediaTime() + delayTime
        animationGroup.repeatCount = Float(Int.max)
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards
        animationGroup.timingFunction = CAMediaTimingFunction(name: .linear)
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        let sideXLength: CGFloat = 50.0
        let sideYLength: CGFloat = 100.0
        let beginPoint: CGPoint = CGPoint(x: bounds.midX - 5, y: bounds.maxY + 5)
        let endPoint: CGPoint = CGPoint(x: beginPoint.x - sideXLength, y: beginPoint.y - sideYLength)
        let controlLength: CGFloat = 35
        let controlPoint: CGPoint = CGPoint(x: beginPoint.x - sideXLength/2.0 - controlLength, y: beginPoint.y - sideYLength/2.0 + controlLength)
        
        let customPath = UIBezierPath()
        customPath.move(to: beginPoint)
        customPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        pathAnimation.path = customPath.cgPath
        
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotationAnimation.values = [0, Double.pi * 0.10, Double.pi * -0.10]
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0, 0.5, 0.7, 0.3, 0]
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 2.0
        
        animationGroup.animations = [pathAnimation, scaleAnimation, rotationAnimation, opacityAnimation]
        
        let layer = CAShapeLayer()
        layer.opacity = 0.0
        layer.contents = UIImage(named: imageName)?.cgImage
        layer.frame = CGRect(x: beginPoint.x, y: beginPoint.y, width: 10, height: 10)
        self.layer.addSublayer(layer)
        noteLayers.append(layer)
        layer.add(animationGroup, forKey: nil)
    }
    
    private func initBackgroundRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = Double.pi * 2.0
        rotationAnimation.duration = 4.0
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float(Int.max)
        rotationAnimation.isRemovedOnCompletion = false
        albumContainer.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
}

