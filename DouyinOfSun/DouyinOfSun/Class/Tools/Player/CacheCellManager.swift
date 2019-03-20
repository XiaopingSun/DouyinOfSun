//
//  CacheCellManager.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/16.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import AVFoundation

class CacheCellManager: NSObject {
    private override init() {
        super.init()
    }
    private static let instance = CacheCellManager()
    class func shared() -> CacheCellManager {
        return instance
    }
    
    private var cellArray = [HotTableViewCell]()
    var currentPlayingCell: HotTableViewCell?
    
    class func setAudioMode() {
        do {
            if #available(iOS 10.0, *) {
                try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback)
            } else {
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("setAudioMode error:" + error.localizedDescription)
        }
    }
    
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
