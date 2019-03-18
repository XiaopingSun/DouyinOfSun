//
//  CommentTextView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/12.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class CommentTextView: UIView {
    
    private lazy var textView: UITextView = {
        let textView = UITextView(frame: CGRect.zero)
        textView.backgroundColor = UIColor.clear
        textView.clipsToBounds = false
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.returnKeyType = .send
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 40, bottom: 15, right: 100)
        textView.textContainer.lineFragmentPadding = 0
        textView.delegate = self
        return textView
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
        atImageView.image = UIImage(named: "ic30WhiteAt")
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
        sendImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMessage(sender:))))
        return sendImageView
    }()
    
    private lazy var splitLine: UIView = {
        let splitLine = UIView(frame: CGRect.zero)
        splitLine.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        return splitLine
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGesture(sender:))))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleGesture(sender: UITapGestureRecognizer) {
        
    }
    
    @objc private func sendMessage(sender: UITapGestureRecognizer) {
        
    }
    
    @objc private func keyboardWillShow(sender: Notification) {
        
    }
    
    @objc private func keyboardWillHide(sender: Notification) {
        
    }
}

extension CommentTextView {
    private func setupUI() {
        addSubview(textView)
        textView.addSubview(placeholderLabel)
        textView.addSubview(atImageView)
        textView.addSubview(emojiImageView)
        textView.addSubview(sendImageView)
    }
}

extension CommentTextView: UITextViewDelegate {
    
}
