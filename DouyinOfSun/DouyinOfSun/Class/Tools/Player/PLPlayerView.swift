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
}

class PLPlayerView: UIView {
    
    weak var delegate: PLPlayerViewDelegate?
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView(frame: CGRect.zero)
        backgroundImageView.image = UIImage(named: "img_video_loading")
        return backgroundImageView
    }()
    
    private lazy var player: PLPlayer? = {
        let option = PLPlayerOption.default()
        option.setOptionValue(15, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        let player = PLPlayer(url: nil, option: option)
        player?.loopPlay = true
        player?.delegate = self
        player?.delegateQueue = DispatchQueue.main
        player?.isBackgroundPlayEnable = false
        return player
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playWithUrl(urlStr: String) {
        player?.play(with: URL(string: urlStr), sameSource: true)
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
            player?.stop()
        }
    }
}

extension PLPlayerView {
    private func initSubviews() {
        addSubview(backgroundImageView)
        guard let playerView = player?.playerView else { return }
        playerView.contentMode = .scaleAspectFit
        addSubview(playerView)
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        playerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension PLPlayerView: PLPlayerDelegate {
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        delegate?.playerView!(self, player, statusDidChange: state)
    }
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        delegate?.playerView!(self, player, stoppedWithError: error)
    }
    func player(_ player: PLPlayer, firstRender firstRenderType: PLPlayerFirstRenderType) {
        delegate?.playerView!(self, player, firstRender: firstRenderType)
    }
}
