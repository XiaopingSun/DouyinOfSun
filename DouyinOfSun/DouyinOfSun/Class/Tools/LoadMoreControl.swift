//
//  LoadMoreControl.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/9.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

typealias OnLoad = () -> Void

enum LoadingType: Int {
    case LoadStateIdle
    case LoadStateLoading
    case LoadStateAll
    case LoadStateFailed
}

class LoadMoreControl: UIControl {
    
    private var surplusCount: Int = 0
    private var originalFrame: CGRect = CGRect.zero
    weak var superView: UIScrollView?
    private var edgeInsets: UIEdgeInsets?
    private lazy var indicator: UIImageView = {
        let indicator = UIImageView(image: UIImage(named: "icon30WhiteSmall"))
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.text = "正在加载..."
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    private var _onLoad: OnLoad?
    var onLoad: OnLoad? {
        set {
            _onLoad = newValue
        }
        get {
            return _onLoad
        }
    }
    
    private var _loadingType: LoadingType = .LoadStateIdle
    var loadingType: LoadingType {
        set {
            _loadingType = newValue
            switch newValue {
            case .LoadStateIdle:
                self.isHidden = true
                break
            case .LoadStateLoading:
                self.isHidden = false
                indicator.isHidden = false
                label.text = "内容加载中..."
                label.snp.remakeConstraints { make in
                    make.centerY.equalTo(self)
                    make.centerX.equalTo(self).offset(20)
                }
                indicator.snp.remakeConstraints { make in
                    make.centerY.equalTo(self)
                    make.right.equalTo(self.label.snp.left).inset(-5)
                    make.width.height.equalTo(15)
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1 , execute: {
                    self.startAnimation()
                })
                break
            case .LoadStateAll:
                self.isHidden = false
                indicator.isHidden = true
                label.text = "没有更多了哦～"
                label.snp.remakeConstraints { make in
                    make.center.equalTo(self)
                }
                stopAnimation()
                updateFrame()
                break
            case .LoadStateFailed:
                self.isHidden = false
                indicator.isHidden = true
                label.text = "加载更多"
                label.snp.makeConstraints { make in
                    make.center.equalTo(self)
                }
                stopAnimation()
                break
            }
        }
        get {
            return _loadingType
        }
    }
    
    convenience init(frame: CGRect, surplusCount: Int) {
        self.init(frame: frame)
        self.surplusCount = surplusCount
        self.originalFrame = frame
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    deinit {
        superView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if edgeInsets == nil {
            superView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            edgeInsets = superView?.contentInset
            superView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadMoreControl {
    private func initSubviews() {
        self.layer.zPosition = -1
        addSubview(indicator)
        addSubview(label)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            DispatchQueue.main.async {
                guard let superView = self.superView else {return}
                if (superView.isKind(of: UITableView.self)) {
                    if let tableView = superView as? UITableView {
                        let lastSection = tableView.numberOfSections - 1
                        if lastSection >= 0 {
                            let lastRow = tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1
                            if lastRow >= 0 {
                                if tableView.visibleCells.count > 0 {
                                    if let indexPath = tableView.indexPath(for: tableView.visibleCells.last!) {
                                        if indexPath.section == lastSection && indexPath.row >= lastRow - self.surplusCount {
                                            if self.loadingType == .LoadStateIdle || self.loadingType == .LoadStateFailed {
                                                self.startLoading()
                                                self.onLoad?()
                                            }
                                        }
                                        if indexPath.section == lastSection && indexPath.row == lastRow {
                                            self.frame = CGRect.init(x: 0, y: tableView.visibleCells.last?.frame.maxY ?? 0, width: kScreenWidth, height: 50)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if (superView.isKind(of: UICollectionView.self)) {
                    if let collectionView = superView as? UICollectionView {
                        let lastSection = collectionView.numberOfSections - 1
                        if lastSection >= 0 {
                            let lastRow = collectionView.numberOfItems(inSection: collectionView.numberOfSections - 1) - 1
                            if lastRow >= 0 {
                                if collectionView.visibleCells.count > 0 {
                                    let indexPaths = collectionView.indexPathsForVisibleItems
                                    let orderedIndexPaths = indexPaths.sorted(by: {$0.row < $1.row})
                                    if let indexPath = orderedIndexPaths.last {
                                        if indexPath.section == lastSection && indexPath.row >= lastRow - self.surplusCount {
                                            if self.loadingType == .LoadStateIdle || self.loadingType == .LoadStateFailed {
                                                self.startLoading()
                                                self.onLoad?()
                                            }
                                        }
                                        if indexPath.section == lastSection && indexPath.row == lastRow {
                                            if let cell = collectionView.cellForItem(at: indexPath) {
                                                self.frame = CGRect.init(x: 0, y: cell.frame.maxY, width: kScreenWidth, height: 50)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func reset() {
        loadingType = .LoadStateIdle
        self.frame = originalFrame
    }
    
    func startLoading() {
        if loadingType != .LoadStateLoading {
            loadingType = .LoadStateLoading
        }
    }
    
    func endLoading() {
        if loadingType != .LoadStateIdle {
            loadingType = .LoadStateIdle
        }
    }
    
    func loadingFailed() {
        if loadingType != .LoadStateFailed {
            loadingType = .LoadStateFailed
        }
    }
    
    func loadingAll() {
        if loadingType != .LoadStateAll {
            loadingType = .LoadStateAll
        }
    }

    private func updateFrame() {
        if (superView?.isKind(of: UITableView.self))! {
            if let tableView = superView as? UITableView {
                let y: CGFloat = tableView.contentSize.height > originalFrame.origin.y ? tableView.contentSize.height : originalFrame.origin.y
                self.frame = CGRect(x: 0, y: y, width: kScreenWidth, height: 50)
            }
        }
        if (superView?.isKind(of: UICollectionView.self))! {
            if let collectionView = superView as? UICollectionView {
                let y: CGFloat = collectionView.contentSize.height > originalFrame.origin.y ? collectionView.contentSize.height : originalFrame.origin.y
                self.frame = CGRect(x: 0, y: y, width: kScreenWidth, height: 50)
            }
        }
    }
    
    private func startAnimation() {
        let rotationAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber.init(value: .pi * 2.0)
        rotationAnimation.duration = 1.5
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = MAXFLOAT
        indicator.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    private func stopAnimation() {
        indicator.layer.removeAllAnimations()
    }
}
