//
//  PlayerStatusBarView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/13.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class PlayerStatusBarView: UIView {
    
    enum PlayerStatusBarViewStatus {
        case progress
        case caching
    }
    
    private var currentProgress: CGFloat = 0
    private var isChangingVolume: Bool = false
    private var status: PlayerStatusBarViewStatus = .progress
    private lazy var progressView: UIView = {
        let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height))
        progressView.backgroundColor = UIColor.white
        progressView.isHidden = false
        progressView.alpha = 1
        return progressView
    }()
    
    private lazy var cachingView: UIView = {
        let cachingView = UIView(frame: CGRect(x: self.frame.size.width - 0.5, y: 0, width: 1.0, height: self.frame.size.height))
        cachingView.backgroundColor = UIColor.white
        cachingView.isHidden = true
        cachingView.alpha = 0.0
        return cachingView
    }()
    
    private lazy var volumeView: UIView = {
        let volumeView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height))
        volumeView.backgroundColor = UIColor(r: 250.0, g: 206.0, b: 21.0, alpha: 1.0)
        volumeView.isHidden = true
        volumeView.alpha = 0.0
        return volumeView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PlayerStatusBarView {
    private func initSubviews() {
        addSubview(progressView)
        addSubview(cachingView)
        addSubview(volumeView)
    }
}

extension PlayerStatusBarView {
    func showCachingAnimation() {
        status = .caching
        if isChangingVolume == true {
            return
        }
        cachingView.isHidden = false
        cachingView.alpha = 1.0
        progressView.isHidden = true
        progressView.alpha = 0.0
        volumeView.isHidden = true
        volumeView.alpha = 0.0
        cachingView.layer.removeAllAnimations()
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.5
        animationGroup.beginTime = CACurrentMediaTime()
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animationGroup.isRemovedOnCompletion = false
        
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        scaleAnimation.values = [1.0, 0.4 * kScreenWidth, 0.6 * kScreenWidth, 0.8 * kScreenWidth, 1.0 * kScreenWidth]
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.4, 0.9, 1, 0.9, 0.2]
        
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        cachingView.layer.add(animationGroup, forKey: nil)
    }
    
    func removeCachingAnimation() {
        cachingView.layer.removeAllAnimations()
        cachingView.isHidden = true
        cachingView.alpha = 0.0
        progressView.isHidden = false
        progressView.alpha = 1.0
        status = .progress
    }
    
    func updateProgress(progress: CGFloat) {
        if progress < currentProgress {
            self.progressView.frame = CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height)
        }
        self.currentProgress = progress
        UIView.animate(withDuration: 0.5, animations: {
            self.progressView.frame = CGRect(x: 0, y: 0, width: progress * kScreenWidth, height: self.frame.size.height)
        })
    }
    
    func updateVolume(volumeScale: CGFloat) {
        if volumeView.isHidden == true {
            volumeView.isHidden = false
            volumeView.alpha = 1.0
        }

        self.isChangingVolume = true
        if status == .progress {
            progressView.isHidden = true
            progressView.alpha = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.volumeView.frame = CGRect(x: 0, y: 0, width: volumeScale * kScreenWidth, height: self.frame.size.height)
            }) { (_) in
                UIView.animate(withDuration: 0.3, delay: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.volumeView.alpha = 0.0
                }, completion: { (_) in
                    self.volumeView.isHidden = true
                    if self.status == .progress {
                        self.progressView.isHidden = false
                        UIView.animate(withDuration: 0.3, animations: {
                            self.progressView.alpha = 1.0
                        }, completion: { (_) in
                            self.isChangingVolume = false
                        })
                    } else {
                        self.isChangingVolume = false
                        self.cachingView.isHidden = false
                        self.cachingView.alpha = 1.0
                        self.showCachingAnimation()
                    }
                })
            }
        } else if status == .caching {
            cachingView.isHidden = true
            cachingView.alpha = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.volumeView.frame = CGRect(x: 0, y: 0, width: volumeScale * kScreenWidth, height: self.frame.size.height)
            }) { (_) in
                UIView.animate(withDuration: 0.3, delay: 0.2, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    self.volumeView.alpha = 0.0
                }, completion: { (_) in
                    if self.status == .caching {
                        self.isChangingVolume = false
                        self.volumeView.isHidden = true
                        self.cachingView.isHidden = false
                        self.cachingView.alpha = 1.0
                        self.showCachingAnimation()
                    } else {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.progressView.alpha = 1.0
                        }, completion: { (_) in
                            self.isChangingVolume = false
                        })
                    }
                })
            }
        }
    }
    
    func reset() {
        progressView.isHidden = false
        progressView.alpha = 1.0
        cachingView.isHidden = true
        cachingView.alpha = 0.0
        volumeView.isHidden = true
        volumeView.alpha = 0.0
        currentProgress = 0
        cachingView.layer.removeAllAnimations()
        progressView.frame = CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height)
    }
}
