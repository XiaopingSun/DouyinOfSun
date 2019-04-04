//
//  FollowViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/17.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit
import HandyJSON

private let followCellIdentifier = "followCellIdentifier"
class FollowViewController: UIViewController {
    
    @objc dynamic var playingCellIndex: Int = 0
    private var isFirstLoaded: Bool = false
    private var awemeList = [aweme_list]()
    private var isScrollingToTop: Bool = false
    
    private lazy var navigationBarView: FollowNavigationBarView = {
        let navigationBarView = FollowNavigationBarView(frame: CGRect.zero)
        return navigationBarView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor(r: 22, g: 24, b: 35)
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.scrollsToTop = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(FollowTableViewCell.self, forCellReuseIdentifier: followCellIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 22, g: 24, b: 35)
        setupUI()
    }
}

extension FollowViewController {
    private func setupUI() {
        view.addSubview(navigationBarView)
        view.insertSubview(tableView, belowSubview: navigationBarView)
        navigationBarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navigationBarView.snp.bottom)
        }
    }
    
    func loadData() {
        if isFirstLoaded == true { return }
        isFirstLoaded = true
        DispatchQueue.global().async {
            let bundleName = ["production1",
                              "favorite1", "favorite2", "favorite3", "favorite4", "favorite5", "favorite6", "favorite7"]
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
                return Int(arc4random() % 3) - 1 > 0
            })
            DispatchQueue.main.async {
                self.tableView.isScrollEnabled = true
                self.tableView.reloadData()
                self.addObserver(self, forKeyPath: "playingCellIndex", options: [.initial, .new, .old], context: nil)
            }
        }
    }
}

extension FollowViewController: UITableViewDelegate {
    
}

extension FollowViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awemeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: followCellIdentifier, for: indexPath) as! FollowTableViewCell
        cell.aweme = awemeList[indexPath.row]
        return cell
    }
}

extension FollowViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrollingToTop == true { return }
        let rectInTableView = tableView.rectForRow(at: IndexPath(row: playingCellIndex, section: 0))
        let rectInController = tableView.convert(rectInTableView, to: self.view)
        let centerY = rectInController.origin.y + rectInController.size.height / 2.0
        if centerY < 64.0 {
            playingCellIndex += 1
        } else if centerY > kScreenHeight - kTabbarH {
            playingCellIndex -= 1
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "playingCellIndex" {
            guard let nonnilChange = change else { return }
            let old = nonnilChange[NSKeyValueChangeKey.oldKey]
            let new = nonnilChange[NSKeyValueChangeKey.newKey]
            if new != nil && old != nil {
                if old as! Int == new as! Int {
                    return
                } else {
                    let currentCell = tableView.cellForRow(at: IndexPath(row: old as! Int, section: 0)) as! FollowTableViewCell
                    let nextCell = tableView.cellForRow(at: IndexPath(row: new as! Int, section: 0)) as! FollowTableViewCell
                    currentCell.pause()
                    nextCell.play()
                }
            } else {
                let firstCell = tableView.cellForRow(at: IndexPath(row: playingCellIndex, section: 0)) as! FollowTableViewCell
                firstCell.play()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
