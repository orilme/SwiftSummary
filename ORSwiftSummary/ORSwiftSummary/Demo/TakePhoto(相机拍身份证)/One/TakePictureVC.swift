//
//  TakePictureVC.swift
//  ORSwiftSummary
//
//  Created by orilme on 2020/3/4.
//  Copyright © 2020 orilme. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import Photos

class TakePictureVC: UIViewController {

    var isUsingFrontFacingCamera:Bool = false // 切换前置后置摄像头，默认后置
    var imageRect:CGRect?
    var image:UIImage?
    var session:AVCaptureSession? // 输入和输出设备之间的数据传递
    var videoInput:AVCaptureDeviceInput? // 输入设备
    var stillImageOutput:AVCaptureStillImageOutput? // 照片输出流
    var previewLayer:AVCaptureVideoPreviewLayer? // 预览图片层
    
    var shouldWriteToSavedPhotos:Bool = true

    public var getImage : ((_ image: UIImage)->Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startRunning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopRunning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGray
        self.initAVCaptureSession()
        self.initCameraOverlayView()
    }
    
    func initCameraOverlayView() {
        let imageVWidth = UIScreen.WIDTH - 2 * 17
        let imageVHeight = imageVWidth * 234/342
        let imageVY = (UIScreen.HEIGHT - imageVHeight) * 0.5 - 60
        let windowLayer = CAShapeLayer.init()
        windowLayer.frame = CGRect(x: 37, y: imageVY + 22, width: imageVWidth - 40, height: imageVHeight - 44)
        self.view.layer.addSublayer(windowLayer)
        // 最里层镂空
        let transparentRoundedRectPath: UIBezierPath = UIBezierPath.init(roundedRect: windowLayer.frame, cornerRadius: 0)
        // 最外层背景
        let path = UIBezierPath.init(rect: UIScreen.main.bounds)
        path.append(transparentRoundedRectPath)
        path.usesEvenOddFillRule = true
        let fillLayer = CAShapeLayer.init()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = .evenOdd
        fillLayer.fillColor = UIColor.lightGray.cgColor
        fillLayer.opacity = 1
        self.view.layer.addSublayer(fillLayer)
        
        let imageV = UIImageView.init(frame: CGRect(x: 17, y: imageVY, width: imageVWidth, height: imageVHeight))
        imageV.image = UIImage.init(named: "photo_take_area")
        self.view.addSubview(imageV)
        self.imageRect = windowLayer.frame
      
        let label = UILabel.init(frame: CGRect(x: 0, y: imageVY + imageVHeight + 20, width: UIScreen.WIDTH, height: 22))
        label.textAlignment = .center
        label.text = "请把身份证放入相框内"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        self.view.addSubview(label)
        
        let takePhotoBtn = UIButton.init(frame: CGRect(x: UIScreen.WIDTH/2-30, y: UIScreen.HEIGHT - 100, width: 60, height: 60))
        takePhotoBtn.setImage(UIImage.init(named: "photo_take_btn"), for: .normal)
        takePhotoBtn.layer.borderColor = UIColor.red.cgColor
        takePhotoBtn.layer.borderWidth = 0.2
        takePhotoBtn.addTarget(self, action: #selector(takeAPicture), for: .touchUpInside)
        self.view.addSubview(takePhotoBtn)
        
        let closeBtn = UIButton.init(frame: CGRect(x: 17, y: 26, width: 20, height: 20))
        closeBtn.setImage(UIImage.init(named: "photo_close_btn"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeTakePicture), for: .touchUpInside)
        self.view.addSubview(closeBtn)
    }
    
    func initAVCaptureSession() {
        self.session = AVCaptureSession()
        if self.session?.canSetSessionPreset(AVCaptureSession.Preset.high) ?? false {
            self.session?.sessionPreset = AVCaptureSession.Preset.high
        }
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                try device.lockForConfiguration() // 更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
                device.flashMode = .auto
                device.unlockForConfiguration()
            } catch let error {
                print(error)
            }
            
            self.videoInput = try! AVCaptureDeviceInput.init(device: device)

        }

