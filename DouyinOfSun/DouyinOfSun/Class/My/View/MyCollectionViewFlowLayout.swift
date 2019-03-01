//
//  MyCollectionViewFlowLayout.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/28.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

private let kFooterTabbarHeight: CGFloat = 36

class MyCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 流式布局
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let superArray: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElements(in: rect)!
        
        // header在section1划出屏幕区域后不会被添加到superArray里，这里每次先移除掉在从section1中取出来添加到array，保证header始终在屏幕区域
        var destArray = [UICollectionViewLayoutAttributes]()
        for index in 0..<superArray.count {
            let attributes = superArray[index]
            if attributes.representedElementKind != UICollectionView.elementKindSectionHeader {
                destArray.append(superArray[index])
            }
        }
        
        if let header = super.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) {
            destArray.append(header)
        }
        
        for attributes in destArray {
            if attributes.indexPath.section == 0 {
                if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                    var rect = attributes.frame
                    if (collectionView?.contentOffset.y)! + kStatusBarH + kNavigationBarH - rect.size.height + kFooterTabbarHeight > rect.origin.y {
                        rect.origin.y = (collectionView?.contentOffset.y)! + kStatusBarH + kNavigationBarH + kFooterTabbarHeight - rect.size.height
                        attributes.frame = rect
                    }
                    attributes.zIndex = 5
                }
            }
        }
        
        return destArray
    }
    
    // 每次边界变化时重新布局 调用 layoutAttributesForElements
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
