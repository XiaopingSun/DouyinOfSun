//
//  UIViewController-InteractiveGesture.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/16.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

// push动画处理类
class XPInteractivePushAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取转场容器
        let containerView: UIView = transitionContext.containerView
        
        // 获取转场前后的控制器
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        containerView.insertSubview((toVC?.view)!, aboveSubview: (fromVC?.view)!)
        
        let finalToViewFrame: CGRect = transitionContext.finalFrame(for: toVC!)
        toVC?.view.frame = finalToViewFrame.offsetBy(dx: kScreenWidth, dy: 0.0)
        fromVC?.view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toVC?.view.frame = finalToViewFrame
            fromVC?.view.frame = CGRect(x: -kScreenWidth * 0.3, y: 0, width: kScreenWidth, height: kScreenHeight)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(UINavigationController.hideShowBarDuration)
    }
}

// 处理导航栏代理的object
class XPNavigationControllerDelegateObject: NSObject, UINavigationControllerDelegate {
    var pushTransition: UIPercentDrivenInteractiveTransition?
    
    // 手势变换
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if pushTransition != nil {
            if animationController.isKind(of: XPInteractivePushAnimatedTransitioning.self) {
                return pushTransition
            }
        }
        return nil
    }
    
    // 动画变换
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if pushTransition != nil {
            if operation == .push {
                return XPInteractivePushAnimatedTransitioning()
            }
        }
        return nil
    }
}

// 处理手势代理的object
class XPGestureRecognizerDelegateObject: NSObject, UIGestureRecognizerDelegate {
    
    weak var navigationController: UINavigationController?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if navigationController?.navigationTransitionType == .none {
            return true
        }
        
        // 忽略导航控制器正在做转场动画
        if (navigationController?.value(forKey: "_isTransitioning") as! Bool) {
            return false;
        }
        
        let translation = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
        let absX: CGFloat = abs(translation.x)
        let absY: CGFloat = abs(translation.y)
        if absX > absY {
            if translation.x < 0 {// 左滑
                return navigationController?.navigationTransitionType == .leftPush
            } else {// 右滑
                return navigationController?.navigationTransitionType == .rightPop
            }
        } else if absX < absY {
            if translation.y < 0 {// 上滑
                return false
            } else {// 下滑
                return false
            }
        }
        return false
    }
    
    // 手势处理方法
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        var progress: CGFloat = -(sender.translation(in: sender.view).x / (sender.view?.bounds.size.width)!)
        progress = min(1.0, max(0.0, progress))

        switch sender.state {
        case .began:
            
            self.navigationController!.navigationControllerDelegate?.pushTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController!.navigationControllerDelegate?.pushTransition?.completionCurve = .easeInOut
            
            let interactiveGestureDelegate: UIViewControllerInteractivePushGestureDelegate? = self.navigationController!.topViewController!.interactiveGestureDelegate
            guard let destinationViewController = interactiveGestureDelegate?.destinationViewControllerFrom(fromViewController: (self.navigationController?.topViewController)!) else {return}
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
            self.navigationController!.navigationControllerDelegate?.pushTransition?.update(0)
            
        case .changed:
            
            self.navigationController!.navigationControllerDelegate?.pushTransition?.update(progress)
            
        case .ended, .cancelled:
            
            if progress >= 0.3 {
                self.navigationController!.navigationControllerDelegate?.pushTransition?.finish()
            } else {
                self.navigationController!.navigationControllerDelegate?.pushTransition?.cancel()
            }
            
        default:
            break
        }
    }
}

// UIViewController手势处理extension
extension UIViewController {
    

    private struct AssociatedKeys {
        
        static var interactiveGestureDelegateKey: UIViewControllerInteractivePushGestureDelegate? = nil
        
        static var statusBarHiddenKey: Bool = false
        
        static var statusBarStyleKey: UIStatusBarStyle = .default
    }
    
    
    
    var interactiveGestureDelegate: UIViewControllerInteractivePushGestureDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.interactiveGestureDelegateKey) as? UIViewControllerInteractivePushGestureDelegate
        }
        set(delegate) {
            objc_setAssociatedObject(self, &AssociatedKeys.interactiveGestureDelegateKey, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var statusBarHidden: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.statusBarHiddenKey) as? Bool ?? false
        }
        set(isHidden) {
            objc_setAssociatedObject(self, &AssociatedKeys.statusBarHiddenKey, isHidden, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if responds(to: #selector(setNeedsStatusBarAppearanceUpdate)) {
                _ = self.prefersStatusBarHidden
                perform(#selector(setNeedsStatusBarAppearanceUpdate))
            }
        }
    }
    
    var statusBarStyle: UIStatusBarStyle {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.statusBarStyleKey) as? UIStatusBarStyle ?? .default
        }
        set(style) {
            objc_setAssociatedObject(self, &AssociatedKeys.statusBarStyleKey, style, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if responds(to: #selector(setNeedsStatusBarAppearanceUpdate)) {
                _ = self.prefersStatusBarHidden
                perform(#selector(setNeedsStatusBarAppearanceUpdate))
            }
        }
    }
}

// 导航控制器延展
extension UINavigationController {
    
