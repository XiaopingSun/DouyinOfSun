//
//  CircleTextView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/13.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class CircleTextView: UIView {
    
    var textColor: UIColor?
    var font: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            let size: CGSize = (text?.singleLineSizeWithAttributeText(font: font))!
            textWidth = size.width
            textHeight = size.height
            textLayerFrame = CGRect(x: 0, y: 0, width: textWidth * 3 + textSeparateWidth * 2, height: textHeight)
            translationX = textWidth + textSeparateWidth
            drawTextLayer()
        }
    }
    var text: String? {
        didSet {
            let size: CGSize = (text?.singleLineSizeWithAttributeText(font: font))!
            textWidth = size.width
            textHeight = size.height
            textLayerFrame = CGRect(x: 0, y: 0, width: textWidth * 3 + textSeparateWidth * 2, height: textHeight)
            translationX = textWidth + textSeparateWidth
            drawTextLayer()
            startAnimation()
        }
    }
    
    private let kCircleTextViewSeparateText = "   "
    private let kCircleTextViewAnimation = "CircleAnimation"
    
    private var textSeparateWidth: CGFloat = 0
    private var textWidth: CGFloat = 0
    private var textHeight: CGFloat = 0
    private var translationX: CGFloat = 0
    private var textLayerFrame: CGRect = .zero
    
    
    private lazy var textLayer: CATextLayer = {
        let textLayer = CATextLayer()
        textLayer.alignmentMode = .natural
        textLayer.truncationMode = .none
        textLayer.isWrapped = false
        textLayer.contentsScale = UIScreen.main.scale
        return textLayer
    }()
    
    private lazy var maskLayer: CAGradientLayer = {
        let maskLayer = CAGradientLayer()
        maskLayer.colors = [UIColor.clear.withAlphaComponent(0.2).cgColor, UIColor.clear.withAlphaComponent(1).cgColor, UIColor.clear.withAlphaComponent(1).cgColor,  UIColor.clear.withAlphaComponent(0.2).cgColor]
        maskLayer.locations = [0.01, 0.03, 0.97, 0.99]
        maskLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        maskLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        maskLayer.frame = CGRect(x: 0, y: 0, width: 180, height: 24)
        return maskLayer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        text = ""
        textColor = UIColor.white
        font = UIFont.systemFont(ofSize: 14)
        textSeparateWidth = kCircleTextViewSeparateText.singleLineSizeWithText(font: font).width
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.masksToBounds = true
        setupLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        textLayer.frame = CGRect(x: 0, y: bounds.size.height / 2.0 - textLayerFrame.size.height / 2.0, width: textLayerFrame.size.width, height: textLayerFrame.size.height)
        CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CircleTextView {
    private func setupLayer() {
        self.layer.addSublayer(textLayer)
        self.layer.mask = maskLayer
    }
    
    private func drawTextLayer() {
        textLayer.foregroundColor = textColor?.cgColor
        let fontName: CFString = font.fontName as CFString
        let fontRef: CGFont = CGFont(fontName)!
        textLayer.font = fontRef
        textLayer.fontSize = font.pointSize
        textLayer.string = text! + kCircleTextViewSeparateText + text! + kCircleTextViewSeparateText + text!
    }
    
    func startAnimation() {
        if textLayer.animation(forKey: kCircleTextViewAnimation) != nil {
            textLayer.removeAnimation(forKey: kCircleTextViewAnimation)
        }
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = bounds.origin.x
        animation.toValue = bounds.origin.x - translationX
        animation.duration = CFTimeInterval(textWidth * 0.035)
        animation.repeatCount = Float(Int.max)
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        textLayer.add(animation, forKey: kCircleTextViewAnimation)
    }
    
    func pauseAnimation() {
        textLayer.pauseLayer()
    }
    
    func resumeAnimation() {
        textLayer.resumeLayer()
    }
    
    func reset() {
        if textLayer.animation(forKey: kCircleTextViewAnimation) != nil {
            textLayer.removeAnimation(forKey: kCircleTextViewAnimation)
        }
    }
}
