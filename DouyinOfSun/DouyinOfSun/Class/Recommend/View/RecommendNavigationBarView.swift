//
//  RecommendNavigationBarView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/4/24.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

protocol RecommendNavigationBarViewDelegate: class {
    func navigationBarViewCameraButtonDidSelected()
    func navigationBarViewBackButtonDidSelected()
    func navigationBarView(barView: RecommendNavigationBarView, titleViewDidSelectedWithType type: HomeNaviTitleViewSelectedButtonType)
}

class RecommendNavigationBarView: UIView {
    
    weak var delegate: RecommendNavigationBarViewDelegate?
    private lazy var cameraButton: UIButton = {
        let cameraButton = UIButton(type: UIButton.ButtonType.custom)
        cameraButton.setImage(UIImage(named: "D_icNavbarScan_24x24_"), for: .normal)
        cameraButton.backgroundColor = UIColor.clear
        cameraButton.addTarget(self, action: #selector(cameraButtonAction), for: UIControl.Event.touchUpInside)
        return cameraButton
    }()
    
    private lazy var titleView: HomeNaviTitleView = {
        let titleView = HomeNaviTitleView(frame: .zero, titles: ["直播", "播放"])
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var rightButton: UIButton = {
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.setImage(UIImage(named: "icNavbarRightback_24x24_"), for: .normal)
        rightButton.backgroundColor = UIColor.clear
        rightButton.addTarget(self, action: #selector(backButtonAction), for: UIControl.Event.touchUpInside)
        return rightButton
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(r: 22, g: 24, b: 35)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 划线
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let path = CGMutablePath()
        let lineWidth: CGFloat = 0.04
        path.move(to: CGPoint(x: 0, y: bounds.size.height - lineWidth))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height - lineWidth))
        context.addPath(path)
        context.setStrokeColor(UIColor(r: 210, g: 210, b: 210).cgColor)
        context.setLineWidth(lineWidth)
        context.strokePath()
    }
    
    @objc private func cameraButtonAction() {
        delegate?.navigationBarViewCameraButtonDidSelected()
    }
    
    @objc private func backButtonAction() {
        delegate?.navigationBarViewBackButtonDidSelected()
    }
}

extension RecommendNavigationBarView {
    private func initSubviews() {
        addSubview(cameraButton)
        addSubview(titleView)
        addSubview(rightButton)
        
        cameraButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(42)
            make.width.height.equalTo(24)
        }
        titleView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(cameraButton)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(cameraButton)
            make.width.height.equalTo(24)
        }
    }
}

extension RecommendNavigationBarView: HomeNaviTitleViewDelegate {
    func naviTitleView(titleView: HomeNaviTitleView, didSelectedWithType type: HomeNaviTitleViewSelectedButtonType) {
        delegate?.navigationBarView(barView: self, titleViewDidSelectedWithType: type)
    }
}
