//
//  HomeScrollView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/2/22.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class HomeScrollView: UIScrollView {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return !panBack(sender: gestureRecognizer)
    }

    private func panBack(sender: UIGestureRecognizer) -> Bool {
        if sender == panGestureRecognizer {
            
            let translation = (sender as! UIPanGestureRecognizer).translation(in: sender.view)
            
            if sender.state == .began || sender.state == .possible {
                // 滑动到contentOffset = kScreenWidth再左滑
                if translation.x < 0 && contentOffset.x == kScreenWidth {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }

        } else {
            return false
        }
    }
}

extension HomeScrollView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return panBack(sender: gestureRecognizer)
    }
}
