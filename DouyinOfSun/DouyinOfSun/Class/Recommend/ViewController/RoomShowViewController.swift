//
//  RoomShowViewController.swift
//  DouyuTVOfSun
//
//  Created by WorkSpace_Sun on 2018/12/12.
//  Copyright © 2018 WorkSpace_Sun. All rights reserved.
//

import UIKit
import PLMediaStreamingKit
import SnapKit

class RoomShowViewController: BaseViewController {
    
    private var pushUrl: String
    
    private var cameraPosition: AVCaptureDevice.Position
    private var isVideoToolBox: PLH264EncoderType
    private var sessionPreset: AVCaptureSession.Preset
    private var videoSize: CGSize
    private var frameRate: UInt
    private var bitrate: UInt
    private var keyframeInterval: UInt
    private var isQuicEnable: Bool
    
    private lazy var startPushButton: UIButton = {[weak self] in
        let startPushButton = UIButton(type: .custom)
        startPushButton.setTitle("开始直播", for: .normal)
        startPushButton.backgroundColor = UIColor.clear
        startPushButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        startPushButton.setTitleColor(UIColor.orange, for: .normal)
        startPushButton.setTitleColor(UIColor.orange, for: .selected)
        startPushButton.layer.borderColor = UIColor.orange.cgColor
        startPushButton.layer.borderWidth = 1
        startPushButton.layer.masksToBounds = true
        startPushButton.layer.cornerRadius = 20
        startPushButton.addTarget(self, action: #selector(startPushAction(sender:)), for: .touchUpInside)
        return startPushButton
    }()
    
    private lazy var closeButton: UIButton = {[weak self] in
        let closeButton: UIButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "live_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        return closeButton
    }()
    
    private lazy var pushInfoBgView: UIView = {
        let pushInfoBgView = UIView(frame: .zero)
        pushInfoBgView.backgroundColor = UIColor(r: 0, g: 0, b: 0, alpha: 0.5)
        pushInfoBgView.layer.masksToBounds = true
        pushInfoBgView.layer.cornerRadius = 5
        return pushInfoBgView
    }()
    
    private lazy var videoFPSLabel: UILabel = {
        let videoFPSLabel = UILabel(frame: .zero)
        videoFPSLabel.text = "视频帧率："
        videoFPSLabel.textColor = UIColor.white
        videoFPSLabel.textAlignment = .left
        videoFPSLabel.font = UIFont.systemFont(ofSize: 12)
        return videoFPSLabel
    }()
    
    private lazy var audioFPSLabel: UILabel = {
        let audioFPSLabel = UILabel(frame: .zero)
        audioFPSLabel.text = "音频帧率："
        audioFPSLabel.textColor = UIColor.white
        audioFPSLabel.textAlignment = .left
        audioFPSLabel.font = UIFont.systemFont(ofSize: 12)
        return audioFPSLabel
    }()
    
    private lazy var totalBitrateLabel: UILabel = {
        let totalBitrateLabel = UILabel(frame: .zero)
        totalBitrateLabel.text = "总码率："
        totalBitrateLabel.textColor = UIColor.white
        totalBitrateLabel.textAlignment = .left
        totalBitrateLabel.font = UIFont.systemFont(ofSize: 12)
        return totalBitrateLabel
    }()
    
    private lazy var streamingSession: PLMediaStreamingSession = {[weak self] in
        let videoCaptureConfiguration: PLVideoCaptureConfiguration = PLVideoCaptureConfiguration(videoFrameRate: frameRate, sessionPreset: sessionPreset.rawValue, previewMirrorFrontFacing: true, previewMirrorRearFacing: false, streamMirrorFrontFacing: false, streamMirrorRearFacing: false, cameraPosition: cameraPosition, videoOrientation: AVCaptureVideoOrientation.portrait)
        let videoStreamingConfiguration: PLVideoStreamingConfiguration = PLVideoStreamingConfiguration(videoSize: videoSize, expectedSourceVideoFrameRate: frameRate, videoMaxKeyframeInterval: keyframeInterval, averageVideoBitRate: bitrate, videoProfileLevel: AVVideoProfileLevelH264HighAutoLevel, videoEncoderType: isVideoToolBox)
        let streamingSession: PLMediaStreamingSession = PLMediaStreamingSession(videoCaptureConfiguration: videoCaptureConfiguration, audioCaptureConfiguration: PLAudioCaptureConfiguration.default(), videoStreamingConfiguration: videoStreamingConfiguration, audioStreamingConfiguration: PLAudioStreamingConfiguration.default(), stream: nil)

        streamingSession.setBeautifyModeOn(true)
        streamingSession.delegate = self
        streamingSession.isQuicEnable = isQuicEnable
        if sessionPreset == .hd1280x720 {
            streamingSession.setWaterMarkWith(UIImage(named: "live_watermark"), position: CGPoint(x: 720 - 132 - 30 * 720 / kScreenWidth, y: 50 * 1280 / kScreenHeight))
        } else if sessionPreset == .hd1920x1080 {
            streamingSession.setWaterMarkWith(UIImage(named: "live_watermark"), position: CGPoint(x: 1080 - 132 - 30 * 720 / kScreenWidth, y: 50 * 1920 / kScreenHeight))
        }

        return streamingSession
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        addNotification()
        streamingSession.startCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarHidden = true
    }
    
    init(pushUrl: String, cameraPosition: AVCaptureDevice.Position, isVideoToolBox: PLH264EncoderType, sessionPreset: AVCaptureSession.Preset, videoSize: CGSize, frameRate: UInt, bitrate: UInt, keyframeInterval: UInt, isQuicEnable: Bool) {
        self.pushUrl = pushUrl
        self.cameraPosition = cameraPosition
        self.isVideoToolBox = isVideoToolBox
        self.sessionPreset = sessionPreset
        self.videoSize = videoSize
        self.frameRate = frameRate
        self.bitrate = bitrate
        self.keyframeInterval = keyframeInterval
        self.isQuicEnable = isQuicEnable
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("RoomShowViewController dealloc")
    }
    
    @objc private func closeAction() {
        streamingSession.destroy()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func startPushAction(sender: UIButton) {
        
        if streamingSession.isStreamingRunning == false {
            sender.isEnabled = false
            sender.setTitleColor(UIColor.gray, for: .normal)
            
            streamingSession.startStreaming(withPush: URL(string: pushUrl)) { (state: PLStreamStartStateFeedback) in
                DispatchQueue.main.async {
                    sender.isEnabled = true
                    sender.setTitleColor(UIColor.orange, for: .normal)
                    if state == PLStreamStartStateFeedback.success {
                        sender.setTitle("结束直播", for: .normal)
                    } else {
                        let alert = UIAlertController(title: "Warning", message: "push failed", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            streamingSession.stopStreaming()
            sender.setTitle("开始直播", for: .normal)
        }
    }
    
    @objc private func willResignActive() {
        streamingSession.setPush(UIImage(named: "2channel_thumbImage"))
    }
    
    @objc private func didBecomeActive() {
        streamingSession.setPush(nil)
    }
}

extension RoomShowViewController {
    private func setupUI() {

        view.addSubview(closeButton)
        view.addSubview(startPushButton)
        view.addSubview(pushInfoBgView)
        pushInfoBgView.addSubview(videoFPSLabel)
        pushInfoBgView.addSubview(audioFPSLabel)
        pushInfoBgView.addSubview(totalBitrateLabel)
        view.insertSubview(streamingSession.previewView, at: 0)
        
        closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalToSuperview().offset(50)
            make.width.height.equalTo(20)
        }
        startPushButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
        pushInfoBgView.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.left.equalTo(closeButton)
            make.width.equalTo(180)
            make.height.equalTo(100)
        }
        videoFPSLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
        }
        audioFPSLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(videoFPSLabel)
        }
        totalBitrateLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-20)
            make.left.equalTo(videoFPSLabel)
        }
        streamingSession.previewView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension RoomShowViewController {
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

extension RoomShowViewController: PLMediaStreamingSessionDelegate {
    func mediaStreamingSession(_ session: PLMediaStreamingSession!, streamStateDidChange state: PLStreamState) {
        DispatchQueue.main.async {
            if PLStreamState.disconnected == state {
                self.startPushButton.setTitle("开始直播", for: .normal)
                self.videoFPSLabel.text = "视频帧率："
                self.audioFPSLabel.text = "音频帧率："
                self.totalBitrateLabel.text = "总码率："
            } else if PLStreamState.connected == state {
                self.startPushButton.setTitle("结束直播", for: .normal)
            }
        }
    }
    func mediaStreamingSession(_ session: PLMediaStreamingSession!, streamStatusDidUpdate status: PLStreamStatus!) {
        self.videoFPSLabel.text = String(format: "视频帧率：%.2f fps", status.videoFPS)
        self.audioFPSLabel.text = String(format: "音频帧率：%.2f fps", status.audioFPS)
        self.totalBitrateLabel.text = String(format: "总码率：%.2f bps", status.totalBitrate)
    }
    func mediaStreamingSession(_ session: PLMediaStreamingSession!, didDisconnectWithError error: Error!) {
        startPushButton.setTitle("开始直播", for: .normal)
        let alert = UIAlertController(title: "Warning", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: {
            self.videoFPSLabel.text = "视频帧率："
            self.audioFPSLabel.text = "音频帧率："
            self.totalBitrateLabel.text = "总码率："
        })
    }
}
