//
//  FollowCellCachesManager.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/4/22.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

class FollowCellCachesManager: NSObject {
    
    private var cellArray = [FollowTableViewCell]()
    var currentPlayingCell: FollowTableViewCell?
    
    func play(cell: FollowTableViewCell) {
        pauseAll()
        if !cellArray.contains(cell) {
            cellArray.append(cell)
        }
        cell.play()
        cell.setEnable(true)
        currentPlayingCell = cell
    }
    
    func resume(isIgnoreManualPause: Bool) {
        currentPlayingCell?.resume(isIgnoreManualPause: isIgnoreManualPause)
    }

    func pauseAll() {
        for cell in cellArray {
            cell.pause()
            cell.setEnable(false)
        }
    }
}
