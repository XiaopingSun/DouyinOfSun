//
//  ScaleDismissAnimation.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/25.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class ScaleDismissAnimation: NSObject {

}

extension ScaleDismissAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from) as! MyAwemeViewController
        let toVC = transitionContext.viewController(forKey: .to) as! UINavigationController
        let myPageVC: MyViewController = toVC.viewControllers.last as! MyViewController
        let selectCell = myPageVC.collectionView.cellForItem(at: IndexPath(item: fromVC.currentIndex, section: 1))
        
        var snapshotView: UIView?
        var scaleRatio: CGFloat = 0
        var finalFrame: CGRect = .zero
        if selectCell != nil {
            snapshotView = selectCell?.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.size.width / (selectCell?.frame.size.width)!
            snapshotView?.layer.zPosition = 20
            finalFrame = myPageVC.collectionView.convert((selectCell?.frame)!, to: myPageVC.collectionView.superview)
        } else {
            snapshotView = fromVC.view.snapshotView(afterScreenUpdates: false)
            scaleRatio = fromVC.view.frame.size.width / kScreenWidth
            finalFrame = CGRect(x: (kScreenWidth - 5) / 2.0, y: (kScreenHeight - 5) / 2.0, width: 5, height: 5)
        }
        let containView = transitionContext.containerView
        containView.addSubview(snapshotView!)
        let duration = transitionDuration(using: transitionContext)
        fromVC.view.alpha = 0.0
        snapshotView?.center = fromVC.view.center
        snapshotView?.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            snapshotView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            snapshotView?.frame = finalFrame
        }) { (_) in
            transitionContext.finishInteractiveTransition()
            transitionContext.completeTransition(true)
            snapshotView?.removeFromSuperview()
        }
    }
}
