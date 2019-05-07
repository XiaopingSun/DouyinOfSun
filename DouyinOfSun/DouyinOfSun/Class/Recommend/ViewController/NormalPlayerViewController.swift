//
//  NormalPlayerViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/5/7.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import PLPlayerKit
import SnapKit

class NormalPlayerViewController: BaseViewController {
    
    var playUrlStr: String?
    
    private var isLive: Bool = false
    
    private lazy var closeButton: UIButton = {[weak self] in
        let closeButton: UIButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "live_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return closeButton
    }()
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        activityIndicatorView.stopAnimating()
        return activityIndicatorView
    }()
    
    private lazy var player: PLPlayer = {
        let option = PLPlayerOption.default()
        option.setOptionValue(kPLLogNone.rawValue, forKey: PLPlayerOptionKeyLogLevel)
        option.setOptionValue(10, forKey: PLPlayerOptionKeyTimeoutIntervalForMediaPackets)
        option.setOptionValue(2000, forKey: PLPlayerOptionKeyMaxL1BufferDuration)
        option.setOptionValue(1000, forKey: PLPlayerOptionKeyMaxL2BufferDuration)
        option.setOptionValue(false, forKey: PLPlayerOptionKeyVideoToolbox)
        
        let player = PLPlayer(url: URL(string: playUrlStr!), option: option)
        player?.delegate = self
        player?.delegateQueue = DispatchQueue.main
        player?.loopPlay = true
        player?.isBackgroundPlayEnable = true
        player?.playerView?.frame = view.bounds
        player?.playerView?.contentMode = .scaleAspectFit
        return player!
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(player.playerView!)
        view.addSubview(closeButton)
        view.addSubview(activityIndicatorView)
        
        player.playerView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(50)
            make.width.height.equalTo(20)
        }
        activityIndicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let url = NSURL(string: playUrlStr!)
        let scheme: String = url?.scheme ?? "";
        let pathExtension: String = url?.pathExtension ?? "";
        if (scheme == "rtmp" && pathExtension != "pili") || (scheme == "http" && pathExtension == "flv") {
            isLive = true
        } else {
            isLive = false
        }
        
        player.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarHidden = true
    }
    
    @objc private func closeAction() {
        player.stop()
        player.playerView?.removeFromSuperview()
        dismiss(animated: true, completion: nil)
    }
}

extension NormalPlayerViewController: PLPlayerDelegate {
    func playerWillEndBackgroundTask(_ player: PLPlayer) {
        if player.isPlaying == false {
            if isLive == true {
                player.play()
            } else {
                player.resume()
            }
        }
    }
    func playerWillBeginBackgroundTask(_ player: PLPlayer) {
        if player.isPlaying == true {
            if isLive == true {
                player.stop()
            } else {
                player.pause()
            }
        }
    }
    func player(_ player: PLPlayer, statusDidChange state: PLPlayerStatus) {
        if state == .statusCaching {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    func player(_ player: PLPlayer, stoppedWithError error: Error?) {
        activityIndicatorView.stopAnimating()
        let alert = UIAlertController(title: "Warning", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