    enum XPNavigationTransitionType {
        case leftPush
        case rightPop
        case none
    }
    
    private struct AssociatedKeys {
        // 滑动方向
        static var navigationTransitionTypeKey: XPNavigationTransitionType = .none
        // 滑动手势
        static var panGestureKey: UIPanGestureRecognizer? = nil
        // 处理push动画的delegate
        static var navigationControllerDelegateKey: XPNavigationControllerDelegateObject? = nil
        // 处理panGesture的代理 shouldStart等的处理
        static var panGestureCustomTargetKey: XPGestureRecognizerDelegateObject? = nil
        // system边缘右滑返回的target
        static var systemRightPopTargetKey: Any? = nil
    }
    
    var navigationTransitionType: XPNavigationTransitionType {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navigationTransitionTypeKey) as? XPNavigationTransitionType ?? .none
        }
        set(type) {
            let previousType: XPNavigationTransitionType = objc_getAssociatedObject(self, &AssociatedKeys.navigationTransitionTypeKey) as? XPNavigationTransitionType ?? .none
            if previousType == type {return}
            
            self.interactivePopGestureRecognizer?.delegate = nil
            self.interactivePopGestureRecognizer?.isEnabled = false
            self.interactiveGestureDelegate = nil
            self.delegate = nil
            
            if type == .none {
                
            } else {
                if self.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(self.panGesture!) == false {
                    self.interactivePopGestureRecognizer?.view?.addGestureRecognizer(self.panGesture!)
                }
                let systemAction = Selector(("handleNavigationTransition:"))
                if type == .leftPush {
                    
                    interactiveGestureDelegate = self as? UIViewControllerInteractivePushGestureDelegate
                    self.delegate = self.navigationControllerDelegate
                    self.panGesture?.removeTarget(self.systemRightPopTarget, action: systemAction)
                    self.panGesture?.addTarget(self.panGestureCustomTarget as Any, action: #selector(XPGestureRecognizerDelegateObject.handlePanGesture(sender:)))
                } else {
                    self.panGesture?.removeTarget(self.panGestureCustomTarget as Any, action: #selector(XPGestureRecognizerDelegateObject.handlePanGesture(sender:)))
                    self.panGesture?.addTarget(self.systemRightPopTarget as Any, action: systemAction)
                }
            }
            objc_setAssociatedObject(self, &AssociatedKeys.navigationTransitionTypeKey, type, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var panGesture: UIPanGestureRecognizer? {
        get {
            guard let panGesture = objc_getAssociatedObject(self, &AssociatedKeys.panGestureKey) else {
                let panGesture = UIPanGestureRecognizer()
                panGesture.maximumNumberOfTouches = 1
                panGesture.delegate = self.panGestureCustomTarget
                objc_setAssociatedObject(self, &AssociatedKeys.panGestureKey, panGesture, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return panGesture
            }
            return panGesture as? UIPanGestureRecognizer
        }
    }
    
    var navigationControllerDelegate: XPNavigationControllerDelegateObject? {
        get {
            guard let navigationControllerDelegate = objc_getAssociatedObject(self, &AssociatedKeys.navigationControllerDelegateKey) else {
            let navigationControllerDelegate = XPNavigationControllerDelegateObject()
            objc_setAssociatedObject(self, &AssociatedKeys.navigationControllerDelegateKey, navigationControllerDelegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return navigationControllerDelegate
            }
            return navigationControllerDelegate as? XPNavigationControllerDelegateObject
        }
    }
    
    var panGestureCustomTarget: XPGestureRecognizerDelegateObject? {
        get {
            guard let panGestureCustomTarget = objc_getAssociatedObject(self, &AssociatedKeys.panGestureCustomTargetKey) else {
            let panGestureCustomTarget = XPGestureRecognizerDelegateObject()
            panGestureCustomTarget.navigationController = self
                
            objc_setAssociatedObject(self, &AssociatedKeys.panGestureCustomTargetKey, panGestureCustomTarget, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return panGestureCustomTarget
            }
            return panGestureCustomTarget as? XPGestureRecognizerDelegateObject
        }
    }
    
    var systemRightPopTarget: Any? {
        get {
            guard let systemRightPopTarget = objc_getAssociatedObject(self, &AssociatedKeys.systemRightPopTargetKey) else {
                // panGesture绑定系统pop手势的target和action
                guard let systemGesture = self.interactivePopGestureRecognizer else {return nil}
                let targets = systemGesture.value(forKey: "_targets") as? [NSObject]
                guard let targetObject = targets?.first else {return nil}
                guard let target = targetObject.value(forKey: "target") else {return nil}
                
                objc_setAssociatedObject(self, &AssociatedKeys.systemRightPopTargetKey, target, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return target
            }
            return systemRightPopTarget
        }
    }
    
    open override var prefersStatusBarHidden: Bool {
        return visibleViewController?.statusBarHidden ?? false
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return visibleViewController?.statusBarStyle ?? .default
    }
}

// 需要控制器实现的代理，决定push到哪个控制器
protocol UIViewControllerInteractivePushGestureDelegate: class {
    func destinationViewControllerFrom(fromViewController: UIViewController) -> UIViewController
}