        // 照片输出流
        self.stillImageOutput = AVCaptureStillImageOutput()

        // 设置输出图片格式
//        let outputSettings = [AVVideoCodecKey : AVVideoCodecType.jpeg]
//        self.stillImageOutput?.outputSettings = outputSettings
        
        if let videoInput = self.videoInput, self.session!.canAddInput(videoInput) {
            self.session!.addInput(videoInput)
        }
        if let stillImageOutput = self.stillImageOutput, self.session!.canAddOutput(stillImageOutput) {
            self.session!.addOutput(stillImageOutput)
        }
        // 初始化预览层
        self.previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session!)
        self.previewLayer?.videoGravity = .resizeAspectFill
        self.previewLayer?.frame = CGRect(x: 0, y: 0, width: UIScreen.WIDTH, height: UIScreen.HEIGHT)
        self.view.layer.addSublayer(self.previewLayer!)
        self.imageRect = self.previewLayer?.frame
    }
    
    func startRunning() {
        self.session?.startRunning()
    }
    
    func stopRunning() {
        self.session?.stopRunning()
    }
    
    // 获取设备方向
    func getOrientationForDeviceOrientation(deviceOrientation:UIDeviceOrientation) -> AVCaptureVideoOrientation {
        if (deviceOrientation == .landscapeLeft) {
            return AVCaptureVideoOrientation.landscapeRight
        } else if ( deviceOrientation == .landscapeRight){
            return AVCaptureVideoOrientation.landscapeLeft
        }
        return AVCaptureVideoOrientation.portrait
    }
    
    // 拍照
    @objc func takeAPicture() {
        if let stillImageConnection = self.stillImageOutput?.connection(with: .video) {
            let curDeviceOrientation = UIDevice.current.orientation
            let avOrientation = self.getOrientationForDeviceOrientation(deviceOrientation: curDeviceOrientation)
            stillImageConnection.videoOrientation =  avOrientation
            self.stillImageOutput?.captureStillImageAsynchronously(from: stillImageConnection) { [weak self] (imageDataSampleBuffer, error) in
                guard let self = self else { return }
                guard let imageDataSampleBuffer = imageDataSampleBuffer else{ return }
                guard let jpegData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer) else { return }
                guard var image = UIImage.init(data: jpegData) else{ return }
                image = image.imageScaleToSize(image: image, size: CGSize(width: UIScreen.WIDTH, height: UIScreen.HEIGHT)) ?? UIImage()
                image = image.imageFromImageInRect(image: image, rect: self.imageRect!) ?? UIImage()
                self.image = image
                // 写入相册
                if (self.shouldWriteToSavedPhotos) {
                    self.writeToSavedPhotos()
                }
                self.getImage?(image)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // 写入相册
    func writeToSavedPhotos() {
        // 判断授权状态
        PHPhotoLibrary.requestAuthorization { (status) in
            if (status != .authorized) { return }
            /// 异步执行修改操作
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: self.image!)
            }) { (success, error) in
                if ((error) != nil) {
                    print("保存失败---")
                } else {
                    print("保存成功---")
                }
            }
        }
    }
    
    // 切换前置后置镜头
    func setFrontOrBackFacingCamera() {
        isUsingFrontFacingCamera = !isUsingFrontFacingCamera
        var desiredPosition:AVCaptureDevice.Position = .front
        if (isUsingFrontFacingCamera){
            desiredPosition = .back
        }else {
            desiredPosition = .front
        }
    
        for device in AVCaptureDevice.devices() {
            if (device.position == desiredPosition) {
                
                self.previewLayer?.session?.beginConfiguration()
                let input = try? AVCaptureDeviceInput.init(device: device)
                if let i = input, let inputs = self.previewLayer?.session?.inputs  {
                    for oldInput in inputs {
                        self.previewLayer?.session?.removeInput(oldInput)
                    }
                    self.previewLayer?.session?.addInput(i)
                    self.previewLayer?.session?.commitConfiguration()
                    break;
                }
                
            }
        }
    }
    
    // 取消拍照
    @objc func closeTakePicture() {
        self.dismiss(animated: true, completion: nil)
    }

}
