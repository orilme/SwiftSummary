//
//  CameraVC.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: class {
    
    func didOutput(_ code:String)
    
    func didReceiveError(_ error: Error)
    
}


public class CameraViewController: UIViewController {
    
    weak var delegate:CameraViewControllerDelegate?
    
    lazy var animationImage = UIImage()

    public var popVCBolck : (()-> Void)?
    public var rightButtonBlock : (()-> Void)?
    
    /// 动画样式
    var animationStyle:ScanAnimationStyle = .default{
        didSet{
            if animationStyle == .default {
                animationImage = imageNamed("ScanLine")
            }else{
                animationImage = imageNamed("ScanNet")
            }
        }
    }
    
    lazy var scannerColor:UIColor = .red
    
    
    
    /// `AVCaptureMetadataOutput` metadata object types.
    var metadata = [AVMetadataObject.ObjectType]()
    
    // MARK: - Video
    
    /// Video preview layer.
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    /// Video capture device. This may be nil when running in Simulator.
    private lazy var captureDevice = AVCaptureDevice.default(for: .video)
    /// Capture session.
    public lazy var captureSession = AVCaptureSession()
    
    lazy var scanView = ScanView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scanView.startAnimation()
        
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        scanView.stopAnimation()
        
    }
    
}



// MARK: - CustomMethod
extension CameraViewController {
    
    func setupUI() {
        
        view.backgroundColor = .black
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        
        videoPreviewLayer?.frame = view.layer.bounds
        
        guard let videoPreviewLayer = videoPreviewLayer else {
            return
        }
        
        view.layer.addSublayer(videoPreviewLayer)
        
        scanView.scanAnimationImage = animationImage
        
        scanView.scanAnimationStyle = animationStyle
        
        scanView.cornerColor = scannerColor

        scanView.popVCBolck = { [weak self] in
            self?.popVCBolck?()
        }
        scanView.rightButtonBlock = { [weak self] in
            self?.rightButtonBlock?()
        }
        view.addSubview(scanView)
        
        setupCamera()
        
    }
    
    
    
    // 设置相机
    func setupCamera() {
        
        setupSessionInput()
        
        setupSessionOutput()
        
    }
    
    
    //捕获设备输入流
    private  func setupSessionInput() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        guard let device = captureDevice else {
            return
        }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: device)
            
            captureSession.beginConfiguration()
            
            if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
                captureSession.removeInput(currentInput)
            }
            
            captureSession.addInput(newInput)
            
            captureSession.commitConfiguration()
            
        }catch{
            delegate?.didReceiveError(error)
        }
        
    }
    
    //捕获元数据输出流
    private func setupSessionOutput() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput()

        
        captureSession.addOutput(videoDataOutput)
        
        let output = AVCaptureMetadataOutput()
        
        captureSession.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        for type in metadata {
            if !output.availableMetadataObjectTypes.contains(type){
                return
            }
        }
        
        output.metadataObjectTypes = metadata
        
        videoPreviewLayer?.session = captureSession
        
        view.setNeedsLayout()
    }
    
    
    
    /// 开始扫描
    func startCapturing() {
        
        guard !Platform.isSimulator else {
            print("模拟器")
            return
        }
        
        captureSession.startRunning()

    }
    
    
    /// 停止扫描
    func stopCapturing() {
        
        guard !Platform.isSimulator else {
            return
        }
        
        captureSession.stopRunning()
        
    }
    
    
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension CameraViewController:AVCaptureMetadataOutputObjectsDelegate{
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        stopCapturing()
        
        delegate?.didOutput(object.stringValue ?? "")
        
    }
    
}


extension CameraViewController {
    public func imageNamed(_ name:String)-> UIImage{
        let bundle = Bundle(for: type(of: self))
        guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else{
            return UIImage()
        }

        return image

    }
}
