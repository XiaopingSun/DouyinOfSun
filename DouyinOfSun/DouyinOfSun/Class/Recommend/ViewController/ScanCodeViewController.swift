//
//  ScanCodeViewController.swift
//  DouyuTVOfSun
//
//  Created by WorkSpace_Sun on 2018/12/14.
//  Copyright © 2018 WorkSpace_Sun. All rights reserved.
//

import UIKit
import AVFoundation

protocol ScanCodeViewControllerDelegate: class {
    func scanCodeViewController(_ viewController: ScanCodeViewController, didCompleteScanning codeString: String?)
}

class ScanCodeViewController: BaseViewController {
    
    private lazy var captureSession: AVCaptureSession = AVCaptureSession()
    private lazy var captureOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    var delegate: ScanCodeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange
        setupUI()
        setupCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        statusBarHidden = true
    }
    
    deinit {
        print("scan code vc dealloc")
    }
    
    @objc private func closeAction() {
        captureSession.stopRunning()
        dismiss(animated: true, completion: nil)
    }
}

extension ScanCodeViewController {
    private func setupUI() {
        let closeButton: UIButton = UIButton(type: .custom)
        closeButton.frame = CGRect(x: 30, y: 50, width: 20, height: 20)
        closeButton.setImage(UIImage(named: "live_close"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(closeButton)
    }
}

extension ScanCodeViewController {
    private func setupCamera() {
        guard let captureDevice: AVCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {return}
        try? captureDevice.lockForConfiguration()
        if captureDevice.hasTorch == true {
            captureDevice.torchMode = .auto
        }
        captureDevice.unlockForConfiguration()
        
        guard let captureInput: AVCaptureDeviceInput = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(captureInput)
        captureSession.addOutput(captureOutput)
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.global())
        captureOutput.metadataObjectTypes = [.qr]
        
        let previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
        
        captureSession.startRunning()
    }
}

extension ScanCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let metadata: AVMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            let codeString = metadata.stringValue
            captureSession.stopRunning()

            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    self.delegate?.scanCodeViewController(self, didCompleteScanning: codeString)
                }
            }
        }
    }
}
