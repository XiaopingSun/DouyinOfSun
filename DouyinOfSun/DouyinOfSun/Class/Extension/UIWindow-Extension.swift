//
//  UIWindow-Extension.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/11.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

extension UIWindow {
    static var tipsKey = "tipsKey"
    static var tips: UILabel? {
        get {
            return objc_getAssociatedObject(self, &UIWindow.tipsKey) as? UILabel
        }
        set {
            objc_setAssociatedObject(self, &UIWindow.tipsKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    static var tapKey = "tapKey"
    static var tap: UITapGestureRecognizer? {
        get {
            return objc_getAssociatedObject(self, &UIWindow.tapKey) as? UITapGestureRecognizer
        }
        set {
            objc_setAssociatedObject(self, &UIWindow.tapKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    static func showTips(text: String) {
        if tips != nil {
            dismiss()
        }
        Thread.sleep(forTimeInterval: 0.5)
        
        let window = UIApplication.shared.delegate?.window as! UIWindow
        let maxWidth: CGFloat = 200
        let maxHeight: CGFloat = window.frame.size.height - 200
        let commonInset: CGFloat = 15
        
        let font = UIFont.systemFont(ofSize: 14)
        let string = NSMutableAttributedString(string: text)
        string.addAttributes([.font: font], range: NSRange(location: 0, length: string.length))
        
        let rect = string.boundingRect(with: CGSize(width: maxWidth, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        let size = CGSize(width: CGFloat(ceilf(Float(rect.size.width))), height: CGFloat(ceilf(rect.size.height < maxHeight ? Float(rect.size.height) : Float(maxHeight))))
        
        let textX = window.frame.size.width / 2.0 - size.width / 2.0 - commonInset
        let textY = window.frame.size.height / 2.0 - size.height / 2.0 - commonInset
        let textW = size.width  + commonInset * 2
        let textH = size.height + commonInset * 2
        
        let textFrame = CGRect(x: textX, y: textY, width: textW, height: textH)
        
        let textLabel = UILabel(frame: textFrame)
        textLabel.text = text
        textLabel.font = font
        textLabel.textColor = UIColor.white
        textLabel.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.3)
        textLabel.layer.masksToBounds = true
        textLabel.layer.cornerRadius  = 2
        textLabel.textAlignment = .center
        textLabel.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlerGuesture(sender:)))
        window.addGestureRecognizer(tapGesture)
        window.addSubview(textLabel)
        
        UIView.animate(withDuration: 0.25, animations: {
            textLabel.alpha = 1
        }) { (_) in
            tips = textLabel
            tap = tapGesture
            self.perform(#selector(dismiss), with: nil, afterDelay: 2.0)
        }
    }
    
    @objc static func handlerGuesture(sender: UIGestureRecognizer) {
        dismiss()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(dismiss), object: nil)
    }
    
    @objc static func dismiss() {
        if let tapGesture = tap {
            let window = UIApplication.shared.delegate?.window as? UIWindow
            window?.removeGestureRecognizer(tapGesture)
        }
        UIView.animate(withDuration: 0.25, animations: {
            tips?.alpha = 0.0
        }) { finished in
            tips?.removeFromSuperview()
            tips = nil
        }
    }
}
