//
//  MyAwemeViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/25.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit
import HandyJSON

private let myAwemeCellIdentifier: String = "myAwemeCellIdentifier"

class MyAwemeViewController: BaseViewController {
    
    @objc dynamic var currentIndex: Int = 0
    var cellManager: CacheCellManager = CacheCellManager()
    private var awemeList = [aweme_list]()
    private var systemVolume: CGFloat = 0
    private var isCurrentCellPaused = false
    private var pageIndex: Int = 0
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 15.0, y: 32.0, width: 20.0, height: 20.0)
        backButton.setImage(UIImage(named: "icon_titlebar_whiteback"), for: .normal)
        backButton.backgroundColor = UIColor.clear
        backButton.showsTouchWhenHighlighted = false
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return backButton
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: -kScreenHeight, width: kScreenWidth, height: 3 * kScreenHeight), style: .plain)
        tableView.contentInset = UIEdgeInsets(top: kScreenHeight, left: 0, bottom: kScreenHeight, right: 0)
        tableView.backgroundColor = UIColor(r: 22, g: 24, b: 35)
        tableView.separatorStyle = .none
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
        tableView.register(HotTableViewCell.self, forCellReuseIdentifier: myAwemeCellIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setupUI()
        initData()
    }
    
    init(awemeList: [aweme_list], currentIndex: Int) {
        super.init(nibName: nil, bundle: nil)
        self.awemeList = awemeList
        self.currentIndex = currentIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarHidden = true
        statusBarStyle = .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hotVCTransformOperation(isActive: true, needUpdateBackgroundNotification: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarHidden = false
        hotVCTransformOperation(isActive: false, needUpdateBackgroundNotification: true)
    }
    
    deinit {
        cellManager.currentPlayingCell?.stop()
        self.removeObserver(self, forKeyPath: "currentIndex")
    }
    
    private func setupUI() {
        view.addSubview(backButton)
        view.insertSubview(tableView, belowSubview: backButton)
    }
    
    private func initData() {
        let curIndexPath = IndexPath(row: currentIndex, section: 0)
        tableView.isScrollEnabled = true
        tableView.scrollToRow(at: curIndexPath, at: .top, animated: false)
        addObserver(self, forKeyPath: "currentIndex", options: [.initial, .old, .new], context: nil)
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
    
    @objc private func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentIndex" {
            guard let nonnilChange = change else {
                return
            }
            let old = nonnilChange[NSKeyValueChangeKey.oldKey]
            let new = nonnilChange[NSKeyValueChangeKey.newKey]
            if new != nil && old != nil && old as! Int == new as! Int {
                return
            } else {
                let currentCell = tableView.cellForRow(at: IndexPath(row: currentIndex, section: 0)) as! HotTableViewCell
                cellManager.play(cell: currentCell)
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
            isCurrentCellPaused = !(cellManager.currentPlayingCell?.isPlaying ?? true)
            if isCurrentCellPaused == false {
                cellManager.pauseAll()
            }
        } else {
            MPVolumeViewManager.shared().load()
            if needUpdateBackgroundNotification == true {
                addBackgroundNotification()
            }
            addVolumeNotification()
            if awemeList.count == 0 {return}
            if isCurrentCellPaused == false {
                cellManager.resume()
            }
        }
    }
}

extension MyAwemeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MyAwemeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.awemeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: myAwemeCellIdentifier, for: indexPath) as! HotTableViewCell
        if awemeList.count != 0 {
            cell.aweme = awemeList[indexPath.row]
        }
        cell.isCommentHidden = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kScreenHeight
    }
}

extension MyAwemeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            
            var tempIndex = self.currentIndex
            if translatedPoint.y < -kScreenHeight / 2.0 || velocity.y > 0.3 {
                tempIndex += 1
            } else if (translatedPoint.y > kScreenHeight / 2.0 || velocity.y < -0.3) && self.currentIndex > 0 {
                tempIndex -= 1
            }
            if tempIndex < 0 || tempIndex >=  self.awemeList.count { return }
            scrollView.panGestureRecognizer.isEnabled = false

            UIView.animate(withDuration: 0.24, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: tempIndex, section: 0), at: .top, animated: false)
            }, completion: { (_) in
                scrollView.panGestureRecognizer.isEnabled = true
                self.currentIndex = tempIndex
            })
        }
    }
}


