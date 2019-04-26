//
//  HotViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/17.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit
import HandyJSON

private let hotCellIdentifier: String = "hotCellIdentifier"

class HotViewController: UIViewController {
    
    @objc dynamic var currentIndex: Int = 0
    var cellManager: HotCellCacheManager = HotCellCacheManager()
    private var awemeList = [aweme_list]()
    private var systemVolume: CGFloat = 0
    private lazy var navigationBarView: HotNavigationBarView = {
        let navigationBarView = HotNavigationBarView(frame: CGRect.zero)
        navigationBarView.delegate = self
        return navigationBarView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: kScreenHeight, left: 0, bottom: kScreenHeight, right: 0)
        tableView.backgroundColor = UIColor(r: 22, g: 24, b: 35)
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = 0 // 禁止tableView在reloadData时估算cell高度
        tableView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.register(HotTableViewCell.self, forCellReuseIdentifier: hotCellIdentifier)
        return tableView
    }()
    
    private lazy var reloadPanGesture: UIPanGestureRecognizer = {
        let reloadPanGesture = UIPanGestureRecognizer(target: self, action: #selector(reloadPanGestureValueChanged(sender:)))
        reloadPanGesture.delegate = self
        return reloadPanGesture
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadData()
        navigationBarView.startLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let homeTabbarVC = self.tabBarController as! HomeTabBarViewController
        if homeTabbarVC.isTabbarVCShowing == false { return }
        hotVCTransformOperation(isActive: true, needUpdateBackgroundNotification: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let homeTabbarVC = self.tabBarController as! HomeTabBarViewController
        if homeTabbarVC.isTabbarVCShowing == false { return }
        hotVCTransformOperation(isActive: false, needUpdateBackgroundNotification: true)
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "currentIndex")
    }
}

extension HotViewController {
    private func setupUI() {
        view.addSubview(navigationBarView)
        view.insertSubview(tableView, belowSubview: navigationBarView)
        navigationBarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(-kScreenHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(3 * kScreenHeight)
        }
    }
    
    private func loadData() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
            let bundleName = ["production1",
                              "favorite1", "favorite2", "favorite3", "favorite4", "favorite5", "favorite6", "favorite7", "favorite8"]
            var tempAwemeList = [aweme_list]()
            for i in 0 ..< bundleName.count {
                let awemeDataJson: String = try! NSString(contentsOfFile: Bundle.main.path(forResource: bundleName[i], ofType: "json")!, encoding: String.Encoding.utf8.rawValue) as String
                let awemeModel = JSONDeserializer<AwemeModel>.deserializeFrom(json: awemeDataJson)
                var validAwemeModel = [aweme_list]()
                for aweme in (awemeModel?.aweme_list)! {
                    if aweme.video != nil {
                        validAwemeModel.append(aweme)
                    }
                }
                tempAwemeList += validAwemeModel
            }
            self.awemeList = tempAwemeList.sorted(by: { (obj1, obj2) -> Bool in
                return Int(arc4random() % 3) > 0
            })
            DispatchQueue.main.async {
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
                self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .old, .new], context: nil)
                self.navigationBarView.finishLoading()
            }
        }
    }
    
    private func addBackgroundNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func addVolumeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(systemVolumeDidChangeNotification(sender:)), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    private func removeBackgroundNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func removeVolumeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    @objc private func applicationWillResignActiveNotification() {
        hotVCTransformOperation(isActive: false, needUpdateBackgroundNotification: false)
    }
    
    @objc private func applicationDidBecomeActiveNotification() {
        hotVCTransformOperation(isActive: true, needUpdateBackgroundNotification: false)
    }
    
    @objc private func systemVolumeDidChangeNotification(sender: Notification) {
        let volume = sender.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! CGFloat
        systemVolume = MPVolumeViewManager.shared().getSystemVolume()
        
        if awemeList.count == 0 {return}
        cellManager.updateVolume(newValue: volume, oldValue: systemVolume)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentIndex" {
            guard let nonnilChange = change else { return }
            guard UIApplication.shared.applicationState == .active else { return }
            let old = nonnilChange[NSKeyValueChangeKey.oldKey]
            let new = nonnilChange[NSKeyValueChangeKey.newKey]
            if new != nil && old != nil && old as! Int == new as! Int {
                return
            } else {
                let currentCell = tableView.cellForRow(at: IndexPath(row: currentIndex, section: 0)) as! HotTableViewCell
                cellManager.play(cell: currentCell)
            }
            if currentIndex == 0 {
                self.tableView.addGestureRecognizer(reloadPanGesture)
            } else {
                self.tableView.removeGestureRecognizer(reloadPanGesture)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func hotVCTransformOperation(isActive: Bool, needUpdateBackgroundNotification: Bool) {
        if isActive == false {
            MPVolumeViewManager.shared().unload()
            if needUpdateBackgroundNotification == true {
                removeBackgroundNotification()
            }
            removeVolumeNotification()
            if awemeList.count == 0 {return}
            if cellManager.currentPlayingCell?.isManualPaused == true { return }
            cellManager.pauseAll()
        } else {
            MPVolumeViewManager.shared().load()
            if needUpdateBackgroundNotification == true {
                addBackgroundNotification()
            }
            addVolumeNotification()
            if awemeList.count == 0 {return}
            if cellManager.currentPlayingCell?.isManualPaused == true { return }
            cellManager.resume()
        }
    }
}

extension HotViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HotViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.awemeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: hotCellIdentifier, for: indexPath) as! HotTableViewCell
        if awemeList.count != 0 {
            cell.aweme = awemeList[indexPath.row]
        }
        cell.isCommentHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenHeight
    }
}

extension HotViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            var tempIndex = self.currentIndex
            
            if translatedPoint.y < -kScreenHeight / 2.0 || velocity.y > 0.3 {
                tempIndex += 1
            } else if (translatedPoint.y > kScreenHeight / 2.0 || velocity.y < -0.3) && self.currentIndex > 0 {
                tempIndex -= 1
            }
            UIView.animate(withDuration: 0.24, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: tempIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }, completion: { (_) in
                scrollView.panGestureRecognizer.isEnabled = true
                self.currentIndex = tempIndex
            })
        }
    }
}

// 顶部滑动手势
extension HotViewController: UIGestureRecognizerDelegate, HotNavigationBarViewDelegate {
    func hotNavigationBarViewWillStartReloading() {
        self.removeObserver(self, forKeyPath: "currentIndex")
        loadData()
    }
    
    @objc private func reloadPanGestureValueChanged(sender: UIPanGestureRecognizer) {
        let progress: CGFloat = sender.translation(in: sender.view).y

        switch sender.state {
        case .began:
            navigationBarView.updateNavigationBarStatus(offset: progress)
        case .changed:
            navigationBarView.updateNavigationBarStatus(offset: progress)
        case .ended, .cancelled:
            navigationBarView.finishPanGesture(offset: progress)
        default:
            break
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return panReload(sender: gestureRecognizer)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return !panReload(sender: gestureRecognizer)
    }
    
    private func panReload(sender: UIGestureRecognizer) -> Bool {
        if sender.isKind(of: UIPanGestureRecognizer.self) {
            let translation = (sender as! UIPanGestureRecognizer).translation(in: sender.view)
            let absX: CGFloat = abs(translation.x)
            let absY: CGFloat = abs(translation.y)
            if absX > absY {
                return false
            } else if absX < absY {
                if translation.y < 0 {// 上滑
                    return false
                } else {// 下滑
                    return true
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
