//
//  CALayer-Extension.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/18.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit

extension CALayer {
    func pauseLayer() {
        let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = 0.0
        self.timeOffset = pausedTime
    }
    
    func resumeLayer() {
        let pausedTime = self.timeOffset
        self.speed = 1.0
        self.timeOffset = 0.0
        self.beginTime = 0.0
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }
}
