//
//  PlayerStatusBarView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/13.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

class PlayerStatusBarView: UIView {
    
    enum PlayerStatusBarViewStatus {
        case progress
        case caching
    }
    
    private var currentProgress: CGFloat = 0
    private var isChangingVolume: Bool = false
    private var status: PlayerStatusBarViewStatus = .progress
    private var lastChangeVolumeTime: CFTimeInterval = 0
    private var isVolumeDismissing: Bool = false
    private lazy var progressView: UIView = {
        let progressView = UIView(frame: CGRect.zero)
        progressView.backgroundColor = UIColor.white
        progressView.isHidden = false
        progressView.alpha = 1
        return progressView
    }()
    
    private lazy var cachingView: UIView = {
        let cachingView = UIView(frame: CGRect.zero)
        cachingView.backgroundColor = UIColor.white
        cachingView.isHidden = true
        cachingView.alpha = 0.0
        return cachingView
    }()
    
    private lazy var volumeView: UIView = {
        let volumeView = UIView(frame: CGRect.zero)
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
        
        progressView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
        volumeView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
        cachingView.snp.makeConstraints { (make) in
            make.centerX.top.bottom.equalToSuperview()
            make.width.equalTo(1.0)
        }
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
        if progress == currentProgress {
            return
        }
        if progress < currentProgress {
            self.progressView.snp.updateConstraints { (make) in
                make.width.equalTo(kScreenWidth)
            }
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                self.progressView.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
                self.setNeedsLayout()
                self.layoutIfNeeded()
                self.progressView.snp.updateConstraints({ (make) in
                    make.width.equalTo(progress * kScreenWidth)
                })
                self.setNeedsLayout()
                UIView.animate(withDuration: 0.2, animations: {
                    self.layoutIfNeeded()
                })
            }
        } else {
            self.progressView.snp.updateConstraints { (make) in
                make.width.equalTo(progress * kScreenWidth)
            }
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.5, animations: {
                self.layoutIfNeeded()
            })
        }
        self.currentProgress = progress
    }
    
    func updateVolume(newValue: CGFloat, oldValue: CGFloat) {
        self.isVolumeDismissing = false
        let interval = CACurrentMediaTime() - lastChangeVolumeTime
        if interval < 0.2 {
            self.isVolumeDismissing = true
        } else if interval < 1.0 {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismissVolumeView), object: nil)
        } else if interval < 1.3 && interval > 1.0 {
            self.isVolumeDismissing = true
        } else if interval < 1.6 {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(showOtherViewAfterVolumeViewDismissed), object: nil)
        }
        
        self.volumeView.snp.updateConstraints { (make) in
            make.width.equalTo(oldValue * kScreenWidth)
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        volumeView.isHidden = false
        volumeView.alpha = 1.0

        self.isChangingVolume = true
        if status == .progress {
            progressView.isHidden = true
            progressView.alpha = 0.0
            self.volumeView.snp.updateConstraints { (make) in
                make.width.equalTo(newValue * kScreenWidth)
            }
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                self.lastChangeVolumeTime = CACurrentMediaTime()
                self.perform(#selector(self.dismissVolumeView), with: nil, afterDelay: 1.0)
            }
        } else if status == .caching {
            cachingView.isHidden = true
            cachingView.alpha = 0.0
            cachingView.layer.removeAllAnimations()
            self.volumeView.snp.updateConstraints { (make) in
                make.width.equalTo(newValue * kScreenWidth)
            }
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.layoutIfNeeded()
            }) { (_) in
                self.lastChangeVolumeTime = CACurrentMediaTime()
                if self.isVolumeDismissing == false {
                    self.perform(#selector(self.dismissVolumeView), with: nil, afterDelay: 1.0)
                }
            }
        }
    }
    
    @objc private func dismissVolumeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.volumeView.alpha = 0.0
        }, completion: { (_) in
            self.lastChangeVolumeTime = CACurrentMediaTime()
            if self.isVolumeDismissing == false {
                self.perform(#selector(self.showOtherViewAfterVolumeViewDismissed), with: nil, afterDelay: 0.3)
            }
        })
    }
    
    @objc private func showOtherViewAfterVolumeViewDismissed() {
        self.volumeView.isHidden = true
        if self.status == .caching {
            self.isChangingVolume = false
            self.showCachingAnimation()
        } else {
            self.progressView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.progressView.alpha = 1.0
            }, completion: { (_) in
                self.isChangingVolume = false
            })
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
        isVolumeDismissing = false
        isChangingVolume = false
        lastChangeVolumeTime = 0
        cachingView.layer.removeAllAnimations()
        progressView.snp.updateConstraints { (make) in
            make.width.equalTo(0)
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
