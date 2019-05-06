//
//  RecommendViewController.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/1/3.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit
import PLMediaStreamingKit

protocol RecommendViewControllerDelegate: class {
    func recommendViewControllerBackItemDidSelected()
}

class RecommendViewController: UIViewController {
    
    weak var recommendViewControllerDelegate: RecommendViewControllerDelegate?
    
    private lazy var navigationBar: RecommendNavigationBarView = {
        let navigationBar = RecommendNavigationBarView(frame: .zero)
        navigationBar.delegate = self
        return navigationBar
    }()
    
    private lazy var roomInfoView: RoomInfoView = {
        let roomInfoView = RoomInfoView(frame: .zero)
        roomInfoView.delegate = self
        return roomInfoView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 22, g: 24, b: 35)
        initSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if tableView.isHidden == false {
//            UIView.animate(withDuration: 0.2) {
//                self.tableView.alpha = 0.01
//                self.tableView.isHidden = true
//            }
//        }
//        view.endEditing(true)
    }
}

extension RecommendViewController {
    private func initSubviews() {
        view.addSubview(navigationBar)
        view.insertSubview(roomInfoView, belowSubview: navigationBar)
        
        navigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        roomInfoView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(64)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension RecommendViewController: RecommendNavigationBarViewDelegate {
    func navigationBarViewCameraButtonDidSelected() {
        let scanCodeVC = ScanCodeViewController()
        scanCodeVC.delegate = self
        present(scanCodeVC, animated: true, completion: nil)
    }
    func navigationBarViewBackButtonDidSelected() {
        recommendViewControllerDelegate?.recommendViewControllerBackItemDidSelected()
    }
    func navigationBarView(barView: RecommendNavigationBarView, titleViewDidSelectedWithType type: HomeNaviTitleViewSelectedButtonType) {
        
    }
}

extension RecommendViewController: ScanCodeViewControllerDelegate {
    func scanCodeViewController(_ viewController: ScanCodeViewController, didCompleteScanning codeString: String?) {
        guard let codeString = codeString else {
            let alert = UIAlertController(title: "Warning", message: "scan code is nil", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        roomInfoView.setPushUrl(urlStr: codeString)
    }
}

extension RecommendViewController: RoomInfoViewDelegate {
    func roomInfoView(roomInfoView: RoomInfoView, startPushActionWithPushUrl pushUrlStr: String?) {
        guard (pushUrlStr != "") else {
            let alert = UIAlertController(title: "Warning", message: "push url is nil", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let pushUrl = (pushUrlStr?.replacingOccurrences(of: " ", with: ""))!
        let showViewController = RoomShowViewController(pushUrl:pushUrl, cameraPosition: roomInfoView.cameraPosition, isVideoToolBox: roomInfoView.isVideoToolBox, sessionPreset: roomInfoView.sessionPreset, videoSize: roomInfoView.videoSize, frameRate: roomInfoView.frameRate, bitrate: roomInfoView.bitrate, keyframeInterval: roomInfoView.keyframeInterval)
        present(showViewController, animated: true, completion: nil)
    }
}
