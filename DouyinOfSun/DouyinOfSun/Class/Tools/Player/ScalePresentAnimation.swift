//
//  ScalePresentAnimation.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/25.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class ScalePresentAnimation: NSObject {

}

extension ScalePresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from) as! UINavigationController
        let myPageVC = fromVC.viewControllers.last as! MyViewController
        let selectCell = myPageVC.collectionView.cellForItem(at: IndexPath(item: myPageVC.selectedCellIndex, section: 1))
        let containerView = transitionContext.containerView
        containerView.addSubview((toVC?.view)!)
        
        let initialFrame = myPageVC.collectionView.convert((selectCell?.frame)!, to: myPageVC.collectionView.superview)
        let finalFrame = transitionContext.finalFrame(for: toVC!)
        let duration = transitionDuration(using: transitionContext)
        toVC?.view.center = CGPoint(x: initialFrame.origin.x + initialFrame.size.width / 2.0, y: initialFrame.origin.y + initialFrame.size.height / 2.0)
        toVC?.view.transform = CGAffineTransform(scaleX: initialFrame.size.width / finalFrame.size.width, y: initialFrame.size.height / finalFrame.size.height)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .layoutSubviews, animations: {
            toVC?.view.center = CGPoint(x: finalFrame.origin.x + finalFrame.size.width / 2.0, y: finalFrame.origin.y + finalFrame.size.height / 2.0)
            toVC?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
