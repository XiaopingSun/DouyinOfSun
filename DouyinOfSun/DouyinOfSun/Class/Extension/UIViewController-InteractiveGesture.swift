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
    static let shared = XPGestureRecognizerDelegateObject()
    weak var navigationController: UINavigationController?
    
    private override init() {
        super.init()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        // 忽略导航控制器正在做转场动画
        if (navigationController?.value(forKey: "_isTransitioning") as! Bool) {
            return false;
        }
        
        let translation = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: gestureRecognizer.view)
        let absX: CGFloat = abs(translation.x)
        let absY: CGFloat = abs(translation.y)
        if absX > absY {
            if translation.x < 0 {// 左滑
                return true
            } else {// 右滑
                return false
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
}

// UIViewController手势处理extension
extension UIViewController {
    
    private struct AssociatedKeys {
        // 是否支持左滑push手势
        static var isLeftPushGestureEnabledKey: Bool = false
        // 是否支持右滑返回手势
        static var isRightPopGestureEnableKey: Bool = false
        
        static var interactiveGestureDelegateKey: UIViewControllerInteractivePushGestureDelegate? = nil
        
        static var panGestureKey: UIPanGestureRecognizer? = nil
        
        static var navigationControllerDelegateKey: XPNavigationControllerDelegateObject? = nil
        
        static var statusBarHiddenKey: Bool = false
    }
    
    var isLeftPushGestureEnabled: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isLeftPushGestureEnabledKey) as? Bool ?? false
        }
        set(enabled) {
            if enabled {
                assert(self.isRightPopGestureEnable == false, "left push & right pop is not support at the same time")
                
                self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.navigationController?.interactivePopGestureRecognizer!.view?.removeGestureRecognizer(self.panGesture!)
                
                if !(self.navigationController?.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(self.panGesture!) ?? false){
                    self.navigationController?.interactivePopGestureRecognizer?.view?.addGestureRecognizer(self.panGesture!)
                    self.panGesture!.delegate = XPGestureRecognizerDelegateObject.shared
                    XPGestureRecognizerDelegateObject.shared.navigationController = self.navigationController
                    self.panGesture!.addTarget(self, action: #selector(handlePanGesture(sender:)))
                    self.interactiveGestureDelegate = self as? UIViewControllerInteractivePushGestureDelegate
                }
            }
            objc_setAssociatedObject(self, &AssociatedKeys.isLeftPushGestureEnabledKey, enabled, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var isRightPopGestureEnable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.isRightPopGestureEnableKey) as? Bool ?? false
        }
        set(enabled) {
            if enabled {
                assert(self.isLeftPushGestureEnabled == false, "left push & right pop is not support at the same time")
                assert(self.navigationController?.viewControllers.first != self, "right pop is not support in root vc")
                
                self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.navigationController?.interactivePopGestureRecognizer!.view?.removeGestureRecognizer(self.panGesture!)
                
                if !(self.navigationController?.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(self.panGesture!) ?? false){
                    self.navigationController?.interactivePopGestureRecognizer?.view?.addGestureRecognizer(self.panGesture!)
                    
                    // panGesture绑定系统pop手势的target和action
                    guard let systemGesture = self.navigationController?.interactivePopGestureRecognizer else {return}
                    
                    let targets = systemGesture.value(forKey: "_targets") as? [NSObject]
                    guard let targetObject = targets?.first else {return}
                    guard let target = targetObject.value(forKey: "target") else {return}
                    
                    let action = Selector(("handleNavigationTransition:"))
                    self.panGesture?.addTarget(target, action: action)
                }
            }
            objc_setAssociatedObject(self, &AssociatedKeys.isRightPopGestureEnableKey, enabled, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var interactiveGestureDelegate: UIViewControllerInteractivePushGestureDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.interactiveGestureDelegateKey) as? UIViewControllerInteractivePushGestureDelegate
        }
        
        set(delegate) {
            objc_setAssociatedObject(self, &AssociatedKeys.interactiveGestureDelegateKey, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var panGesture: UIPanGestureRecognizer? {
        get {
            guard let panGesture = objc_getAssociatedObject(self, &AssociatedKeys.panGestureKey) else {
                let panGesture = UIPanGestureRecognizer()
                panGesture.maximumNumberOfTouches = 1
                objc_setAssociatedObject(self, &AssociatedKeys.panGestureKey, panGesture, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return panGesture
            }
            return panGesture as? UIPanGestureRecognizer
        }
    }
    
    var navigationControllerDelegate: XPNavigationControllerDelegateObject? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.navigationControllerDelegateKey) as? XPNavigationControllerDelegateObject
        }
        
        set(delegate) {
            objc_setAssociatedObject(self, &AssociatedKeys.navigationControllerDelegateKey, delegate, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var statusBarHidden: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.statusBarHiddenKey) as? Bool ?? false
        }
        
        set(isHidden) {
            objc_setAssociatedObject(self, &AssociatedKeys.statusBarHiddenKey, isHidden, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
            
            if responds(to: #selector(setNeedsStatusBarAppearanceUpdate)) {
                self.prefersStatusBarHidden
                perform(#selector(setNeedsStatusBarAppearanceUpdate))
            }
        }
    }
    
    // 手势处理方法
    @objc private func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        var progress: CGFloat = -(sender.translation(in: sender.view).x / (sender.view?.bounds.size.width)!)
        progress = min(1.0, max(0.0, progress))
        print(progress)
        
        if self.navigationControllerDelegate == nil {
            self.navigationControllerDelegate = XPNavigationControllerDelegateObject()
        }
        
        switch sender.state {
            
        case .began:
            
            assert(self.interactiveGestureDelegate != nil)
            assert(self.navigationController != nil)
            assert(self.isLeftPushGestureEnabled == true)
            
            self.navigationControllerDelegate?.pushTransition = UIPercentDrivenInteractiveTransition()
            self.navigationControllerDelegate?.pushTransition?.completionCurve = .easeInOut
            self.navigationController?.delegate = self.navigationControllerDelegate
            
            guard let destinationViewController = self.interactiveGestureDelegate?.destinationViewControllerFrom(fromViewController: self) else {return}
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
            self.navigationControllerDelegate?.pushTransition?.update(0)

        case .changed:
            
            if self.isLeftPushGestureEnabled == true {
                self.navigationControllerDelegate?.pushTransition?.update(progress)
            }

        case .ended, .cancelled:

            if self.isLeftPushGestureEnabled == true {
                if progress >= 0.3 {
                    self.navigationControllerDelegate?.pushTransition?.finish()
                } else {
                    self.navigationControllerDelegate?.pushTransition?.cancel()
                }
            }
            self.navigationControllerDelegate = nil

        default:
            break
        }
    }
}

// 需要控制器实现的代理，决定push到哪个控制器
protocol UIViewControllerInteractivePushGestureDelegate {
    func destinationViewControllerFrom(fromViewController: UIViewController) -> UIViewController
}
