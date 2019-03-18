//
//  FocusView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/15.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class FocusView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = frame.size.width / 2.0
    }
}

extension FocusView {
    private func setupUI() {
        self.layer.backgroundColor = UIColor(r: 241.0, g: 47.0, b: 84.0, alpha: 1.0).cgColor
        self.image = UIImage(named: "icon_personal_add_little")
        self.contentMode = .center
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beginAnimation)))
    }
    
    @objc private func beginAnimation() {
        let animationGroup = CAAnimationGroup()
        animationGroup.delegate = self
        animationGroup.duration = 1.25
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = .forwards
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [1.0, 1.2, 1.2, 1.2, 1.2, 1.2, 1.2, 0.0]
        
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        rotationAnimation.values = [-1.5 * Double.pi, 0.0, 0.0, 0.0]
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.8, 1.0, 1.0]
        
        animationGroup.animations = [scaleAnimation, rotationAnimation, opacityAnimation]
        self.layer.add(animationGroup, forKey: nil)
    }
    
    func reset() {
        self.layer.backgroundColor = UIColor(r: 241.0, g: 47.0, b: 84.0, alpha: 1.0).cgColor
        self.image = UIImage(named: "icon_personal_add_little")
        self.layer.removeAllAnimations()
        self.isHidden = false
    }
}

extension FocusView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        self.isUserInteractionEnabled = false
        self.contentMode = .scaleAspectFill
        self.layer.backgroundColor = UIColor(r: 241.0, g: 47.0, b: 84.0, alpha: 1.0).cgColor
        self.image = UIImage(named: "iconSignDone")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isUserInteractionEnabled = true
        self.contentMode = .center
        self.isHidden = true
    }
}
