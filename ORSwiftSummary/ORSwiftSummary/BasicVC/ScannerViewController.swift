//
//  ScannerVC.swift
//  SwiftScanner
//
//  Created by Jason on 2018/11/30.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit
import AVFoundation

public class ScannerViewController: UIViewController {

    public lazy var cameraViewController:CameraViewController = .init()

    /// Capture session.
    public lazy var captureSession = AVCaptureSession()
    
    /// 动画样式
    public var animationStyle:ScanAnimationStyle = .default{
        didSet{
            cameraViewController.animationStyle = animationStyle
        }
    }

    fileprivate var popVCBolck : (()-> Void)?
    fileprivate var rightButtonBlock : (()-> Void)?
    
    // 扫描框颜色
    public var scannerColor:UIColor = .red{
        didSet{
            cameraViewController.scannerColor = scannerColor
        }
    }
    
    public var scannerTips:String = ""{
        didSet{
           cameraViewController.scanView.tips = scannerTips
        }
    }
    
    /// `AVCaptureMetadataOutput` metadata object types.
    public var metadata = AVMetadataObject.ObjectType.metadata {
        didSet{
            cameraViewController.metadata = metadata
        }
    }
    
    public var successBlock:((String)->())?
    
    public var errorBlock:((Error)->())?

    public var failClouse:((String)->())?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraViewController.startCapturing()
    }

    //MARK: 隐藏提示视图
    @objc func hiddenNoCodeFoundView() {
        self.noCodeFoundView.isHidden = true
        self.tipView.isHidden = true
    }

    lazy var tipView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        self.view.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.noCodeFoundView.snp.centerX)
            make.centerY.equalTo(self.noCodeFoundView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 100, height: 38))
        })


        return view
    }()

    lazy var noCodeTipLabel: UILabel = {
        let label = UILabel()
        label.text = "未发现二维码"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        self.tipView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.left.equalTo(self.tipView.snp.left)
            make.top.equalTo(self.tipView.snp.top)
            make.width.equalTo(self.tipView.snp.width)
            make.height.equalTo(21)
        })
        return label
    }()

    lazy var continueScanLabel: UILabel = {
        let label = UILabel()
        label.text = "轻触屏幕继续扫描"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .red
        self.tipView.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.left.equalTo(self.tipView.snp.left)
            make.width.equalTo(self.tipView.snp.width)
            make.top.equalTo(self.noCodeTipLabel.snp.bottom).offset(1)
            make.height.equalTo(16)
        })
        return label
    }()

    lazy var noCodeFoundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .black
        view.alpha = 0.5
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenNoCodeFoundView))
        view.addGestureRecognizer(tap)
        return view
    }()



    deinit {
        print("ScannerViewController释放了")
    }
}

// MARK: - CustomMethod
extension ScannerViewController{
    
    func setupUI() {
        
        view.backgroundColor = .black

        cameraViewController.metadata = metadata

        cameraViewController.animationStyle = animationStyle

        cameraViewController.delegate = self

        cameraViewController.popVCBolck = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        cameraViewController.rightButtonBlock = { [weak self] in
            self?.rightBtnClick()
        }

        add(cameraViewController)
        
        
    }
    
    
    public func setupScanner(_ color:UIColor? = nil, _ style:ScanAnimationStyle? = nil, _ tips:String? = nil, _ success:@escaping ((String)->())){
        

        if color != nil {
            scannerColor = color!
        }
        
        if style != nil {
            animationStyle = style!
        }
        
        if tips != nil {
            scannerTips = tips!
        }
        
        successBlock = success

    }

    func rightBtnClick() {
        //判断相册权限
        LimitsTools.share.authorizePhotoLibrary { [weak self] (status) in
            guard let wself = self else { return }
            print(status)
            if status == .authorized {
                //途径为相册
                let sourceType = UIImagePickerController.SourceType.photoLibrary
                //判断相册是否有故障
                if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
                    wself.failClouse?("打开相册有故障")
                    return
                }
                DispatchQueue.main.async {
                    let imagePickerVC = UIImagePickerController()
                    imagePickerVC.delegate = wself
                    wself.present(imagePickerVC, animated: true, completion: nil)
                }
            }else if status == .denied || status == .restricted {
                DispatchQueue.main.async {
                    let accessPhotoAlbumViewController = AccessPhotoAlbumViewController()
                    wself.navigationController?.pushViewController(accessPhotoAlbumViewController, animated: true)
                }
            }
        }
    }
    
}

// MARK: UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension ScannerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //选取照片后的回调方法
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1.取出选中的图片
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        guard let ciImage = CIImage(image: image) else { return }

        // 2.从选中的图片中读取二维码数据
        // 2.1创建一个探测器
        // CIDetectorTypeFace -- 探测器还可以搞人脸识别
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])

        // 2.2利用探测器探测数据
        if let result = detector?.features(in: ciImage).first {
            let resultStr = (result as! CIQRCodeFeature).messageString ?? ""
            if resultStr.isEmpty {
                print(resultStr)
//                self.failClouse?("")
            } else {
                picker.dismiss(animated: true, completion: {
                    print(resultStr)
                    //跳转界面
                    self.successBlock?(resultStr)
                })
                return
            }
        } else {
            self.failClouse?("不是二维码")
            self.cameraViewController.stopCapturing()
            self.view.addSubview(self.noCodeFoundView)
            self.noCodeTipLabel.isHidden = false
            self.continueScanLabel.isHidden = false
            self.noCodeTipLabel.text = "未发现二维码"
            self.continueScanLabel.text = "轻触屏幕继续扫描"

        }

        // 注意: 如果实现了该方法, 当选中一张图片时系统就不会自动关闭相册控制器
        picker.dismiss(animated: true, completion: nil)
    }
}



extension ScannerViewController:CameraViewControllerDelegate{
    
    func didOutput(_ code: String) {
        successBlock?(code)
    }
    
    func didReceiveError(_ error: Error) {
        
        errorBlock?(error)
        
    }
    
}
