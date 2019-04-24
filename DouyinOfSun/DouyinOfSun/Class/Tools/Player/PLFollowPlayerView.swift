//
//  PLFollowPlayerView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/4/1.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import PLPlayerKit
import SnapKit

class PLFollowPlayerView: UIView {
    
    enum PlayViewState {
        case small
        case animating
        case fullScreen
    }
    
    var playViewState: PlayViewState = .small
    var playerViewFrame: CGRect = CGRect.zero
    private var timer: Timer?
    private var urlStr: String?
    private var isManualPause: Bool = false
    private var isPlayerCaching: Bool = false
    private var currentProgress: CGFloat = 0
    private lazy var player: PLPlayer = {
        let option = PLPlayerOption.default()
        option.setOptionValue(15, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        let player = PLPlayer(url: nil, option: option)
        player?.loopPlay = true
        player?.delegate = self
        player?.delegateQueue = DispatchQueue.main
        player?.isBackgroundPlayEnable = false
        return player!
    }()
    
    private lazy var coverImageView: UIImageView = {
        let coverImageView = UIImageView(frame: .zero)
        coverImageView.backgroundColor = UIColor.black
        coverImageView.contentMode = .scaleAspectFill
        return coverImageView
    }()

    private lazy var musicIcon: UIImageView = {
        let musicIcon = UIImageView(frame: .zero)
        musicIcon.image = UIImage(named: "icon_home_musicnote3")
        musicIcon.contentMode = .center
        return musicIcon
    }()
    
    private lazy var musicName: CircleTextView = {
        let musicName = CircleTextView(frame: .zero)
        musicName.font = UIFont.systemFont(ofSize: 14)
        musicName.textColor = UIColor.white
        return musicName
    }()
    
    private lazy var playIcon: UIImageView = {
        let playIcon = UIImageView(frame: .zero)
        playIcon.image = UIImage(named: "icon_modern_feed_play_28x28_")
        playIcon.contentMode = .center
        playIcon.isHidden = true
        playIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(playIconAction)))
        return playIcon
    }()
    
    private lazy var pauseIcon: UIImageView = {
        let pauseIcon = UIImageView(frame: .zero)
        pauseIcon.image = UIImage(named: "icon_modern_feed_stop_28x28_")
        pauseIcon.contentMode = .center
        pauseIcon.isHidden = true
        pauseIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pauseIconAction)))
        return pauseIcon
    }()
    
    private lazy var loadingIcon: UIImageView = {
        let loadingIcon = UIImageView(frame: .zero)
        loadingIcon.image = UIImage(named: "icon_modern_feed_loading_28x28_")
        loadingIcon.contentMode = .center
        loadingIcon.isHidden = true
        return loadingIcon
    }()
    
    private lazy var progressBarContainer: UIView = {
        let progressBarContainer = UIView(frame: .zero)
        progressBarContainer.backgroundColor = UIColor.clear
        return progressBarContainer
    }()
    
    private lazy var progressBar: UIView = {
        let progressBar = UIView(frame: .zero)
        progressBar.backgroundColor = UIColor(r: 232, g: 232, b: 234)
        return progressBar
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    func resetAll() {
        timer?.invalidate()
        timer = nil
        urlStr = nil
        isPlayerCaching = false
        isManualPause = false
        currentProgress = 0
        player.stop()
        musicName.text = ""
        musicName.reset()
        playIcon.isHidden = true
        pauseIcon.isHidden = true
        loadingIcon.isHidden = true
        progressBar.snp.updateConstraints { (make) in
            make.width.equalTo(0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initMaskLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func progressTimerAction() {
        let progress = CGFloat(CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.totalDuration))
        if progress == currentProgress {
            return
        }
        if progress < currentProgress {
            self.progressBar.snp.updateConstraints { (make) in
                make.width.equalTo(self.bounds.size.width)
            }
            self.progressBarContainer.setNeedsLayout()
            UIView.animate(withDuration: 0.3, animations: {
                self.progressBarContainer.layoutIfNeeded()
            }) { (_) in
                self.progressBar.snp.updateConstraints({ (make) in
                    make.width.equalTo(0)
                })
                self.progressBarContainer.setNeedsLayout()
                self.progressBarContainer.layoutIfNeeded()
                self.progressBar.snp.updateConstraints({ (make) in
                    make.width.equalTo(progress * self.bounds.size.width)
                })
                self.progressBarContainer.setNeedsLayout()
                UIView.animate(withDuration: 0.2, animations: {
                    self.progressBarContainer.layoutIfNeeded()
                })
            }
        } else {
            self.progressBar.snp.updateConstraints { (make) in
                make.width.equalTo(progress * self.bounds.size.width)
            }
            self.progressBarContainer.setNeedsLayout()
            UIView.animate(withDuration: 0.5, animations: {
                self.progressBarContainer.layoutIfNeeded()
            })
        }
        self.currentProgress = progress
    }
    
    func setEnable(_ isEnable: Bool) {
        playIcon.isUserInteractionEnabled = isEnable
        pauseIcon.isUserInteractionEnabled = isEnable
    }
}

extension PLFollowPlayerView {
    private func initSubviews() {
        guard let playerView = player.playerView else { return }
        playerView.contentMode = .scaleAspectFill
        addSubview(playerView)
        addSubview(musicIcon)
        addSubview(musicName)
        addSubview(playIcon)
        addSubview(pauseIcon)
        addSubview(loadingIcon)
        addSubview(progressBarContainer)
        progressBarContainer.addSubview(progressBar)
        
        playerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        musicIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-12)
        }
        musicName.snp.makeConstraints { (make) in
            make.left.equalTo(musicIcon.snp.right).offset(10)
            make.centerY.equalTo(musicIcon)
            make.width.equalTo(180)
            make.height.equalTo(24)
        }
        playIcon.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-8)
        }
        pauseIcon.snp.makeConstraints { (make) in
            make.center.equalTo(playIcon)
        }
        loadingIcon.snp.makeConstraints { (make) in
            make.center.equalTo(playIcon)
        }
        progressBarContainer.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1.2)
        }
        progressBar.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(0.1)
        }
    }
    
    private func initMaskLayer() {
        let round = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: 5.0, height: 5.0))
        let shape = CAShapeLayer()
        shape.path = round.cgPath
        self.layer.mask = shape
    }
    
    func loadPlayer(urlStr: String?, coverUrlStr: String, musicName: String, musicAuthor: String) {
        self.loadingIcon.isHidden = true
        self.playIcon.isHidden = false
        self.pauseIcon.isHidden = true
        self.currentProgress = 0
        self.progressBar.snp.updateConstraints { (make) in
            make.width.equalTo(0.1)
        }
        self.musicName.reset()
        self.musicName.text = musicName + " - " + musicAuthor
        self.urlStr = urlStr
        self.coverImageView.setImageWithURL(imageUrl: URL(string: coverUrlStr)!) {[weak self] (image, error) in
            self?.coverImageView.image = image
        }
        insertSubview(coverImageView, aboveSubview: player.playerView!)
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func showCachingAnimation() {
        if isPlayerCaching == true { return }
        isPlayerCaching = true
        loadingIcon.isHidden = false
        playIcon.isHidden = true
        pauseIcon.isHidden = true
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = 1.0
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.repeatCount = MAXFLOAT
        loadingIcon.layer.add(rotateAnimation, forKey: nil)
    }
    
    private func removeCachingAnimation() {
        if isPlayerCaching == false { return }
        isPlayerCaching = false
        loadingIcon.layer.removeAllAnimations()
        loadingIcon.isHidden = true
    }
    
    @objc private func playIconAction() {
        self.resume(isIgnoreManualPause: true)
    }
    
    @objc private func pauseIconAction() {
        self.manualPause()
    }
    
    @objc func play() {
        guard let urlStr = urlStr else { return }
        if player.status == .statusPaused {
            self.resume(isIgnoreManualPause: true)
        } else {
            player.play(with: URL(string: urlStr), sameSource: false)
            self.musicName.startAnimation()
        }
    }
    
    @objc func pause() {
        if player.status == .statusPlaying {
            player.pause()
        }
    }
    
    func resume(isIgnoreManualPause: Bool) {
        if player.status == .statusPaused {
            if isIgnoreManualPause == false && isManualPause == true { return }
            isManualPause = false
            player.resume()
        }
    }
    
    @objc func manualResume() {
        if player.status == .statusPaused {
            isManualPause = false
            player.resume()
        }
    }
    
    @objc private func manualPause() {
        isManualPause = true
        if player.status == .statusPlaying {
            player.pause()
        }
    }
    
    private func stop() {
        timer?.invalidate()
        timer = nil
        player.stop()
    }
}

extension PLFollowPlayerView: PLPlayerDelegate {
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        if state == .statusCaching || state == .statusPreparing || state == .statusReady {
            showCachingAnimation()
        } else {
            removeCachingAnimation()
        }
        if state == .statusPaused {
            playIcon.isHidden = false
            pauseIcon.isHidden = true
            timer?.invalidate()
            timer = nil
        } else if state == .statusPlaying {
            playIcon.isHidden = true
            pauseIcon.isHidden = false
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {[weak self] (timer) in
                    self?.progressTimerAction()
                })
            } else {
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(progressTimerAction), userInfo: nil, repeats: true)
            }
            RunLoop.current.add(timer!, forMode: .common)
            timer?.fire()
        }
    }
    func player(_ player: PLPlayer, firstRender firstRenderType: PLPlayerFirstRenderType) {
        if firstRenderType == .video {
            coverImageView.removeFromSuperview()
        }
    }
}
