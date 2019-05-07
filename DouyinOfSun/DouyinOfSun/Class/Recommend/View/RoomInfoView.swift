//
//  RoomInfoView.swift
//  DouyinOfSun
//
//  Created by WorkSpace_Sun on 2019/5/6.
//  Copyright © 2019 WorkSpace_Sun. All rights reserved.
//

import UIKit
import SnapKit
import PLMediaStreamingKit

private let cellIdentifier: String = "cellIdentifier"

protocol RoomInfoViewDelegate: class {
    func roomInfoView(roomInfoView: RoomInfoView, startPushActionWithPushUrl pushUrlStr: String?)
}

class RoomInfoView: UIView {
    
    weak var delegate: RoomInfoViewDelegate?
    
    private var sessionPresetShow: [String] = [
        "AVCaptureSessionPreset352x288",
        "AVCaptureSessionPreset640x480",
        "AVCaptureSessionPreset1280x720",
        "AVCaptureSessionPreset1920x1080",
        "AVCaptureSessionPresetLow",
        "AVCaptureSessionPresetMedium",
        "AVCaptureSessionPresetHigh",
        "AVCaptureSessionPresetPhoto",
        "AVCaptureSessionPresetInputPriority",
        "AVCaptureSessionPresetiFrame960x540",
        "AVCaptureSessionPresetiFrame1280x720",
    ]
    
    let sessionPresetList: [AVCaptureSession.Preset] = [
        AVCaptureSession.Preset.cif352x288,
        AVCaptureSession.Preset.vga640x480,
        AVCaptureSession.Preset.hd1280x720,
        AVCaptureSession.Preset.hd1920x1080,
        AVCaptureSession.Preset.low,
        AVCaptureSession.Preset.medium,
        AVCaptureSession.Preset.high,
        AVCaptureSession.Preset.photo,
        AVCaptureSession.Preset.inputPriority,
        AVCaptureSession.Preset.iFrame960x540,
        AVCaptureSession.Preset.iFrame1280x720,
    ]
    
    private let videoSizeShow: [String] = [
        "368x640",
        "540x960",
        "720x1280",
        "1080x1920"
    ]
    
    private let videoSizeList: [CGSize] = [
        CGSize(width: 368, height: 640),
        CGSize(width: 540, height: 960),
        CGSize(width: 720, height: 1280),
        CGSize(width: 1080, height: 1920)
    ]
    
    private let frameRateList: [UInt] = [5, 10, 15, 20, 24, 30]
    
    var cameraPosition: AVCaptureDevice.Position {
        return positionSegment?.selectedSegmentIndex == 0 ? .front : .back
    }
    
    var isVideoToolBox: PLH264EncoderType {
        return videoToolBoxSegment?.selectedSegmentIndex == 0 ? .videoToolbox : .avFoundation
    }
    
    var sessionPreset: AVCaptureSession.Preset {
        let index = (sessionPresetShow as NSArray).index(of: sessionPresetButton?.titleLabel?.text! as Any)
        return sessionPresetList[index]
    }
    
    var videoSize: CGSize {
        let index = (videoSizeShow as NSArray).index(of: videoSizeButton?.titleLabel?.text! as Any)
        return videoSizeList[index]
    }
    
    var frameRate: UInt {
        return frameRateList[(frameRateSegment?.selectedSegmentIndex)!]
    }
    
    var bitrate: UInt {
        return (UInt(bitRateTextField?.text ?? "1000") ?? 1000) * 1024
    }
    
    var keyframeInterval: UInt {
        return UInt((GOPSegment?.selectedSegmentIndex.advanced(by: 1))!) * frameRate
    }
    
    private var urlTextField: UITextField?
    private var startPushButton: UIButton?
    private var positionSegment: UISegmentedControl?
    private var videoToolBoxSegment: UISegmentedControl?
    private var sessionPresetButton: UIButton?
    private var videoSizeButton: UIButton?
    private var frameRateSegment: UISegmentedControl?
    private var bitRateTextField: UITextField?
    private var GOPSegment: UISegmentedControl?
    private var quicSegment: UISegmentedControl?
    
    private var isSessionPresetSelected: Bool = true
    
