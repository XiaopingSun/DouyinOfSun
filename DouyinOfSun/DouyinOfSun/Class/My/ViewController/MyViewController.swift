//
//  MyViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/20.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit
import HandyJSON

private let kCellIndentifier: String = "MyCollectionViewCell"
private let kHeaderViewIdentifier: String = "MyCollectionViewCellHeaderView"
private let kFooterViewIdentifier: String = "MyCollectionViewCellFooterView"

class MyViewController: BaseViewController {
    
    private var user: user?
    private var awemeList = [aweme_list]()
    private var selectedTabbarType: UserInfoHeaderTabbarType = .productions
    private var pageNumber: UInt = 1
    private var headerViewHeight: CGFloat = 0
    
    private lazy var loadMore: LoadMoreControl = {
        let loadMore = LoadMoreControl(frame: CGRect(x: 0, y: headerViewHeight, width: kScreenWidth, height: 50), surplusCount: 6)
        loadMore.startLoading()
        loadMore.onLoad = {[weak self] in
            self!.pageNumber += 1
            self?.loadAwemeData(pageNumber: self!.pageNumber)
        }
        loadMore.superView = collectionView
        return loadMore
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MyCollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor(r: 21, g: 23, b: 35, alpha: 1)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: kCellIndentifier)
        collectionView.register(UserInfoHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewIdentifier)
        return collectionView
    }()
    
    private lazy var navigationBarView: MyNavigationBarView = {
        let navigationBarView = MyNavigationBarView(frame: CGRect.zero)
        navigationBarView.delegate = self
        return navigationBarView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.randomColor()
        setupUI()
        loadUserData()
        loadAwemeData(pageNumber: pageNumber)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarHidden = false
        statusBarStyle = .lightContent
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController!.navigationTransitionType = .rightPop
    }
}

extension MyViewController {
    private func setupUI() {
        view.addSubview(navigationBarView)
        view.insertSubview(collectionView, belowSubview: navigationBarView)
        collectionView.addSubview(loadMore)
        
        navigationBarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    private func loadUserData() {
        let userInfoJson: String = try! NSString(contentsOfFile: Bundle.main.path(forResource: "user", ofType: "json")!, encoding: String.Encoding.utf8.rawValue) as String
        user = JSONDeserializer<UserInfoModel>.deserializeFrom(json: userInfoJson)?.user
        navigationBarView.titleLabel.text = user?.nickname
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    private func loadAwemeData(pageNumber: UInt) {
        let jsonPath = (selectedTabbarType == .productions ? "production" : "favorite") + String(pageNumber)
        let awemeDataJson: String = try! NSString(contentsOfFile: Bundle.main.path(forResource: jsonPath, ofType: "json")!, encoding: String.Encoding.utf8.rawValue) as String
        let awemeModel = JSONDeserializer<AwemeModel>.deserializeFrom(json: awemeDataJson)
        var validAwemeModel = [aweme_list]()
        for aweme in (awemeModel?.aweme_list)! {
            if aweme.video != nil {
                validAwemeModel.append(aweme)
            }
        }
        awemeList += validAwemeModel
        
        var indexPaths = [IndexPath]()
        for row in Int(awemeList.count) - Int(validAwemeModel.count) ..< Int(awemeList.count) {
            indexPaths.append(IndexPath(row: row, section: 1))
        }
        collectionView.insertItems(at: indexPaths)
        self.loadMore.endLoading()
        if awemeModel?.has_more == 0 {
            self.loadMore.loadingAll()
        }
    }
}

extension MyViewController: MyNavigationBarViewDelegate {
    func MyNavigationBarViewBackDidSelected(navigationBarView: MyNavigationBarView) {
        navigationController?.popViewController(animated: true)
    }
    func MyNavigationBarViewMoreDidSelected(navigationBarView: MyNavigationBarView) {
        let moreAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cleanAction = UIAlertAction(title: "清理缓存", style: UIAlertAction.Style.default) { (_) in
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        moreAlert.addAction(cleanAction)
        moreAlert.addAction(cancelAction)
        present(moreAlert, animated: true, completion: nil)
    }
}

extension MyViewController: UserInfoHeaderViewDelegate {
    func userInfoHeaderViewPortraitImageViewDidSelected() {
        
    }
    func userInfoHeaderViewGithubButtonDidSelected() {
        UIApplication.shared.openURL(URL.init(string: "https://github.com/XiaopingSun/DouyinOfSun")!)
    }
    func userInfoHeaderViewSendMessageButtonDidSelected() {
        
    }
    func userInfoHeaderView(headerView: UserInfoHeaderView, tabbarDidSelectedWithType type: UserInfoHeaderTabbarType) {
        awemeList.removeAll()
        selectedTabbarType = type
        pageNumber = 1
        collectionView.contentOffset = CGPoint(x: 0, y: 0)
        collectionView.reloadSections(IndexSet(integer: 1))
        
        self.loadMore.reset()
        self.loadMore.startLoading()
        self.loadAwemeData(pageNumber: self.pageNumber)
    }
}

extension MyViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView: UserInfoHeaderView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as! UserInfoHeaderView
        headerView.updateHeaderView(contentOffset: scrollView.contentOffset)
        navigationBarView.updateNavigationBar(contentOffset: scrollView.contentOffset, headerFrame: headerView.frame)
    }
}

extension MyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension MyViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return awemeList.count
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIndentifier, for: indexPath) as! MyCollectionViewCell
        if indexPath.item == 3 {
            
        }
        cell.aweme_list = awemeList[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.row == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewIdentifier, for: indexPath) as! UserInfoHeaderView
                headerView.delegate = self
                headerView.user = self.user
                return headerView
            }
        }
        return UICollectionReusableView()
    }
}

extension MyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return MyCollectionViewCell.sizeForCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize(width: kScreenWidth, height: UserInfoHeaderView.heightValue()) : .zero
    }
}
