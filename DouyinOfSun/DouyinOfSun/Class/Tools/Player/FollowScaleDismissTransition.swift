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
    init(cell: FollowTableViewCell) {
        self.currentCell = cell
    }
}

extension FollowScaleDismissTransition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from) as! PlayerVerticalFullScreenViewController
        let containerView = transitionContext.containerView
        self.currentCell?.playerView.removeFromSuperview()
        containerView.addSubview((self.currentCell?.playerView)!)
        self.currentCell?.playerView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
         
        let finalFrameInCell: CGRect = currentCell?.playerView.playerViewFrame ?? .zero
        let finalFrameInVC: CGRect = (currentCell?.convert(finalFrameInCell, to: fromVC.view))!
        let duration = transitionDuration(using: transitionContext)
        containerView.snp.makeConstraints { (make) in
            make.center.equalTo(CGPoint(x: finalFrameInVC.origin.x + finalFrameInVC.size.width / 2.0, y: finalFrameInVC.origin.y + finalFrameInVC.size.height / 2.0))
        }
        containerView.transform = CGAffineTransform(scaleX: kScreenWidth / (finalFrameInVC.size.width), y: kScreenHeight / (finalFrameInVC.size.height))
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            containerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            self.currentCell?.playerView.removeFromSuperview()
            self.currentCell?.addSubview((self.currentCell?.playerView)!)
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