    lazy var tableView: UITableView = {[weak self] in
        let tableView: UITableView = UITableView(frame: CGRect(x: 60, y: 240, width: kScreenWidth - 120, height: 44 * 4), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.alpha = 0.01
        tableView.isHidden = true
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 5
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(r: 22, g: 24, b: 35)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension RoomInfoView {
    private func setupUI() {
        let urlLabel = UILabel(frame: CGRect.zero)
        urlLabel.text = "推流URL"
        urlLabel.textColor = UIColor.white
        urlLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(urlLabel)
        
        urlTextField = UITextField(frame: CGRect.zero)
        urlTextField?.borderStyle = .roundedRect
        urlTextField?.text = "rtmp://pili-publish.live.sunxp.qiniuts.com/pursue-live/Sun"
        urlTextField?.textColor = UIColor(r: 22, g: 24, b: 35)
        urlTextField?.backgroundColor = UIColor.white
        urlTextField?.font = UIFont.systemFont(ofSize: 14)
        urlTextField?.clearButtonMode = .whileEditing
        urlTextField?.placeholder = "Input push url"
        addSubview(urlTextField!)
        
        let positionLabel = UILabel(frame: CGRect.zero)
        positionLabel.text = "摄像头位置"
        positionLabel.textColor = UIColor.white
        positionLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(positionLabel)
        
        positionSegment = UISegmentedControl(items: ["FRONT", "BACK"])
        positionSegment?.tintColor = UIColor.white
        positionSegment?.selectedSegmentIndex = 0
        addSubview(positionSegment!)
        
        let videoToolBoxLabel = UILabel(frame: CGRect.zero)
        videoToolBoxLabel.text = "使用videoToolBox"
        videoToolBoxLabel.textColor = UIColor.white
        videoToolBoxLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(videoToolBoxLabel)
        
        videoToolBoxSegment = UISegmentedControl(items: ["YES", "NO"])
        videoToolBoxSegment?.tintColor = UIColor.white
        videoToolBoxSegment?.selectedSegmentIndex = 1
        addSubview(videoToolBoxSegment!)
        
        let sessionPresetLabel = UILabel(frame: CGRect.zero)
        sessionPresetLabel.text = "预览分辨率"
        sessionPresetLabel.textColor = UIColor.white
        sessionPresetLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(sessionPresetLabel)
        
        sessionPresetButton = UIButton(type: UIButton.ButtonType.custom)
        sessionPresetButton?.setTitle("AVCaptureSessionPreset1280x720", for: UIControl.State.normal)
        sessionPresetButton?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        sessionPresetButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        sessionPresetButton?.addTarget(self, action: #selector(showSessionPresetList), for: UIControl.Event.touchUpInside)
        addSubview(sessionPresetButton!)
        
        let videoSizeLabel = UILabel(frame: CGRect.zero)
        videoSizeLabel.text = "编码分辨率"
        videoSizeLabel.textColor = UIColor.white
        videoSizeLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(videoSizeLabel)
        
        videoSizeButton = UIButton(type: UIButton.ButtonType.custom)
        videoSizeButton?.setTitle("540x960", for: UIControl.State.normal)
        videoSizeButton?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        videoSizeButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        videoSizeButton?.addTarget(self, action: #selector(showVideoSizeList), for: UIControl.Event.touchUpInside)
        addSubview(videoSizeButton!)
        
        let frameRateLabel = UILabel(frame: CGRect.zero)
        frameRateLabel.text = "帧率"
        frameRateLabel.textColor = UIColor.white
        frameRateLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(frameRateLabel)
        
        frameRateSegment = UISegmentedControl(items: ["5", "10", "15", "20", "24", "30"])
        frameRateSegment?.tintColor = UIColor.white
        frameRateSegment?.selectedSegmentIndex = 4
        addSubview(frameRateSegment!)
        
        let bitRateLabel = UILabel(frame: CGRect.zero)
        bitRateLabel.text = "码率"
        bitRateLabel.textColor = UIColor.white
        bitRateLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(bitRateLabel)
        
        bitRateTextField = UITextField(frame: CGRect.zero)
        bitRateTextField?.text = "1500"
        bitRateTextField?.borderStyle = .roundedRect
        bitRateTextField?.textColor = UIColor(r: 22, g: 24, b: 35)
        bitRateTextField?.backgroundColor = UIColor.white
        bitRateTextField?.font = UIFont.systemFont(ofSize: 14)
        addSubview(bitRateTextField!)
        
        let kbpsLabel = UILabel(frame: CGRect.zero)
        kbpsLabel.text = "kbps"
        kbpsLabel.textColor = UIColor.white
        kbpsLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(kbpsLabel)
        
        let GOPLabel = UILabel(frame: CGRect.zero)
        GOPLabel.text = "GOP"
        GOPLabel.textColor = UIColor.white
        GOPLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(GOPLabel)
        
        GOPSegment = UISegmentedControl(items: ["1", "2", "3", "4", "5", "6"])
        GOPSegment?.tintColor = UIColor.white
        GOPSegment?.selectedSegmentIndex = 2
        addSubview(GOPSegment!)
        
        let quicLabel = UILabel(frame: CGRect.zero)
        quicLabel.text = "QUIC"
        quicLabel.textColor = UIColor.white
        quicLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(quicLabel)
        
        quicSegment = UISegmentedControl(items: ["YES", "NO"])
        quicSegment?.tintColor = UIColor.white
        quicSegment?.selectedSegmentIndex = 1
        addSubview(quicSegment!)
        
        startPushButton = UIButton(type: UIButton.ButtonType.custom)
        startPushButton?.setTitle("开始直播", for: UIControl.State.normal)
        startPushButton?.setTitleColor(UIColor(r: 22, g: 24, b: 35), for: UIControl.State.normal)
        startPushButton?.backgroundColor = UIColor.white
        startPushButton?.layer.masksToBounds = true
        startPushButton?.layer.cornerRadius = 5
        startPushButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        startPushButton?.addTarget(self, action: #selector(startPush), for: UIControl.Event.touchUpInside)
        addSubview(startPushButton!)
        
        addSubview(tableView)
        
        urlLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(50)
        }
        urlTextField!.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(urlLabel)
        }
        positionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(urlLabel.snp.bottom).offset(30)
            make.left.equalTo(urlLabel)
        }
        positionSegment?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(positionLabel)
        })
        videoToolBoxLabel.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel)
            make.top.equalTo(positionLabel.snp.bottom).offset(30)
        }
        videoToolBoxSegment?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(videoToolBoxLabel)
        })
        sessionPresetLabel.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel)
            make.top.equalTo(videoToolBoxLabel.snp.bottom).offset(30)
        }
        sessionPresetButton?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(sessionPresetLabel)
        })
        videoSizeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel)
            make.top.equalTo(sessionPresetLabel.snp.bottom).offset(30)
        }
        videoSizeButton?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(videoSizeLabel)
        })
        frameRateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel)
            make.top.equalTo(videoSizeLabel.snp.bottom).offset(30)
        }
        frameRateSegment?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(frameRateLabel)
        })
        bitRateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel)
            make.top.equalTo(frameRateLabel.snp.bottom).offset(30)
        }
        kbpsLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(bitRateLabel)
        }
        bitRateTextField?.snp.makeConstraints({ (make) in
            make.right.equalTo(kbpsLabel.snp.left).offset(-10)
            make.centerY.equalTo(bitRateLabel)
        })
        GOPLabel.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel)
            make.top.equalTo(bitRateLabel.snp.bottom).offset(30)
        }
        GOPSegment?.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(GOPLabel)
        }
        quicLabel.snp.makeConstraints { (make) in
            make.left.equalTo(urlLabel)
            make.top.equalTo(GOPLabel.snp.bottom).offset(30)
        }
        quicSegment?.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(quicLabel)
        }
        startPushButton!.snp.makeConstraints { (make) in
            make.top.equalTo(quicLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.height.equalTo(44 * 4)
        }
    }
    
    @objc private func startPush() {
        endEditing(true)
        delegate?.roomInfoView(roomInfoView: self, startPushActionWithPushUrl: urlTextField?.text)
    }
    
    @objc private func showSessionPresetList() {
        isSessionPresetSelected = true
        tableView.reloadData()
        UIView.animate(withDuration: 0.2) {
            self.tableView.alpha = 1.0
            self.tableView.isHidden = false
        }
    }
    
    @objc private func showVideoSizeList() {
        isSessionPresetSelected = false
        tableView.reloadData()
        UIView.animate(withDuration: 0.2) {
            self.tableView.alpha = 1.0
            self.tableView.isHidden = false
        }
    }
    
    func setPushUrl(urlStr: String) {
        urlTextField?.text = urlStr
    }
}

extension RoomInfoView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSessionPresetSelected == true {
            return 11
        } else {
            return 4
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell.textLabel?.textColor = UIColor(r: 22, g: 24, b: 35)
        if isSessionPresetSelected == true {
            cell.textLabel?.text = sessionPresetShow[indexPath.row]
        } else {
            cell.textLabel?.text = videoSizeShow[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSessionPresetSelected == true {
            sessionPresetButton?.setTitle(sessionPresetShow[indexPath.row], for: .normal)
        } else {
            videoSizeButton?.setTitle(videoSizeShow[indexPath.row], for: .normal)
        }
        UIView.animate(withDuration: 0.2) {
            self.tableView.alpha = 0.01
            self.tableView.isHidden = true
        }
    }
}

