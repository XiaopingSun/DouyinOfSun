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
    private var awemeList = [aweme_list]()
    
    private lazy var navigationBarView: HotNavigationBarView = {
        let navigationBarView = HotNavigationBarView(frame: CGRect.zero)
        return navigationBarView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: -kScreenHeight, width: kScreenWidth, height: 3 * kScreenHeight), style: .plain)
        tableView.contentInset = UIEdgeInsets(top: kScreenHeight, left: 0, bottom: kScreenHeight, right: 0)
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.register(HotTableViewCell.self, forCellReuseIdentifier: hotCellIdentifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 22, g: 24, b: 35)
        setupUI()
        loadData()
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if awemeList.count == 0 {return}
        CacheCellManager.shared().resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if awemeList.count == 0 {return}
        CacheCellManager.shared().pauseAll()
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "currentIndex")
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
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
    }
    
    private func loadData() {
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 1) {
            let bundleName = ["production1",
                              "favorite1", "favorite2", "favorite3", "favorite4", "favorite5", "favorite6"]
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
            self.awemeList = tempAwemeList
            DispatchQueue.main.async {
                // reloadData会按默认高度init对应个数的cell，造成播放器大量实例化
                var indexPaths = [IndexPath]()
                for i in (0 ..< self.awemeList.count) {
                    let indexPath = IndexPath(row: i, section: 0)
                    indexPaths.append(indexPath)
                }
                self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
                self.addObserver(self, forKeyPath: "currentIndex", options: [.initial, .new], context: nil)
            }
        }
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActiveNotification), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActiveNotification), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func applicationWillResignActiveNotification() {
        if awemeList.count == 0 {return}
        CacheCellManager.shared().pauseAll()
    }
    
    @objc private func applicationDidBecomeActiveNotification() {
        if awemeList.count == 0 {return}
        CacheCellManager.shared().resume()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentIndex" {
            let currentCell = tableView.cellForRow(at: IndexPath(row: currentIndex, section: 0)) as! HotTableViewCell
            CacheCellManager.shared().play(cell: currentCell)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension HotViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
            cell.aweme = awemeList[Int(arc4random()) % awemeList.count]
        }
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
            
            if translatedPoint.y < -kScreenHeight / 2.0 || velocity.y > 0.3 {
                self.currentIndex += 1
            }
            if (translatedPoint.y > kScreenHeight / 2.0 || velocity.y < -0.3) && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            UIView.animate(withDuration: 0.24, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: self.currentIndex, section: 0), at: UITableView.ScrollPosition.top, animated: false)
            }, completion: { (_) in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}
