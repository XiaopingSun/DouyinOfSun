//
//  MPVolumeViewManager.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/20.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import MediaPlayer

class MPVolumeViewManager: NSObject {
    private override init() {
        super.init()
    }
    private static let instance = MPVolumeViewManager()
    class func shared() -> MPVolumeViewManager {
        return instance
    }
    
    private lazy var volumeView: MPVolumeView = {
        let volumeView: MPVolumeView = MPVolumeView(frame: CGRect(x: 10, y: -100, width: 80, height: 60))
        volumeView.showsRouteButton = true
        return volumeView
    }()
    
    func load() {
        volumeView.isHidden = false
        UIApplication.shared.keyWindow?.addSubview(volumeView)
    }
    
    func unload() {
        volumeView.isHidden = true
        volumeView.removeFromSuperview()
    }
    
    func getSystemVolume() -> CGFloat {
        var volumeViewSlider: UISlider?
        for subview in volumeView.subviews {
            if type(of: subview).description() == "MPVolumeSlider" {
                volumeViewSlider = subview as? UISlider
                break
            }
        }
        return CGFloat(volumeViewSlider?.value ?? 0)
    }
}
