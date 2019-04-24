//
//  HotCellCacheManager.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/16.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import AVFoundation

class HotCellCacheManager: NSObject {
    
    private var cellArray = [HotTableViewCell]()
    var currentPlayingCell: HotTableViewCell?
    
    func play(cell: HotTableViewCell) {
        stopAll()
        if !cellArray.contains(cell) {
            cellArray.append(cell)
        }
        cell.play()
        currentPlayingCell = cell
    }
    
    func pauseAll() {
        for cell in cellArray {
            cell.pause(isPauseIconHidden: true)
        }
    }
    
    func stopAll() {
        for cell in cellArray {
            cell.stop()
        }
        currentPlayingCell = nil
    }
    
    func resume() {
        currentPlayingCell?.resume()
    }
    
    func updateVolume(newValue: CGFloat, oldValue: CGFloat) {
        currentPlayingCell?.updateVolume(newValue: newValue, oldValue: oldValue)
    }
}
