//
//  FollowScalePresentTransition.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/4/17.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

class FollowScalePresentTransition: NSObject {
    private var currentCell: FollowTableViewCell?
    private var needRotation: Bool = false
    init(cell: FollowTableViewCell, needRotation: Bool) {
        self.currentCell = cell
        self.needRotation = needRotation
    }
}

extension FollowScalePresentTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let presentedViewController = transitionContext.viewController(forKey: .to)
        let presentedView: UIView? = transitionContext.view(forKey: .to)
        let containerView = transitionContext.containerView
        containerView.addSubview(presentedView!)
        
        currentCell?.playerView.playerViewFrame = (currentCell?.playerView.frame)!
        let playerFrameInVC = currentCell?.convert((currentCell?.playerView.frame) ?? .zero, to: presentedView)
        guard let initialFrame = playerFrameInVC else { return }
        let finalFrame = transitionContext.finalFrame(for: presentedViewController!)
        let duration = transitionDuration(using: transitionContext)
        
        if needRotation == false {
            presentedView?.center = CGPoint(x: initialFrame.origin.x + initialFrame.size.width / 2.0, y: initialFrame.origin.y + initialFrame.size.height / 2.0)
            presentedView?.transform = CGAffineTransform(scaleX: initialFrame.size.width / finalFrame.size.width, y: initialFrame.size.height / finalFrame.size.height)
            currentCell?.playerView.removeFromSuperview()
            presentedView?.addSubview((currentCell?.playerView)!)
            currentCell?.playerView.snp.removeConstraints()
            currentCell?.playerView.snp.makeConstraints({ (make) in
                make.edges.equalTo(presentedView!)
            })
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                presentedView?.center = CGPoint(x: finalFrame.origin.x + finalFrame.size.width / 2.0, y: finalFrame.origin.y + finalFrame.size.height / 2.0)
                presentedView?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (_) in
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
            }
        } else {
            presentedView?.bounds = (currentCell?.playerView.bounds)!
            presentedView?.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
            presentedView?.center = CGPoint(x: (currentCell?.playerView.frame.midX)!, y: (currentCell?.playerView.frame.midY)!)
            currentCell?.playerView.removeFromSuperview()
            presentedView?.addSubview((currentCell?.playerView)!)
            currentCell?.playerView.snp.removeConstraints()
            currentCell?.playerView.snp.makeConstraints({ (make) in
                make.edges.equalTo(presentedView!)
            })
            UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                presentedView?.transform = CGAffineTransform.identity
                presentedView?.frame = finalFrame
            }) { (_) in
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
            }
        }
        

    }
}

