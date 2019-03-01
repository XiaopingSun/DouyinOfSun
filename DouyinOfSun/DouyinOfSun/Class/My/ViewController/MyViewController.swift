//
//  MyViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/20.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit

private let kCellIndentifier: String = "MyCollectionViewCell"
private let kHeaderViewIdentifier: String = "MyCollectionViewCellHeaderView"
private let kFooterViewIdentifier: String = "MyCollectionViewCellFooterView"

class MyViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MyCollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.orange
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
        return navigationBarView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.randomColor()
        setupUI()
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
        navigationBarView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension MyViewController: UserInfoHeaderViewDelegate {
    func userInfoHeaderViewPortraitImageViewDidSelected() {
        
    }
}

extension MyViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerView: UserInfoHeaderView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as! UserInfoHeaderView
        headerView.updateScrollView(contentOffset: scrollView.contentOffset)
        navigationBarView.updateNavigationBar(contentOffset: scrollView.contentOffset)
    }
}

extension MyViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

extension MyViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return 21
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIndentifier, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.row == 0 {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewIdentifier, for: indexPath) as! UserInfoHeaderView
                headerView.delegate = self
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
