//
//  FollowScaleDismissTransition.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/4/17.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

class FollowScaleDismissTransition: NSObject {
    private var currentCell: FollowTableViewCell?
    private var needRotation: Bool = false
    init(cell: FollowTableViewCell, needRotation: Bool) {
        self.currentCell = cell
        self.needRotation = needRotation
    }
}

extension FollowScaleDismissTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to) as! UINavigationController
        let fromView = transitionContext.view(forKey: .from)!
        
        let finalFrameInCell: CGRect = currentCell?.playerView.playerViewFrame ?? .zero
        let finalFrameInVC: CGRect = (currentCell?.convert(finalFrameInCell, to: toVC.view))!
        let duration = transitionDuration(using: transitionContext)
        
        if needRotation == false {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                fromView.transform = CGAffineTransform(scaleX: finalFrameInVC.size.width / kScreenWidth, y: finalFrameInVC.size.height / kScreenHeight)
                fromView.center = CGPoint(x: finalFrameInVC.midX, y: finalFrameInVC.midY)
            }) { (_) in
                self.currentCell?.playerView.removeFromSuperview()
                self.currentCell?.addSubview((self.currentCell?.playerView)!)
                self.currentCell?.playerView.snp.removeConstraints()
                self.currentCell?.playerView.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().offset(finalFrameInCell.origin.x)
                    make.top.equalToSuperview().offset(finalFrameInCell.origin.y)
                    make.size.equalTo(finalFrameInCell.size)
                })
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
            }
        } else {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
                fromView.transform = CGAffineTransform.identity
                fromView.frame = finalFrameInVC
            }) { (_) in
                self.currentCell?.playerView.removeFromSuperview()
                self.currentCell?.addSubview((self.currentCell?.playerView)!)
                self.currentCell?.playerView.snp.removeConstraints()
                self.currentCell?.playerView.snp.makeConstraints({ (make) in
                    make.left.equalToSuperview().offset(finalFrameInCell.origin.x)
                    make.top.equalToSuperview().offset(finalFrameInCell.origin.y)
                    make.size.equalTo(finalFrameInCell.size)
                })
                transitionContext.finishInteractiveTransition()
                transitionContext.completeTransition(true)
            }
        }
    }
}

