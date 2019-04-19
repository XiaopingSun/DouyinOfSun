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
import Photos

private let kCellIndentifier: String = "MyCollectionViewCell"
private let kHeaderViewIdentifier: String = "MyCollectionViewCellHeaderView"
private let kFooterViewIdentifier: String = "MyCollectionViewCellFooterView"

class MyViewController: BaseViewController {
    
    var selectedCellIndex: Int = 0
    
    private var user: user?
    private var awemeList = [aweme_list]()
    private var selectedTabbarType: UserInfoHeaderTabbarType = .productions
    private var pageNumber: Int = 1
    private var headerViewHeight: CGFloat = 0
    private let interactiveTransition: LeftSwipeInteractiveTransition = LeftSwipeInteractiveTransition()
    private let presentAnimation: MyScalePresentAnimation = MyScalePresentAnimation()
    private let dismissAnimation: MyScaleDismissAnimation = MyScaleDismissAnimation()
    
    private lazy var loadMore: LoadMoreControl = {
        let loadMore = LoadMoreControl(frame: CGRect(x: 0, y: headerViewHeight, width: kScreenWidth, height: 50), surplusCount: 6)
        loadMore.startLoading()
        loadMore.onLoad = {[weak self] in
            self?.pageNumber += 1
            self?.loadAwemeData(pageNumber: self!.pageNumber)
        }
        loadMore.superView = collectionView
        return loadMore
    }()
    
    lazy var collectionView: UICollectionView = {
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
        loadData()
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
    
    deinit {
        WebCacheManager.shared().clearMemoryCache()
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
    private func loadData() {
        DispatchQueue.global().async {
            let userInfoJson: String = try! NSString(contentsOfFile: Bundle.main.path(forResource: "user", ofType: "json")!, encoding: String.Encoding.utf8.rawValue) as String
            self.user = JSONDeserializer<UserInfoModel>.deserializeFrom(json: userInfoJson)?.user
            
            DispatchQueue.main.async {
                self.navigationBarView.titleLabel.text = self.user?.nickname
                self.collectionView.reloadSections(IndexSet(integer: 0))
                self.loadAwemeData(pageNumber: self.pageNumber)
            }
        }
    }
    
    private func loadAwemeData(pageNumber: Int) {
        DispatchQueue.global().async {
            let jsonPath = (self.selectedTabbarType == .productions ? "production" : "favorite") + String(pageNumber)
            let awemeDataJson: String = try! NSString(contentsOfFile: Bundle.main.path(forResource: jsonPath, ofType: "json")!, encoding: String.Encoding.utf8.rawValue) as String
            let awemeModel = JSONDeserializer<AwemeModel>.deserializeFrom(json: awemeDataJson)
            var validAwemeModel = [aweme_list]()
            for aweme in (awemeModel?.aweme_list)! {
                if aweme.video != nil {
                    validAwemeModel.append(aweme)
                }
            }
            self.awemeList += validAwemeModel
            
            DispatchQueue.main.async {
                var indexPaths = [IndexPath]()
                for row in Int(self.awemeList.count) - Int(validAwemeModel.count) ..< Int(self.awemeList.count) {
                    indexPaths.append(IndexPath(row: row, section: 1))
                }
                self.collectionView.insertItems(at: indexPaths)
                self.loadMore.endLoading()
                if awemeModel?.has_more == 0 {
                    self.loadMore.loadingAll()
                }
            }
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
            WebCacheManager.shared().clearCache(cacheClearCompletedBlock: { (size) in
                UIWindow.showTips(text: "清除" + size + "M缓存")
            })
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil)
        moreAlert.addAction(cleanAction)
        moreAlert.addAction(cancelAction)
        present(moreAlert, animated: true, completion: nil)
    }
}

extension MyViewController: UserInfoHeaderViewDelegate {
    func userInfoHeaderViewPortraitImageViewDidSelected() {
        let portraitVC = MyIconDetailViewController()
        portraitVC.portraitUrlStr = user?.avatar_larger?.url_list?.first
        portraitVC.delegate = self
        portraitVC.modalTransitionStyle = .crossDissolve
        present(portraitVC, animated: true, completion: nil)
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

extension MyViewController: MyIconDetailViewControllerDelegate {
    func iconDetailViewController(viewController: MyIconDetailViewController, didSelectedDownloadToAlbum image: UIImage?) {
        guard let image = image else {return}
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (success, error) in
            if success == true && error == nil {
                DispatchQueue.main.async {
                    UIWindow.showTips(text: "保存图片成功")
                }
            } else {
                DispatchQueue.main.async {
                    UIWindow.showTips(text: "保存图片失败")
                }
            }
        }
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
        collectionView.deselectItem(at: indexPath, animated: false)
        selectedCellIndex = indexPath.item
        let myAwemeVC = MyAwemeViewController(awemeList: awemeList, currentIndex: indexPath.item)
        myAwemeVC.transitioningDelegate = self
        myAwemeVC.modalPresentationStyle = .custom
        myAwemeVC.modalPresentationCapturesStatusBarAppearance = true
        interactiveTransition.wireToViewController(viewController: myAwemeVC)
        present(myAwemeVC, animated: true, completion: nil)
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

extension MyViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimation
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimation
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.isInteracting == true ? interactiveTransition : nil
    }
}
