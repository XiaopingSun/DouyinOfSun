//
//  MyCollectionViewCell.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/28.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

private let kItemWidth: CGFloat = (kScreenWidth - 1 * 2) / 3.0
private let kItemHeight: CGFloat = kItemWidth * 1.326

class MyCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func sizeForCell() -> CGSize {
        return CGSize(width: kItemWidth, height: kItemHeight)
    }
}
