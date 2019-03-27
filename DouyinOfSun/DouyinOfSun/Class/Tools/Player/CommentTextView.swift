//
//  CommentTextView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/12.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

protocol CommentTextViewDelegate: class {
    func commentTextView(textView: CommentTextView, willShowOnScreen willShow: Bool)
    func commentTextView(textView: CommentTextView, willSendMessage message: String)
}

class CommentTextView: UIView {
    weak var delegate: CommentTextViewDelegate?
    
    private var textHeight: CGFloat = 0
    private var keyboardHeight: CGFloat = 0
    private lazy var container: UIView = {
        let container = UIView(frame: .zero)
        container.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0)
        return container
    }()
    private lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.backgroundColor = UIColor.clear
        textView.tintColor = UIColor(r: 241, g: 47, b: 84, alpha: 1)
        textView.clipsToBounds = false
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.returnKeyType = .send
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        textHeight = CGFloat(ceilf(Float((textView.font?.lineHeight)!)))
        textView.delegate = self
        return textView
    }()
    
    private lazy var line: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        return line
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let placeholderLabel = UILabel(frame: CGRect.zero)
        placeholderLabel.text = "有爱评论，说点儿好听的~"
        placeholderLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        return placeholderLabel
    }()
    
    private lazy var atImageView: UIImageView = {
        let atImageView = UIImageView(frame: CGRect.zero)
        atImageView.contentMode = .center
        atImageView.image = UIImage(named: "iconMessageAtWhite_24x24_")
        return atImageView
    }()
    
    private lazy var emojiImageView: UIImageView = {
        let emojiImageView = UIImageView(frame: CGRect.zero)
        emojiImageView.contentMode = .center
        emojiImageView.image = UIImage(named: "iconMessageEmojiWhite_24x24_")
        return emojiImageView
    }()
    
    private lazy var sendImageView: UIImageView = {
        let sendImageView = UIImageView(frame: CGRect.zero)
        sendImageView.contentMode = .center
        sendImageView.image = UIImage(named: "ic30WhiteSend")
        sendImageView.isUserInteractionEnabled = true
        sendImageView.alpha = 0.0
        sendImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMessage)))
        return sendImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self {
            if hitView?.backgroundColor == UIColor.clear {
                return nil
            }
        }
        return hitView
    }
    
    @objc private func handlePan(sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: textView)
        if !container.layer.contains(touchPoint) {
            textView.resignFirstResponder()
        }
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: textView)
        if !container.layer.contains(touchPoint) {
            textView.resignFirstResponder()
        }
    }
    
    @objc private func sendMessage() {
        textView.text = ""
        placeholderLabel.isHidden = false
        textHeight = CGFloat(ceilf(Float((textView.font?.lineHeight)!)))
        textView.resignFirstResponder()
        delegate?.commentTextView(textView: self, willSendMessage: textView.text)
    }
    
    @objc private func keyboardWillShow(sender: Notification) {
        self.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.4)
        keyboardHeight = sender.keyBoardHeight()
        updateViewFrameAndState()
        delegate?.commentTextView(textView: self, willShowOnScreen: true)
    }
    
    @objc private func keyboardWillHide(sender: Notification) {
        self.backgroundColor = UIColor.clear
        keyboardHeight = 0
        updateViewFrameAndState()
        delegate?.commentTextView(textView: self, willShowOnScreen: false)
    }
}

extension CommentTextView {
    private func setupUI() {
        addSubview(container)
        container.addSubview(textView)
        container.addSubview(line)
        container.addSubview(placeholderLabel)
        container.addSubview(atImageView)
        container.addSubview(emojiImageView)
        container.addSubview(sendImageView)
        
        container.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(49.7)
        }
        textView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-140)
        }
        line.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.3)
        }
        placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        sendImageView.snp.makeConstraints { (make) in
            make.top.equalTo(14.5)
            make.left.equalToSuperview().offset(kScreenWidth)
            make.width.height.equalTo(20)
        }
        emojiImageView.snp.makeConstraints { (make) in
            make.top.equalTo(sendImageView)
            make.right.equalTo(sendImageView.snp.left).offset(-20)
            make.width.height.equalTo(20)
        }
        atImageView.snp.makeConstraints { (make) in
            make.top.equalTo(emojiImageView)
            make.right.equalTo(emojiImageView.snp.left).offset(-20)
            make.width.height.equalTo(20)
        }
    }
    
    private func updateViewFrameAndState() {
        updateIconState()
        updateRightViewsFrame()
        updateTextViewFrame()
    }
    
    private func updateIconState() {
        atImageView.image = keyboardHeight > 0 ? UIImage(named: "iconMessageAtWhiteHigh_24x24_") : UIImage(named: "iconMessageAtWhite_24x24_")
        emojiImageView.image = keyboardHeight > 0 ? UIImage(named: "iconMessageEmojiWhiteHigh_24x24_") : UIImage(named: "iconMessageEmojiWhite_24x24_")
        sendImageView.image = textView.text.count > 0 ? UIImage(named: "ic30RedSend") : UIImage(named: "ic30WhiteSend")
    }
    
    private func updateRightViewsFrame() {
        let offset = keyboardHeight > 0 ? kScreenWidth - 40 : kScreenWidth
        self.sendImageView.snp.updateConstraints({ (make) in
            make.left.equalToSuperview().offset(offset)
        })
        self.textView.setNeedsLayout()
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.sendImageView.alpha = self.keyboardHeight > 0 ? 1.0 : 0.0
            self.textView.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func updateTextViewFrame() {
        let textViewHeight = keyboardHeight > 0 ? ceilf(Float(textHeight + 2 * 15)) : 49.7
        self.container.snp.updateConstraints({ (make) in
            make.height.equalTo(textViewHeight)
            make.bottom.equalToSuperview().offset(-keyboardHeight)
        })
        self.setNeedsLayout()
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

extension CommentTextView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:))))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        for gestureRecognizer in gestureRecognizers ?? [] {
            removeGestureRecognizer(gestureRecognizer)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        textView.attributedText = attributedText
        if textView.hasText == false {
            placeholderLabel.isHidden = false
            textHeight = CGFloat(ceilf(Float((textView.font?.lineHeight)!)))
        } else {
            placeholderLabel.isHidden = true
            textHeight = attributedText.multiLineSize(width: kScreenWidth - 15 - 140).height
        }
        updateViewFrameAndState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendMessage()
            return false
        }
        return true
    }
}
