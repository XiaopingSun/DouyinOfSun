//
//  PlayerInfoView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/5/6.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

protocol PlayerInfoViewDelegate: class {
    func playerInfoView(playerInfoView: PlayerInfoView, startPlayActionWithPlayUrl playUrlStr: String?)
}

class PlayerInfoView: UIView {
    
    weak var delegate: PlayerInfoViewDelegate?
    private var urlTextField: UITextField?
    private var startPlayButton: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(r: 22, g: 24, b: 35)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlayerInfoView {
    private func setupUI() {
        let urlLabel = UILabel(frame: CGRect.zero)
        urlLabel.text = "播放URL"
        urlLabel.textColor = UIColor.white
        urlLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(urlLabel)
        
        urlTextField = UITextField(frame: CGRect.zero)
        urlTextField?.borderStyle = .roundedRect
        urlTextField?.text = "http://pq764kdq0.bkt.clouddn.com/%E7%9B%B4%E5%88%B0%E4%B8%96%E7%95%8C%E7%9A%84%E5%B0%BD%E5%A4%B4-%E5%8E%8B%E7%BC%A9.mp4"
        urlTextField?.textColor = UIColor(r: 22, g: 24, b: 35)
        urlTextField?.backgroundColor = UIColor.white
        urlTextField?.clearButtonMode = .whileEditing
        urlTextField?.font = UIFont.systemFont(ofSize: 14)
        urlTextField?.placeholder = "Input play url"
        addSubview(urlTextField!)
        
        startPlayButton = UIButton(type: UIButton.ButtonType.custom)
        startPlayButton?.setTitle("开始播放", for: UIControl.State.normal)
        startPlayButton?.setTitleColor(UIColor(r: 22, g: 24, b: 35), for: UIControl.State.normal)
        startPlayButton?.backgroundColor = UIColor.white
        startPlayButton?.layer.masksToBounds = true
        startPlayButton?.layer.cornerRadius = 5
        startPlayButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        startPlayButton?.addTarget(self, action: #selector(startPlay), for: UIControl.Event.touchUpInside)
        addSubview(startPlayButton!)
        
        urlLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(50)
        }
        urlTextField!.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(urlLabel)
        }
        startPlayButton!.snp.makeConstraints { (make) in
            make.top.equalTo(urlLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    
    func setPushUrl(urlStr: String) {
        urlTextField?.text = urlStr
    }
    
    @objc private func startPlay() {
        endEditing(true)
        delegate?.playerInfoView(playerInfoView: self, startPlayActionWithPlayUrl: urlTextField?.text)
    }
}
