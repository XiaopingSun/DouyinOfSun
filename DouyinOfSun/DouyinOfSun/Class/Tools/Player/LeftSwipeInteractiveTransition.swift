//
//  LeftSwipeInteractiveTransition.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/25.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class LeftSwipeInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var isInteracting: Bool = false
    
    private weak var presentingVC: UIViewController?
    private var viewControllerCenter: CGPoint = .zero
    
    func wireToViewController(viewController: MyAwemeViewController) {
        self.presentingVC = viewController
        self.viewControllerCenter = viewController.view.center
        viewController.view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:))))
    }
    
    @objc private func handleGesture(sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: sender.view?.superview)
        if isInteracting == false && (transition.x < 0 || transition.y < 0 || transition.x < transition.y) {
            return
        }
        switch sender.state {
        case .began:
            isInteracting = true
            presentingVC?.statusBarHidden = false
        case .changed:
            var progress = transition.x / kScreenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            
            let ratio = CGFloat(1.0 - progress * 0.5)
            presentingVC?.view.center = CGPoint(x: viewControllerCenter.x + transition.x * ratio, y: viewControllerCenter.y + transition.y * ratio)
            presentingVC?.view.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            update(progress)
        case .cancelled, .ended:
            var progress = transition.x / kScreenWidth
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            if progress < 0.2 {
                UIView.animate(withDuration: TimeInterval(progress), delay: 0, options: .curveEaseOut, animations: {
                    self.presentingVC?.view.center = CGPoint(x: kScreenWidth / 2.0, y: kScreenHeight / 2.0)
                    self.presentingVC?.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }) { (_) in
                    self.isInteracting = false
                    self.presentingVC?.statusBarHidden = true
                    self.cancel()
                }
            } else {
                self.isInteracting = false
                self.finish()
                presentingVC?.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
}
