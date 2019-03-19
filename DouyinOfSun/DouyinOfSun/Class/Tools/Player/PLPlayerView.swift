//
//  PLPlayerView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/3/12.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import PLPlayerKit
import SnapKit

@objc protocol PLPlayerViewDelegate: class {
    @objc optional func playerView(_ playerView: PLPlayerView, _ player: PLPlayer, statusDidChange state: PLPlayerStatus)
    @objc optional func playerView(_ playerView: PLPlayerView, _ player: PLPlayer, stoppedWithError error: Error?)
    @objc optional func playerView(_ playerView: PLPlayerView, _ player: PLPlayer, firstRender firstRenderType: PLPlayerFirstRenderType)
    @objc optional func playerView(_ playerView: PLPlayerView, _ player: PLPlayer, playingProgressValue playingProgress: CGFloat)
}

class PLPlayerView: UIView {
    
    weak var delegate: PLPlayerViewDelegate?
    
    private var player: PLPlayer?
    private var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func progressTimerAction() {
        let currentTime = CMTimeGetSeconds((self.player?.currentTime)!)
        let duration = CMTimeGetSeconds((self.player?.totalDuration)!)
        self.delegate?.playerView!(self, (self.player)!, playingProgressValue: CGFloat(currentTime / duration))
    }
    
    func playWithUrl(urlStr: String) {
        let option = PLPlayerOption.default()
        option.setOptionValue(15, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        self.player = PLPlayer(url: URL(string: urlStr), option: option)
        player?.loopPlay = true
        player?.delegate = self
        player?.delegateQueue = DispatchQueue.main
        player?.isBackgroundPlayEnable = false
        
        guard let playerView = player?.playerView else { return }
        playerView.contentMode = .scaleAspectFit
        addSubview(playerView)
        playerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        player?.play()
    }
    
    func resume() {
        if player?.status == .statusPaused {
            player?.resume()
        }
    }
    
    func pause() {
        if player?.status == .statusPlaying {
            player?.pause()
        }
    }
    
    func stop() {
        if player?.status == .statusPlaying || player?.status == .statusPaused {
            timer?.invalidate()
            timer = nil
            player?.stop()
            player?.playerView?.removeFromSuperview()
            player = nil
        }
    }
}

extension PLPlayerView: PLPlayerDelegate {
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        delegate?.playerView!(self, player, statusDidChange: state)
    }
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        timer?.invalidate()
        timer = nil
        delegate?.playerView!(self, player, stoppedWithError: error)
    }
    func player(_ player: PLPlayer, firstRender firstRenderType: PLPlayerFirstRenderType) {
        if firstRenderType == .video {
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {[weak self] (timer) in
                    let currentTime = CMTimeGetSeconds((self?.player?.currentTime)!)
                    let duration = CMTimeGetSeconds((self?.player?.totalDuration)!)
                    self?.delegate?.playerView!(self!, (self?.player)!, playingProgressValue: CGFloat(currentTime / duration))
                })
            } else {
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(progressTimerAction), userInfo: nil, repeats: true)
            }
            timer?.fire()
        }
        delegate?.playerView!(self, player, firstRender: firstRenderType)
    }
}
